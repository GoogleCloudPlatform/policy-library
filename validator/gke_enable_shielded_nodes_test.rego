#
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package templates.gcp.GCPGKEEnableShieldedNodesConstraintV1

import data.validator.gcp.lib as lib

all_violations[violation] {
	resource := data.test.fixtures.gke_enable_shielded_nodes.assets[_]
	constraint := data.test.fixtures.gke_enable_shielded_nodes.constraints.enable_shielded_nodes

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

# Tests that the nodes with shielded nodes disabled at the cluster are detected
test_disabled_shielded_nodes {
	violation := all_violations[_]
	resource_names := {x | x = violation.details.resource}

	trace(sprintf("Resource not expected: %s", [resource_names]))
	not resource_names["//container.googleapicom/projects/transfer-repo/zones/us-central1-c/clusters/shielded-enabled"]
	resource_in_violation(resource_names)
}

resource_in_violation(resource_names) {
	resource_names["//container.googleapis.com/projects/transfer-repo/zones/us-central1-c/clusters/shielded-nodes-disabled"]
}

resouce_in_violation(resource_names) {
	resource_names["//container.googleapis.com/projects/transfer-repo/zones/us-central1-c/clusters/shielded-nodes-enabled-noboot"]
}
