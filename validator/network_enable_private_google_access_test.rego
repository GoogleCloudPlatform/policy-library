#
# Copyright 2019 Google LLC
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

package templates.gcp.GCPNetworkEnablePrivateGoogleAccessConstraintV1

import data.validator.gcp.lib as lib

all_violations[violation] {
	resource := data.test.fixtures.network_enable_private_google_access.assets[_]
	constraint := data.test.fixtures.network_enable_private_google_access.constraints

	issues := deny with input.asset as resource
		 with input.constraint as constraint
		 with data.inventory as data.test.fixtures.network_enable_private_google_access.assets

	violation := issues[_]
}

test_private_google_access_enabled {
	violation := all_violations[_]
	resource_names := {x | x = violation.details.resource}
	not resource_names["//compute.googleapis.com/projects/pso-cicd8/regions/us-west1/subnetworks/correct"]
}

test_private_google_access_disabled {
	count(all_violations) == 1

	resource_names := {x | x = all_violations[_].details.resource}

	expected_resource_name := {"//compute.googleapis.com/projects/pso-cicd8/regions/us-west1/subnetworks/bad"}

	resource_names == expected_resource_name

	violation := all_violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}
