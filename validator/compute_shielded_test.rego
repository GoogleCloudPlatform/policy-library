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

package templates.gcp.GCPComputeShieldedConstraintV1

import data.test.fixtures.compute_shielded.assets as fixture_instances
import data.test.fixtures.compute_shielded.constraints as fixture_constraints

# Find all violations on our test cases
find_violations[violation] {
	instance := data.instances[_]
	constraint := data.test_constraints[_]

	issues := deny with input.asset as instance
		 with input.constraint as constraint

	total_issues := count(issues)

	violation := issues[_]
}

violations_with_empty_parameters[violation] {
	constraints := [fixture_constraints.shielded_default]

	found_violations := find_violations with data.instances as fixture_instances
		 with data.test_constraints as constraints

	violation := found_violations[_]
}

test_shielded_default {
	found_violations := violations_with_empty_parameters

	count(found_violations) = 2
}
