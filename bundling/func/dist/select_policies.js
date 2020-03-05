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
exports.ANNOTATION_NAME = 'env';
exports.ANNOTATION_VALUE = 'bundle';
function selectPolicies(configs) {
    return __awaiter(this, void 0, void 0, function* () {
        //   const annoteName = ANNOTATION_NAME
        const annotateValue = configs.getFunctionConfigValueOrThrow(exports.ANNOTATION_VALUE);
        configs.get(io_k8s_api_core_v1_1.isNamespace).forEach(n => kpt_functions_1.addLabel(n, "hello", annotateValue));
        // this.getAll().filter(isKind) as Kind[];
        configs.get(io_k8s_api_core_v1_1.isNamespace).filter(o => {
            // const bundleValue = String(getAnnotation(o, ANNOTATION_NAME));
            return true;
        }).forEach(o => {
            configs.delete(o);
        });
        // configs.get(isNamespace).forEach(o => {
        //   const bundleValue = String(getAnnotation(o, ANNOTATION_NAME));
        //   const key = kubernetesKey(o);
        //   addLabel(o, "found_env", bundleValue);
        //   addLabel(o, "key", key);
        // });
    });
}
exports.selectPolicies = selectPolicies;
selectPolicies.usage = `
Adds a label to all Namespaces.
`;
//# sourceMappingURL=select_policies.js.map