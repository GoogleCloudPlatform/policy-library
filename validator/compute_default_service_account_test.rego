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

package templates.gcp.GCPComputeDefaultServiceAccountConstraintV1

import data.validator.gcp.lib as lib

import data.test.fixtures.compute_default_service_account.assets as fixture_assets
import data.test.fixtures.compute_default_service_account.constraints as fixture_constraints

# Find all violations of our test cases

find_violations[violation] {
	asset := data.assets[_]
	constraint := data.test_constraints[_]
	issues := deny with input.asset as asset with input.constraint as constraint
	total_issues := count(issues)
	violation := issues[_]
}

violations_check_account_only[violation] {
	constraints := [fixture_constraints.checkaccountonly]
	found_violations := find_violations with data.assets as fixture_assets
		 with data.test_constraints as constraints

	violation := found_violations[_]
}

test_violations_check_account_only {
	found_violations := violations_check_account_only

	count(found_violations) == 2
}

violations_check_full_scope[violation] {
	constraints := [fixture_constraints.checkfullscope]
	found_violations := find_violations with data.assets as fixture_assets
		 with data.test_constraints as constraints

	violation := found_violations[_]
}

test_violations_check_full_scope {
	found_violations := violations_check_full_scope

	count(found_violations) == 1
}
