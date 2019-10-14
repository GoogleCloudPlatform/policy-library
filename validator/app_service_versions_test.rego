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

package templates.gcp.GCPAppEngineServiceVersionsConstraintV1

import data.test.fixtures.app_service_versions.assets as fixture_assets
import data.test.fixtures.app_service_versions.constraints as fixture_constraints

# Final all violations of our test cases
find_violations[violation] {
	asset := data.assets[_]
	constraint := data.test_constraints[_]
	issues := deny with input.asset as asset with input.constraint as constraint
	total_issues := count(issues)
	violation := issues[_]
}

# Test for default
violations_with_default_constraint[violation] {
	constraints := [fixture_constraints.default_constraint]
	found_violations := find_violations with data.assets as fixture_assets
		 with data.test_constraints as constraints

	violation := found_violations[_]
}

test_violations_with_default_constraint {
	found_violations := violations_with_default_constraint

	count(found_violations) == 1
}

# Test with customcount
violations_with_custom_constraint[violation] {
	constraints := [fixture_constraints.custom_count]
	found_violations := find_violations with data.assets as fixture_assets
		 with data.test_constraints as constraints

	violation := found_violations[_]
}

test_violations_with_custom_constraint {
	found_violations := violations_with_custom_constraint

	count(found_violations) == 2
}

test_violation_3_versions {
	violation := violations_with_custom_constraint[_]

	violation.details.resource = "//appengine.googleapis.com/apps/test-ae-example/services/three-versions"
}

test_violation_2_versions {
	violation := violations_with_custom_constraint[_]

	violation.details.resource = "//appengine.googleapis.com/apps/test-ae-example/services/two-versions"
}
