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

import { addLabel, Configs, getAnnotation } from 'kpt-functions';
import { isNamespace } from './gen/io.k8s.api.core.v1';

export const ANNOTATION_NAME = 'env';
export const ANNOTATION_VALUE = 'bundle';

export async function selectPolicies(configs: Configs) {
//   const annoteName = ANNOTATION_NAME
  const annotateValue = configs.getFunctionConfigValueOrThrow(ANNOTATION_VALUE);
  configs.get(isNamespace).forEach(n => addLabel(n, "hello", annotateValue));

  // this.getAll().filter(isKind) as Kind[];

  configs.get(isNamespace).filter(o => {
    const bundleValue = String(getAnnotation(o, ANNOTATION_NAME));
    return bundleValue != annotateValue;
  }).forEach(o => {
    configs.delete(o);
  });

  // configs.get(isNamespace).forEach(o => {
  //   const bundleValue = String(getAnnotation(o, ANNOTATION_NAME));
  //   const key = kubernetesKey(o);
  //   addLabel(o, "found_env", bundleValue);
  //   addLabel(o, "key", key);
  // });
}

selectPolicies.usage = `
Adds a label to all Namespaces.
`;
