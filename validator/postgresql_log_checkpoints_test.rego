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
package templates.gcp.GCPPostgreSQLCheckpointsConstraintV1

import data.validator.gcp.lib as lib
import data.validator.test_utils as test_utils

import data.test.fixtures.postgresql_log_checkpoints.assets.no_settings as fixture_no_settings
import data.test.fixtures.postgresql_log_checkpoints.assets.no_violations as fixture_no_violation
import data.test.fixtures.postgresql_log_checkpoints.assets.violations as fixture_violation

import data.test.fixtures.postgresql_log_checkpoints.constraints as fixture_constraints

template_name := "GCPPostgreSQLCheckpointsConstraintV1"

#1. postgresql with correct key
test_postgresql_log_checkpoints_no_violations {
	expected_resource_names := {"//cloudsql.googleapis.com/projects/prj-dev-palani-ram/instances/tf-pg-ha-62380f9c"}
	test_utils.check_test_violations_resources(fixture_no_violation, [fixture_constraints], template_name, expected_resource_names)
}

#2. postgresql without correct key
test_postgresql_log_checkpoints_violations {
	expected_resource_names := {"//cloudsql.googleapis.com/projects/prj-dev-palani-ram/instances/tf-pg-ha-62380f9c"}
	test_utils.check_test_violations_count(fixture_violation, [fixture_constraints], template_name, 1)
	test_utils.check_test_violations_resources(fixture_violation, [fixture_constraints], template_name, expected_resource_names)
}

#3. An instance without settings configured at all (settings doesn't exist).
test_postgresql_log_checkpoints_no_settings {
	expected_resource_names := {"//cloudsql.googleapis.com/projects/prj-dev-palani-ram/instances/tf-pg-ha-62380f9c"}
	expected_field_name := "key_in_violation"
	expected_field_values := {"log_checkpoints"}
	test_utils.check_test_violations_count(fixture_no_settings, [fixture_constraints], template_name, 1)
	test_utils.check_test_violations_resources(fixture_no_settings, [fixture_constraints], template_name, expected_resource_names)
	test_utils.check_test_violations_metadata(fixture_no_settings, [fixture_constraints], template_name, expected_field_name, expected_field_values)
}

