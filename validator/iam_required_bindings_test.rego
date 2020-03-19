#
# Copyright 2020 Google LLC
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

package templates.gcp.GCPIAMRequiredBindingsConstraintV1

import data.test.fixtures.iam_required_bindings.assets as fixture_assets
import data.test.fixtures.iam_required_bindings.constraints as fixture_constraints

# Find all violations on our test cases
find_violations[violation] {
	asset := fixture_assets[_]
	constraint := data.test_constraints[_]

	issues := deny with input.asset as asset
		 with input.constraint as constraint

	total_issues := count(issues)

	violation := issues[_]
}

# Test that a required domain is absent in data
require_role_domain_violations[violation] {
	constraints := [fixture_constraints.iam_required_bindings_role_domain]

	found_violations := find_violations with data.test_constraints as constraints

	violation := found_violations[_]
}

test_require_role_domain_violations {
	count(require_role_domain_violations) = 2
	violation := require_role_domain_violations[_]
	violation.details.role == "roles/owner"
	violation.details.required_member == "user:*@required-group.com"
}

# Test that a required member is absent in data
require_role_member_violations[violation] {
	constraints := [fixture_constraints.iam_required_bindings_role_members]

	found_violations := find_violations with data.test_constraints as constraints

	violation := found_violations[_]
}

test_require_role_member_violations {
	count(require_role_member_violations) = 2
	violation := require_role_member_violations[_]
	violation.details.role == "roles/owner"
	violation.details.required_member == "user:required@notgoogle.com"
}

# Test that only Project resources are parsed
require_project_violations[violation] {
	constraints := [fixture_constraints.iam_required_bindings_project]

	found_violations := find_violations with data.test_constraints as constraints

	violation := found_violations[_]
}

test_require_project_violations {
	count(require_project_violations) = 3
}

# Test for no violations
require_role_no_violations[violation] {
	constraints := [fixture_constraints.iam_required_bindings_role_domain_all]

	found_violations := find_violations with data.test_constraints as constraints

	violation := found_violations[_]
}

test_require_role_no_violations {
	count(require_role_no_violations) = 0
}

# Test with empty members params
require_no_members_params[violation] {
	constraints := [fixture_constraints.iam_required_bindings_none]

	found_violations := find_violations with data.test_constraints as constraints

	violation := found_violations[_]
}

test_require_role_no_violations {
	count(require_no_members_params) = 0
}
