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

package templates.gcp.GCPAllowedResourceTypesConstraintV1

import data.validator.gcp.lib as lib

#Importing the test data
import data.test.fixtures.allowed_resource_types.assets as fixture_assets

# Importing the test constraints
import data.test.fixtures.allowed_resource_types.constraints.basic.blacklist as fixture_constraint_basic_blacklist
import data.test.fixtures.allowed_resource_types.constraints.basic.whitelist as fixture_constraint_basic_whitelist

# Find all violations on our test cases
find_all_violations[violation] {
	resources := data.resources[_]
	constraint := data.test_constraints[_]
	issues := deny with input.asset as resources
		 with input.constraint as constraint

	violation := issues[_]
}

blacklist_violations[violation] {
	constraints := [fixture_constraint_basic_blacklist]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

whitelist_violations[violation] {
	constraints := [fixture_constraint_basic_whitelist]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_allowed_resource_types_basic_blacklist_violations {
	violations := blacklist_violations

	count(violations) == 3

	resource_names := {x | x = violations[_].details.resource}

	expected_resource_name := {
		"//dataproc.googleapis.com/projects/my-own-project/regions/global/jobs/job-b068791b-dataproc-job-ok",
		"//cloudsql.googleapis.com/projects/my-test-project/instances/cloudsql-instance-1-valid",
		"//compute.googleapis.com/projects/my-test-project/zones/us-central1-b/instances/valid-instance-8hz5",
	}

	resource_names == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

test_allowed_resource_types_whitelist_violations {
	violations := whitelist_violations

	count(violations) == 3

	resource_names := {x | x = violations[_].details.resource}

	expected_resource_name := {
		"//bigtable.googleapis.com/projects/my-test-project/instances/test-bigtable-id-valid-labels",
		"//compute.googleapis.com/projects/my-test-project/zones/us-east1-b/disks/instance-1-valid-disk",
		"//storage.googleapis.com/bucket-with-valid-labels",
	}

	resource_names == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}
