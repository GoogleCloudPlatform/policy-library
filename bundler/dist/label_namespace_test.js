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
const label_namespace_1 = require("./label_namespace");
const io_k8s_api_core_v1_1 = require("./gen/io.k8s.api.core.v1");
const TEST_NAMESPACE = 'testNamespace';
const TEST_LABEL_NAME = 'costCenter';
const TEST_LABEL_VALUE = 'xyz';
describe('labelNamespace', () => {
    let functionConfig = io_k8s_api_core_v1_1.ConfigMap.named('foo');
    functionConfig.data = {};
    functionConfig.data[label_namespace_1.LABEL_NAME] = TEST_LABEL_NAME;
    functionConfig.data[label_namespace_1.LABEL_VALUE] = TEST_LABEL_VALUE;
    const RUNNER = new kpt_functions_1.TestRunner(label_namespace_1.labelNamespace);
    it('empty input ok', RUNNER.assertCallback(new kpt_functions_1.Configs(undefined, functionConfig)));
    it('requires functionConfig', RUNNER.assertCallback(undefined, undefined, kpt_functions_1.ConfigError));
    it('adds label namespace when metadata.labels is undefined', () => __awaiter(void 0, void 0, void 0, function* () {
        const actual = new kpt_functions_1.Configs(undefined, functionConfig);
        actual.insert(io_k8s_api_core_v1_1.Namespace.named(TEST_NAMESPACE));
        const expected = new kpt_functions_1.Configs();
        expected.insert(new io_k8s_api_core_v1_1.Namespace({
            metadata: {
                name: TEST_NAMESPACE,
                labels: { [TEST_LABEL_NAME]: TEST_LABEL_VALUE }
            }
        }));
        yield RUNNER.assert(actual, expected);
    }));
    it('adds label to namespace when metadata.labels is defined', () => __awaiter(void 0, void 0, void 0, function* () {
        const actual = new kpt_functions_1.Configs(undefined, functionConfig);
        actual.insert(new io_k8s_api_core_v1_1.Namespace({
            metadata: {
                name: TEST_NAMESPACE,
                labels: { a: 'b' }
            }
        }));
        const expected = new kpt_functions_1.Configs();
        expected.insert(new io_k8s_api_core_v1_1.Namespace({
            metadata: {
                name: TEST_NAMESPACE,
                labels: {
                    a: 'b',
                    [TEST_LABEL_NAME]: TEST_LABEL_VALUE
                }
            }
        }));
        yield RUNNER.assert(actual, expected);
    }));
});
//# sourceMappingURL=label_namespace_test.js.map