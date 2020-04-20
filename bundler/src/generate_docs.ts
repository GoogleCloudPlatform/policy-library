/**
 * Copyright 2020 Google LLC
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

import { Configs } from "kpt-functions";
import mdTable from "markdown-table";
import * as path from "path";
import { CT_KIND, FileWriter, PolicyLibrary, PolicyConfig } from "./common";

export const SOURCE_DIR = "sink_dir";
export const SINK_DIR = "sink_dir";
export const BUNDLE_DIR = "bundles";
export const OVERWRITE = "overwrite";

const FILE_PATTERN_MD = "/**/*.+(md)";

export async function generateDocs(configs: Configs) {
  // Get the parameters
  const sinkDir = configs.getFunctionConfigValueOrThrow(SINK_DIR);
  const overwrite = configs.getFunctionConfigValue(OVERWRITE) === "true";

  // Create bundle dir and writer
  const bundleDir = path.join(sinkDir, BUNDLE_DIR);
  const fileWriter = new FileWriter(bundleDir, overwrite, FILE_PATTERN_MD);

  // Build the policy library
  const library = new PolicyLibrary(configs.getAll());

  // Document constraint templates and samples
  generateIndexDoc(fileWriter, library, sinkDir);

  // Document bundles
  generateBundleDocs(bundleDir, fileWriter, library);

  // Remove old docs
  fileWriter.finish();

  // filter out non-policy objects
  configs
    .getAll()
    .filter(o => {
      return !PolicyConfig.isPolicyObject(o);
    })
    .forEach(o => {
      configs.delete(o);
    });
}

function generateIndexDoc(
  fileWriter: FileWriter,
  library: PolicyLibrary,
  sinkDir: string
) {
  // Templates
  const templates = [["Template", "Samples"]];
  library
    .getTemplates()
    .sort(PolicyConfig.compare)
    .forEach(o => {
      const constraints = library.getOfKind(
        (o as any).spec.crd.spec.names.kind
      );
      const templateLink = `[${PolicyConfig.getName(o)}](${PolicyConfig.getPath(
        o
      )})`;
      const samples = constraints
        .map(c => `[${PolicyConfig.getName(c)}](${PolicyConfig.getPath(c)})`)
        .join(", ");
      templates.push([templateLink, samples]);
    });

  // Samples
  const samples = [["Sample", "Template", "Description"]];
  library
    .getAll()
    .filter(o => {
      return o.kind !== CT_KIND;
    })
    .sort(PolicyConfig.compare)
    .forEach(o => {
      const name = `[${PolicyConfig.getName(o)}](${PolicyConfig.getPath(o)})`;
      const description = PolicyConfig.getDescription(o);
      const ct = library.getTemplate(o.kind);
      const ctName = ct ? `[Link](${PolicyConfig.getPath(ct)})` : "";

      samples.push([name, ctName, description]);
    });

  const templateDoc = `# Config Validator Policy Library

Constraint templates specify the logic to be used by constraints.
This repository contains pre-defined constraint templates that you can implement or modify for your own needs. 

## Creating a constraint template
You can create and implement your own custom constraint templates.
For instructions on how to write constraint templates, see [How to write your own constraint templates](./constraint_template_authoring.md).

## Policy Bundles
In addition to browsing all [Available Templates](#available-templates) and [Sample Constraints](#sample-constraints),
you can explore these policy bundles:

- [CFT Scorecard](./bundles/scorecard-v1.md)
- [CIS v1.0](./bundles/cis-v1.0.md)
- [CIS v1.1](./bundles/cis-v1.1.md)
- [Forseti Security](./bundles/forseti-security.md)
- [GKE Hardening](./bundles/gke-hardening-v2019.11.11.md)

## Available Templates

${mdTable(templates)}

## Sample Constraints

The repo also contains a number of sample constraints:

${mdTable(samples)}
`;

  const templateDocPath = path.join(sinkDir, "index.md");
  fileWriter.write(templateDocPath, templateDoc);
}

function generateBundleDocs(
  bundleDir: string,
  fileWriter: FileWriter,
  library: PolicyLibrary
) {
  library.bundles.forEach(bundle => {
    const constraints = [["Constraint", "Control", "Description"]];
    bundle
      .getConfigs()
      .sort(PolicyConfig.compare)
      .forEach(o => {
        const name = `[${PolicyConfig.getName(o)}](${PolicyConfig.getPath(
          o,
          "../../"
        )})`;
        const control = bundle.getControl(o);
        const description = PolicyConfig.getDescription(o);

        constraints.push([name, control, description]);
      });

    const contents = `# ${bundle.getName()}

This bundle can be installed via kpt:

\`\`\`
export BUNDLE=${bundle.getName()}
kpt pkg get https://github.com/forseti-security/policy-library.git ./policy-library
kpt fn source policy-library/samples/ | \
  kpt fn run --image gcr.io/config-validator/get_policy_bundle:latest -- bundle=$BUNDLE | \
  kpt fn sink policy-library/policies/constraints/
\`\`\`

## Constraints

${mdTable(constraints)}

`;

    const file = path.join(bundleDir, `${bundle.getKey()}.md`);
    fileWriter.write(file, contents);
  });
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
