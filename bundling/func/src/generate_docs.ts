/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import * as fs from 'fs';
import { existsSync, mkdirSync } from 'fs';
import * as glob from 'glob';
import { Configs, getAnnotation } from 'kpt-functions';
import * as path from 'path';
import { BUNDLE_ANNOTATION_REGEX } from './common'
import { KubernetesObject, KubernetesObjectError, getAnnotation } from 'kpt-functions';

const mdTable = require('markdown-table');
export const SOURCE_DIR = 'SOURCE_DIR';
export const SOURCE_DIR = 'sink_dir';
export const SINK_DIR = 'sink_dir';
export const BUNDLE_DIR = 'bundles';
export const OVERWRITE = 'overwrite';

const CT_KIND = 'ConstraintTemplate';
const SUPPORTED_API_VERSIONS = /^(constraints|templates).gatekeeper.sh\/v1(.+)$/g 

export async function generateDocs(configs: Configs) {
  // Get the paramters.
  const sinkDir = configs.getFunctionConfigValueOrThrow(SINK_DIR);
  const overwrite = configs.getFunctionConfigValue(OVERWRITE) === 'true';

  // Ensure bundle directory exists
  const bundleDir = path.join(sinkDir, BUNDLE_DIR);
  if (!fs.existsSync(bundleDir)) {
    fs.mkdirSync(bundleDir, { recursive: true });
  }

  const fileWriter = new FileWriter(bundleDir, overwrite);

  // Build the policy library
  const library = new PolicyLibrary(configs.getAll());

  // Document constraint templates
  const templates = [["Template", "Samples"]];
  library.getOfKind(CT_KIND).forEach((o) => {
    const constraints = library.getOfKind(o.spec.crd.spec.names.kind);
    templates.push([
      `[${getName(o)}](${getPath(o)})`,
      constraints.map((c) => `[${getName(c)}](${getPath(c)})`).join(', ')
    ]);
  });

  const samples = [["Sample", "Template", "Description"]];
  library.getAll().filter(o => {
    return o.kind != CT_KIND;
  }).forEach((o) => {
    const name = `[${getName(o)}](${getPath(o)})`;
    const description = getDescription(o);
    const ct = library.getTemplate(o.kind);
    const ctName = ct ? `[${getName(ct)}](${getPath(ct)})` : "";

    samples.push([name, ctName, description]);
  });

  const templateDoc = `# Config Validator Constraint Templates

Constraint templates specify the logic to be used by constraints.
This repository contains pre-defined constraint templates that you can implement or modify for your own needs. 

## Creating a constraint template
You can create and implement your own custom constraint templates.
For instructions on how to write constraint templates, see [How to write your own constraint templates](./constraint_template_authoring.md).

## Available Templates

${mdTable(templates)}

## Sample Constraints

The repo also contains a number of sample constraints:

${mdTable(samples)}
`;

  const templateDocPath = path.join(sinkDir, "index.md");
  fileWriter.write(templateDocPath, templateDoc);

  // Document bundles
  library.bundles.forEach((bundle) => {
    const constraints = [["Constraint", "Control", "Description"]];
    bundle.getConfigs().forEach((o) => {
      const name = `[${getName(o)}](${getPath(o)})`;
      const control = bundle.getControl(o);
      const description = getDescription(o);
    
      constraints.push([name, control, description]);
    });

    const contents = `# ${bundle.getName()}

## Constraints

${mdTable(constraints)}

`;

    const file = path.join(bundleDir, `${bundle.getKey()}.md`);

    fileWriter.write(file, contents);
  });

  fileWriter.finish();

  // filter out non-policy objects
  configs.getAll().filter(o => {
    return true;
    // return !isPolicyObject(o);
  }).forEach(o => {
    configs.delete(o);
  });
}

class PolicyLibrary {
  bundles: map;
  configs: KubernetesObject[];

