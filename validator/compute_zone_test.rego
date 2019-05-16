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

package templates.gcp.GCPComputeZoneV1

import data.test.fixtures.asset.compute_disks as fixture_disks
import data.test.fixtures.asset.compute_instances as fixture_instances
import data.test.fixtures.constraints as fixture_constraints

# Final all violations of our test cases

find_violations[violation] {
	sprintf("Asset count: %v", [count(data.assets)])
	asset := data.assets[_]
	constraint := data.test_constraints[_]
	issues := deny with input.asset as asset with input.constraint as constraint
	total_issues := count(issues)
	violation := count(issues)
}

allow_one_violations[violation] {
	constraints := [fixture_constraints.compute_zone_allow_one]
	combined_assets = fixture_instances | fixture_disks
	found_violations := find_violations with data.assets as combined_assets with data.test_constraints as constraints
	violation := found_violations[_]
}

test_compute_zone_allow_one {
	found_violations := allow_one_violations

	#count(found_violations) = (count(fixture_instances) + count(fixture_disks)) - 1
	count(found_violations) = 1
	violation := found_violations[_]
	resource_name := "//compute.googleapis.com/projects/remund-sandbox2/zones/us-west1-b/disks/disk-asia-west1-b"
}

#is_string(violation.msg)
#is_object(violation.details)
