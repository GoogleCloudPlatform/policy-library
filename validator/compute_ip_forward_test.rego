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

package templates.gcp.GCPComputeIpForwardConstraintV1

import data.test.fixtures.compute_ip_forward.assets as fixture_instances
import data.test.fixtures.compute_ip_forward.constraints as fixture_constraints

# Find all violations on our test cases
find_violations[violation] {
	instance := data.instances[_]
	constraint := data.test_constraints[_]

	issues := deny with input.asset as instance
		 with input.constraint as constraint

	total_issues := count(issues)

	violation := issues[_]
}

# Confim no violations with no instances
test_ip_forward_no_instances {
	found_violations := find_violations with data.instances as []

	count(found_violations) = 0
}

test_ip_forward_no_constraints {
	found_violations := find_violations with data.instances as fixture_instances
		 with data.constraints as []

	count(found_violations) = 0
}

violations_with_empty_parameters[violation] {
	constraints := [fixture_constraints.forbid_ip_forward_default]

	found_violations := find_violations with data.instances as fixture_instances
		 with data.test_constraints as constraints

	violation := found_violations[_]
}

test_ip_forward_default {
	found_violations := violations_with_empty_parameters

	count(found_violations) = 2
}

whitelist_violations[violation] {
	constraints := [fixture_constraints.forbid_ip_forward_whitelist]

	found_violations := find_violations with data.instances as fixture_instances
		 with data.test_constraints as constraints

	violation := found_violations[_]
}

# Confirm only a single violation was found (whitelist constraint)
test_ip_forward_whitelist_violates_one {
	found_violations := whitelist_violations

	count(found_violations) = 1

	violation := found_violations[_]
	resource_name := "//compute.googleapis.com/projects/test-project/zones/us-east1-b/instances/vm-ip-forward"

	is_string(violation.msg)
	is_object(violation.details)
}

no_violation_due_to_whitelist[violation] {
	constraints := [fixture_constraints.forbid_ip_forward_whitelist_all]

	found_violations := find_violations with data.instances as fixture_instances
		 with data.test_constraints as constraints

	violation := found_violations[_]
}

# Confirm no violation when both VMs with exernal IP are whitelisted.
test_ip_forward_whitelist_all {
	found_violations := no_violation_due_to_whitelist

	count(found_violations) = 0
}

blacklist_violations[violation] {
	constraints := [fixture_constraints.forbid_ip_forward_blacklist]

	found_violations := find_violations with data.instances as fixture_instances
		 with data.test_constraints as constraints

	violation := found_violations[_]
}

test_ip_forward_blacklist_violates_one {
	found_violations := blacklist_violations

	count(found_violations) = 1
}

two_blacklist_violations[violation] {
	constraints := [fixture_constraints.forbid_ip_forward_blacklist_all]

	found_violations := find_violations with data.instances as fixture_instances
		 with data.test_constraints as constraints

	violation := found_violations[_]
}

# Confirm we get 2 violations when both VMs with external IP are blacklisted.
test_ip_forward_blacklist_all {
	found_violations := two_blacklist_violations

	count(found_violations) = 2
}

test_blacklist_violations_regex {
	constraints := [fixture_constraints.forbid_ip_forward_regex_blacklist_all]

	found_violations := find_violations with data.instances as fixture_instances
		 with data.test_constraints as constraints

	count(found_violations) == 2
}

test_whitelist_violations_regex {
	constraints := [fixture_constraints.forbid_ip_forward_regex_whitelist_all]

	found_violations := find_violations with data.instances as fixture_instances
		 with data.test_constraints as constraints

	count(found_violations) == 0
}

test_instance_name_targeted_whitelist {
	not instance_name_targeted("//compute/vm1", ["//compute/vm.*", "//compute/nomatch"], "whitelist", "regex")
	not instance_name_targeted("//compute/vm1", ["//compute/vm1", "//compute/nomatch"], "whitelist", "exact")
}

test_instance_name_targeted_whitelist_nomatch {
	instance_name_targeted("//compute/vm1", ["//compute/nomatch1", "//compute/nomatch2"], "whitelist", "regex")
	instance_name_targeted("//compute/vm1", ["//compute/nomatch1", "//compute/nomatch2"], "whitelist", "exact")
}

test_instance_name_targeted_blacklist {
	instance_name_targeted("//compute/vm1", ["//compute/vm.*", "//compute/nomatch"], "blacklist", "regex")
	instance_name_targeted("//compute/vm1", ["//compute/vm1", "//compute/nomatch"], "blacklist", "exact")
}
