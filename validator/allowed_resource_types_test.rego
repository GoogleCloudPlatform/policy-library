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

template_name := "GCPAllowedResourceTypesConstraintV1"

import data.validator.gcp.lib as lib
import data.validator.test_utils as test_utils

#Importing the test data
import data.test.fixtures.allowed_resource_types.assets as fixture_assets

# Importing the test constraints
import data.test.fixtures.allowed_resource_types.constraints.basic.blacklist as fixture_constraint_basic_blacklist
import data.test.fixtures.allowed_resource_types.constraints.basic.whitelist as fixture_constraint_basic_whitelist

test_allowed_resource_types_whitelist_violations {
	expected_resource_names := {
		"//bigtable.googleapis.com/projects/my-test-project/instances/test-bigtable-id-valid-labels",
		"//compute.googleapis.com/projects/my-test-project/zones/us-east1-b/disks/instance-1-valid-disk",
		"//storage.googleapis.com/bucket-with-valid-labels",
	}

	test_utils.check_test_violations(fixture_assets, [fixture_constraint_basic_whitelist], template_name, 3, expected_resource_names)
}
