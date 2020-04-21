"use strict";
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
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const markdown_table_1 = __importDefault(require("markdown-table"));
const path = __importStar(require("path"));
const common_1 = require("./common");
exports.SOURCE_DIR = "sink_dir";
exports.SINK_DIR = "sink_dir";
exports.BUNDLE_DIR = "bundles";
exports.OVERWRITE = "overwrite";
const FILE_PATTERN_MD = "/**/*.+(md)";
function generateDocs(configs) {
    return __awaiter(this, void 0, void 0, function* () {
        // Get the parameters
        const sinkDir = configs.getFunctionConfigValueOrThrow(exports.SINK_DIR);
        const overwrite = configs.getFunctionConfigValue(exports.OVERWRITE) === "true";
        // Create bundle dir and writer
        const bundleDir = path.join(sinkDir, exports.BUNDLE_DIR);
        const fileWriter = new common_1.FileWriter(bundleDir, overwrite, FILE_PATTERN_MD);
        // Build the policy library
        const library = new common_1.PolicyLibrary(configs.getAll());
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
            return !common_1.PolicyConfig.isPolicyObject(o);
        })
            .forEach(o => {
            configs.delete(o);
        });
    });
}
exports.generateDocs = generateDocs;
function generateIndexDoc(fileWriter, library, sinkDir) {
    // Templates
    const templates = [["Template", "Samples"]];
    library
        .getTemplates()
        .sort(common_1.PolicyConfig.compare)
        .forEach(o => {
        const constraints = library.getOfKind(o.spec.crd.spec.names.kind);
        const templateLink = `[${common_1.PolicyConfig.getName(o)}](${common_1.PolicyConfig.getPath(o)})`;
        const samples = constraints
            .map(c => `[${common_1.PolicyConfig.getName(c)}](${common_1.PolicyConfig.getPath(c)})`)
            .join(", ");
        templates.push([templateLink, samples]);
    });
    // Samples
    const samples = [["Sample", "Template", "Description"]];
    library
        .getAll()
        .filter(o => {
        return o.kind !== common_1.CT_KIND;
    })
        .sort(common_1.PolicyConfig.compare)
        .forEach(o => {
        const name = `[${common_1.PolicyConfig.getName(o)}](${common_1.PolicyConfig.getPath(o)})`;
        const description = common_1.PolicyConfig.getDescription(o);
        const ct = library.getTemplate(o.kind);
        const ctName = ct ? `[Link](${common_1.PolicyConfig.getPath(ct)})` : "";
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

${markdown_table_1.default(templates)}

## Sample Constraints

The repo also contains a number of sample constraints:

${markdown_table_1.default(samples)}
`;
    const templateDocPath = path.join(sinkDir, "index.md");
    fileWriter.write(templateDocPath, templateDoc);
}
function generateBundleDocs(bundleDir, fileWriter, library) {
    library.bundles.forEach(bundle => {
        const constraints = [["Constraint", "Control", "Description"]];
        bundle
            .getConfigs()
            .sort(common_1.PolicyConfig.compare)
            .forEach(o => {
            const name = `[${common_1.PolicyConfig.getName(o)}](${common_1.PolicyConfig.getPath(o, "../../")})`;
            const control = bundle.getControl(o);
            const description = common_1.PolicyConfig.getDescription(o);
            constraints.push([name, control, description]);
        });
        const contents = `# ${bundle.getName()}

## Constraints

${markdown_table_1.default(constraints)}

`;
        const file = path.join(bundleDir, `${bundle.getKey()}.md`);
        fileWriter.write(file, contents);
    });
}
generateDocs.usage = `
Creates a directory of markdown documentation.

Configured using a ConfigMap with the following keys:
${exports.SINK_DIR}: Path to the config directory to write to.
${exports.OVERWRITE}: [Optional] If 'true', overwrite existing YAML files. Otherwise, fail if any YAML files exist.
Example:
apiVersion: v1
kind: ConfigMap
data:
  ${exports.SINK_DIR}: /path/to/sink/dir
  ${exports.OVERWRITE}: 'true'
metadata:
  name: my-config
`;
//# sourceMappingURL=generate_docs.js.map