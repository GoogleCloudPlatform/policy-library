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

  // If bundle diretory is not empty, require 'overwrite' parameter to be set.
  const docFiles = listDocFiles(bundleDir);
  if (!overwrite && docFiles.length > 0) {
    throw new Error(
      `sink dir contains files and overwrite is not set to string 'true'.`
    );
  }

  const filesToDelete = new Set(docFiles);


  // Build the policy library
  const library = new PolicyLibrary(configs.getAll());

  library.bundles.forEach((bundle) => {
    const constraints = [["Constraint", "Control", "Description"]];
    bundle.getConfigs().forEach((o) => {
      const name = `[${o.metadata.name}](${getPath(o)})`;
      const control = bundle.getControl(o);
      const description = getDescription(o);

      // console.log("name", name);
    
      constraints.push([name, control, description]);
    });

    const contents = `# ${bundle.getName()}

## Constraints

${mdTable(constraints)}

`;

    const file = path.join(bundleDir, `${bundle.getKey()}.md`);

    if (fs.existsSync(file)) {
      filesToDelete.delete(file);
      const currentContents = fs.readFileSync(file).toString();
      if (contents == currentContents) {
        // No changes to make.
        return;
      }
    }

    fs.writeFileSync(file, contents, 'utf8');
  });

  // Delete files that are missing from the new docs.
  // Other file types are ignored.
  filesToDelete.forEach(file => {
    fs.unlinkSync(file);
  });


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

  constructor(configs: KubernetesObject[]) {
      this.bundles = new Map();

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
          this.addPolicy(bundle, control, o);
        });
      });
  }

  addPolicy(bundleKey: string, control: string, policy: KubernetesObject) {
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

function getDescription(o: KubernetesObject): string {
  return getAnnotation(o, "description") || "";
}

function getPath(o: KubernetesObject): string {
  return path.join("../../samples", getAnnotation(o, "config.kubernetes.io/path"));
}

function listDocFiles(dir: string): string[] {
  if (!existsSync(dir)) {
    mkdirSync(dir, { recursive: true });
  }
  return glob.sync(dir + '/**/*.+(md)');
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