  constructor(configs: KubernetesObject[]) {
      this.bundles = new Map();

      this.configs = new Array(0;)

      configs.filter(o => {
        return isPolicyObject(o);
      }).forEach(o => {
        const annotations = o.metadata.annotations;
        Object.keys(annotations).forEach(annotation => {
          const result = annotation.match(BUNDLE_ANNOTATION_REGEX);
          if (!result) {
            return
          }
          const bundle = result[0];
          const control = annotations[annotation];
          this.bundlePolicy(bundle, control, o);
        });
        this.configs.push(o);
      });
  }

  getAll(): KubernetesObject[] {
    return this.configs;
  }

  getTemplates(): KubernetesObject[] {
    return this.getOfKind(CT_KIND);
  }

  getTemplate(kind: string): KubernetesObject {
    const matches = this.getTemplates().filter((o) => {
      return o.spec.crd.spec.names.kind === kind;
    });
    return matches[0] || null;
  }

  getOfKind(kind: string): KubernetesObject[] {
    return this.configs.filter((o) => {
      return o.kind === kind;
    });
  }

  bundlePolicy(bundleKey: string, control: string, policy: KubernetesObject) {
    let bundle = this.bundles.get(bundleKey);
    if (bundle === undefined) {
      bundle = new PolicyBundle(bundleKey);
      this.bundles.set(bundleKey, bundle);
    }

    bundle.addPolicy(policy);
  }
}

class PolicyBundle {
  key: string;
  configs: KubernetesObject[];
  constructor(annotation: string) {
    this.key = annotation;
    this.configs = new Array();
  }

  getName() {
    const matches = this.key.match(BUNDLE_ANNOTATION_REGEX);
    return matches[1];
  }

  getKey() {
    return this.getName();
  }

  addPolicy(policy: KubernetesObject) {
    this.configs.push(policy);
  }

  getConfigs() {
    return this.configs;
  }

  getControl(policy: KubernetesObject) {
    return getAnnotation(policy, this.key);
  }
}

function isPolicyObject(o: any): bool {
  return (
    o &&
    o.apiVersion != '' &&
    SUPPORTED_API_VERSIONS.test(o.apiVersion)
  );
}

function getName(o: KubernetesObject): string {
  if (o.kind === CT_KIND) {
    return o.spec.crd.spec.names.kind;
  }
  return o.metadata.name;
}

function getDescription(o: KubernetesObject): string {
  return getAnnotation(o, "description") || "";
}

function getPath(o: KubernetesObject): string {
  let basePath = "../../samples";
  if (o.kind === CT_KIND) {
    basePath = "../../policies/";
  }
  return path.join(basePath, getAnnotation(o, "config.kubernetes.io/path"));
}



class FileWriter {
  filesToDelete: set;

  constructor(bundleDir: string, overwrite: bool) {
    // If bundle diretory is not empty, require 'overwrite' parameter to be set.
    const docFiles = this.listDocFiles(bundleDir);
    if (!overwrite && docFiles.length > 0) {
      throw new Error(
        `sink dir contains files and overwrite is not set to string 'true'.`
      );
    }

    this.filesToDelete = new Set(docFiles);
  }

  finish() {
    // Delete files that are missing from the new docs.
    // Other file types are ignored.
    this.filesToDelete.forEach(file => {
      fs.unlinkSync(file);
    });
  }

  listDocFiles(dir: string): string[] {
    if (!existsSync(dir)) {
      mkdirSync(dir, { recursive: true });
    }
    return glob.sync(dir + '/**/*.+(md)');
  }

  write(file, contents) {
    this.filesToDelete.delete(file);

    if (fs.existsSync(file)) {
      this.filesToDelete.delete(file);
      const currentContents = fs.readFileSync(file).toString();
      if (contents == currentContents) {
        // No changes to make.
        return;
      }
    }

    fs.writeFileSync(file, contents, 'utf8');
  }
}

generateDocs.usage = `
Creates a directory of markdown documentation.

Configured using a ConfigMap with the following keys:
${SINK_DIR}: Path to the config directory to write to.
${OVERWRITE}: [Optional] If 'true', overwrite existing YAML files. Otherwise, fail if any YAML files exist.
Example:
apiVersion: v1
kind: ConfigMap
data:
  ${SINK_DIR}: /path/to/sink/dir
  ${OVERWRITE}: 'true'
metadata:
  name: my-config
`;
