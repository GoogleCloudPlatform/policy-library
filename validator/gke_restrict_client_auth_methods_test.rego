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

package templates.gcp.GCPGKERestrictClientAuthenticationMethodsConstraintV1

import data.validator.gcp.lib as lib

all_violations[violation] {
	resource := data.test.fixtures.gke_restrict_client_auth_methods.assets[_]
	constraint := data.test.fixtures.gke_restrict_client_auth_methods.constraints.restrict_gke_client_auth_methods

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

test_master_auth_not_specified {
	violation := all_violations[_]
	violation.details.resource == "//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/joe-clust"
}

test_issue_client_cert_set_to_true {
	violation := all_violations[_]
	violation.details.resource == "//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/joe-clust2"
}

test_issue_client_cert_set_to_false {
	violation := all_violations[_]
	resource_names := {x | x = violation.details.resource; violation.details.resource == "//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/joe-clust3"}
	count(resource_names) == 0
}

test_username_empty {
	violation := all_violations[_]
	resource_names := {x | x = violation.details.resource; violation.details.resource == "//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/joe-clust4"}
	count(resource_names) == 0
}

test_username_non_empty {
	violation := all_violations[_]
	violation.details.resource == "//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/joe-clust5"
}

test_username_empty_and_issue_client_cert_set_to_false {
	violation := all_violations[_]
	resource_names := {x | x = violation.details.resource; violation.details.resource == "//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/joe-clust6"}
	count(resource_names) == 0
}
