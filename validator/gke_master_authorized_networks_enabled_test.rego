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

package templates.gcp.GCPGKEMasterAuthorizedNetworksEnabledConstraintV1

import data.validator.gcp.lib as lib

all_violations[violation] {
	resource := data.test.fixtures.gke_master_authorized_networks_enabled.assets[_]
	constraint := data.test.fixtures.gke_master_authorized_networks_enabled.constraints.enable_master_authorized_networks

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

test_no_master_auth_specified {
	violation := all_violations[_]
	violation.details.resource == "//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/joe-clust"
}

test_enable_master_auth_enabled {
	violation := all_violations[_]
	resource_names := {x | x = all_violations[_].details.resource}
	not resource_names["//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/joe-clust2"]
}

test_master_auth_disabled {
	violation := all_violations[_]
	violation.details.resource == "//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/joe-clust3"
}
