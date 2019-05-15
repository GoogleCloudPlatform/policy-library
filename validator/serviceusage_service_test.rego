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

package templates.gcp.GCPServiceUsageConstraintV1

all_violations_allow[violation] {
	resource := data.test.fixtures.assets.service_usage_services[_]
	constraint := data.test.fixtures.constraints.serviceusage_allow_compute

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

all_violations_disallow[violation] {
	resource := data.test.fixtures.assets.service_usage_services[_]
	constraint := data.test.fixtures.constraints.serviceusage_disallow_cloudvisionapi

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

# Confirm total allow violations count
test_serviceusage_allow_violations_count {
	count(all_violations_allow) == 1
}

# Confirm that cloudvision violates because it is not on the allowed list
test_serviceusage_allow_violations_basic {
	violation := all_violations_allow[_]
	violation.details.resource == "//serviceusage.googleapis.com/projects/123/services/cloudvision.googleapis.com"
	violation.details.mode == "allowed"
}

# Confirm total disallow violations count
test_serviceusage_disallow_violations_count {
	count(all_violations_disallow) == 1
}

# Confirm that cloudvision violates because is on the disallowed list
test_serviceusage_disallow_violations_basic {
	violation := all_violations_disallow[_]
	violation.details.resource == "//serviceusage.googleapis.com/projects/123/services/cloudvision.googleapis.com"
	violation.details.mode == "disallowed"
}
