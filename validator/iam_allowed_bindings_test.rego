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

package templates.gcp.GCPIAMAllowedBindingsConstraintV1

import data.test.fixtures.iam_allowed_bindings.assets as fixture_assets
import data.test.fixtures.iam_allowed_bindings.constraints as fixture_constraints

# Find all violations on our test cases
find_violations[violation] {
	asset := fixture_assets[_]
	constraint := data.test_constraints[_]

	issues := deny with input.asset as asset
		 with input.constraint as constraint

	total_issues := count(issues)

	violation := issues[_]
}

blacklist_role_violations[violation] {
	constraints := [fixture_constraints.iam_allowed_bindings_blacklist_role]

	found_violations := find_violations with data.test_constraints as constraints

	violation := found_violations[_]
}

test_blacklist_role_violations {
	count(blacklist_role_violations) = 2
}

whitelist_role_domain_violations[violation] {
	constraints := [fixture_constraints.iam_allowed_bindings_whitelist_role_domain]

	found_violations := find_violations with data.test_constraints as constraints

	violation := found_violations[_]
}

test_whitelist_role_domain_violations {
	count(whitelist_role_domain_violations) = 1
	violation := whitelist_role_domain_violations[_]
	violation.details.role == "roles/owner"
	violation.details.member == "user:evil@notgoogle.com"
}

blacklist_public_violations[violation] {
	constraints := [fixture_constraints.iam_allowed_bindings_blacklist_public]

	found_violations := find_violations with data.test_constraints as constraints

	violation := found_violations[_]
}

test_blacklist_public_violations {
	count(blacklist_public_violations) = 2
}

# Try a constraint which shouldn't trigger any violations
whitelist_role_no_violations[violation] {
	constraints := [fixture_constraints.iam_allowed_bindings_whitelist_role_members]

	found_violations := find_violations with data.test_constraints as constraints

	violation := found_violations[_]
}

test_whitelist_role_no_violations {
	count(whitelist_role_no_violations) = 0
}
