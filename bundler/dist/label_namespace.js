"use strict";
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
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const kpt_functions_1 = require("kpt-functions");
const io_k8s_api_core_v1_1 = require("./gen/io.k8s.api.core.v1");
exports.LABEL_NAME = 'label_name';
exports.LABEL_VALUE = 'label_value';
function labelNamespace(configs) {
    return __awaiter(this, void 0, void 0, function* () {
        const labelName = configs.getFunctionConfigValueOrThrow(exports.LABEL_NAME);
        const labelValue = configs.getFunctionConfigValueOrThrow(exports.LABEL_VALUE);
        configs.get(io_k8s_api_core_v1_1.isNamespace).forEach(n => kpt_functions_1.addLabel(n, labelName, labelValue));
    });
}
exports.labelNamespace = labelNamespace;
labelNamespace.usage = `
Adds a label to all Namespaces.

Configured using a ConfigMap with the following keys:

${exports.LABEL_NAME}: Label name to add to Namespaces.
${exports.LABEL_VALUE}: Label value to add to Namespaces.

Example:

To add a label 'color: orange' to Namespaces:

apiVersion: v1
kind: ConfigMap
data:
  ${exports.LABEL_NAME}: color
  ${exports.LABEL_VALUE}: orange
metadata:
  name: my-config
`;
//# sourceMappingURL=label_namespace.js.map