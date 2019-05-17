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

import data.test.fixtures.assets.compute_disks as fixture_disks
import data.test.fixtures.assets.compute_instances as fixture_instances
import data.test.fixtures.constraints as fixture_constraints

# Final all violations of our test cases

find_violations[violation] {
	trace(sprintf("Asset count: %v", [count(data.assets)]))
	asset := data.assets[_]
	constraint := data.test_constraints[_]
	issues := deny with input.asset as asset with input.constraint as constraint
	total_issues := count(issues)
	violation := issues[_]
}

# Test logic for whitelisting/blacklisting
test_target_zone_match_count_whitelist {
	target_zone_match_count("whitelist", match_count)
	match_count = 0
}

test_target_zone_match_count_blacklist {
	target_zone_match_count("blacklist", match_count)
	match_count = 1
}

# Confirm no violations with no assets
test_compute_zone_no_assets {
	found_violations := find_violations with data.assets as []

	count(found_violations) = 0
}

# Confirm no violations with no constraints
test_compute_zone_no_constraints {
	trace(sprintf("fixture_instances count: %v", [count(fixture_instances)]))
	trace(sprintf("fixture_disks count: %v", [count(fixture_disks)]))
	combined_assets := array.concat(fixture_instances, fixture_disks)
	trace(sprintf("combined_assets count: %v", [count(combined_assets)]))
	found_violations := find_violations with data.assets as combined_assets
		 with data.constraints as []

	count(found_violations) = 0
}

# Confirm no violations with empty parameters
violations_with_empty_parameters[violation] {
	constraints := [fixture_constraints.compute_zone_default]
	combined_assets := array.concat(fixture_instances, fixture_disks)
	found_violations := find_violations with data.assets as combined_assets
		 with data.test_constraints as constraints

	violation := found_violations[_]
}

test_compute_zone_default {
	found_violations := violations_with_empty_parameters

	count(found_violations) = 0
}

# Confirm empty blacklist works
violations_with_empty_blacklist[violation] {
	constraints := [fixture_constraints.compute_zone_allow_all]
	combined_assets := array.concat(fixture_instances, fixture_disks)
	found_violations := find_violations with data.assets as combined_assets
		 with data.test_constraints as constraints

	violation := found_violations[_]
}

test_compute_zone_allow_all {
	found_violations := violations_with_empty_blacklist

	count(found_violations) = 0
}

# Confirm single blacklisted zone works
violations_with_single_blacklist[violation] {
	constraints := [fixture_constraints.compute_zone_deny_one]
	combined_assets := array.concat(fixture_instances, fixture_disks)
	found_violations := find_violations with data.assets as combined_assets
		 with data.test_constraints as constraints

	violation := found_violations[_]
}

test_compute_zone_deny_one {
	found_violations := violations_with_single_blacklist
	count(found_violations) = 1

	violation := found_violations[_]
	resource_name := "//compute.googleapis.com/projects/sandbox2/zones/us-west1-b/disks/disk-asia-west1-b"
	is_string(violation.msg)
	is_object(violation.details)
}
