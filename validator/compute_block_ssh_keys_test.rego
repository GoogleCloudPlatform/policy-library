#
# Copyright 2021 Google LLC
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
package templates.gcp.GCPComputeBlockSSHKeysConstraintV1

import data.test.fixtures.compute_block_ssh_keys.assets as fixture_instances
import data.test.fixtures.compute_block_ssh_keys.constraints as fixture_constraints

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
test_block_ssh_keys_no_instances {
	found_violations := find_violations with data.instances as []
	count(found_violations) = 0
}

test_block_ssh_keys_no_constraints {
	found_violations := find_violations with data.instances as fixture_instances
		 with data.constraints as []

	count(found_violations) = 0
}
