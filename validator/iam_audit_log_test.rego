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


package templates.gcp.GCPIAMAuditLogConstraintV1

template_name := "GCPIAMAuditLogConstraintV1"

import data.validator.gcp.lib as lib
import data.validator.test_utils as test_utils

# Importing the test data
import data.test.fixtures.iam_audit_log.assets as fixture_assets

# Importing the test constraint
import data.test.fixtures.iam_audit_log.constraints as fixture_constraints

test_audit_logs {
	expected_resource_names := {
		"//cloudresourcemanager.googleapis.com/projects/wrong-service",
		"//cloudresourcemanager.googleapis.com/projects/wrong-log-type",
		"//cloudresourcemanager.googleapis.com/projects/unexpected-exemption"
	}

	test_utils.check_test_violations_resources(fixture_assets, [fixture_constraints], template_name, expected_resource_names)
}
