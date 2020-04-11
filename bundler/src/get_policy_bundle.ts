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

import { Configs } from 'kpt-functions';
import { PolicyLibrary } from './common'

export const ANNOTATION_NAME = 'bundle';
export const SINK_DIR = 'sink_dir';
export const OVERWRITE = 'overwrite';

export async function getPolicyBundle(configs: Configs) {
  // Get the paramters
  const annotationName = configs.getFunctionConfigValueOrThrow(ANNOTATION_NAME);
  const sinkDir = configs.getFunctionConfigValue(SINK_DIR);
  const overwrite = configs.getFunctionConfigValue(OVERWRITE) === 'true';
  
  // Build the policy library
  const library = new PolicyLibrary(configs.getAll());

  // Get bundle
  const bundle = library.bundles.get(annotationName);
  if (bundle === undefined) {
    throw new Error(
      `bundle does not exist: ` + annotationName + `.`
    );
  }

  // Write bundle to sink dir
  if (sinkDir) {
    bundle.write(sinkDir, overwrite);
  }

  // Return the bundle
  configs.deleteAll();
  configs.insert(...bundle.configs);
}

getPolicyBundle.usage = `
Get policy bundle of constraints based on annoation.

Configured using a ConfigMap with the following keys:
${ANNOTATION_NAME}: Name of the policy bundle.
${SINK_DIR}: [Optional] Path to the config directory to write to; will create if it does not exist.
${OVERWRITE}: [Optional] If 'true', overwrite existing YAML files. Otherwise, fail if any YAML files exist.
Example:
apiVersion: v1
kind: ConfigMap
data:
  ${ANNOTATION_NAME}: 'bundles.validator.forsetisecurity.org/cis-v1.1'
  ${SINK_DIR}: /path/to/sink/dir
  ${OVERWRITE}: 'true'
metadata:
  name: my-config
`;
