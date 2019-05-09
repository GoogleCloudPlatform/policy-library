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

package templates.gcp.GCPSQLSSLV1

all_violations[violation] {
	# Selecting only the Cloud SQL resources relevant for this test
	resource_list := [test_data |
		fixture_data := data.test.fixtures.assets.cloudsql[_]
		startswith(fixture_data.name, "//cloudsql.googleapis.com/projects/noble-history-87417/instances/sql-ssl")
		test_data := fixture_data
	]

	resource := resource_list[_]

	constraint := data.test.fixtures.constraints.require_sql_ssl

	issues := deny with input.asset as resource
	violation := issues[_]
}

# Confirm total violations count
test_sql_ssl_violations_count {
	trace(sprintf("Violations: %d", [count(all_violations)]))
	count(all_violations) == 1
}

test_sql_ssl_violations_basic {
	violation := all_violations[_]
	violation.details.resource == "//cloudsql.googleapis.com/projects/noble-history-87417/instances/sql-ssl-not-required"
}
