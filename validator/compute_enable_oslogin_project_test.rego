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
package templates.gcp.GCPComputeRequireOSLoginConstraintV1

import data.validator.gcp.lib as lib
import data.validator.test_utils as test_utils

# Importing the test data
import data.test.fixtures.compute_enable_oslogin.assets.compute.instance_no_violation as fixture_compute_instance_no_violation
import data.test.fixtures.compute_enable_oslogin.assets.compute.instance_violation as fixture_compute_instance_violation
import data.test.fixtures.compute_enable_oslogin.assets.compute.no_instances as fixture_compute_no_instance
import data.test.fixtures.compute_enable_oslogin.assets.compute.no_metadata as fixture_compute_instance_no_metadata

import data.test.fixtures.compute_enable_oslogin.constraints as fixture_constraint

template_name := "GCPComputeRequireOSLoginConstraintV1"

#### Testing for GCE instances

#1. No instances at all
test_enable_oslogin_project_compute_no_instances {
	expected_resource_names := {"//dns.googleapis.com/projects/186783260185/managedZones/correct"}
	test_utils.check_test_violations_count(fixture_compute_no_instance, [fixture_constraint], template_name, 1)
}

#2. One instance with correct key
test_enable_oslogin_project_compute_instance_no_violations {
	expected_resource_names := {"//compute.googleapis.com/projects/my-test-project/zones/us-central1-f/instances/test-jumphost"}
	test_utils.check_test_violations_count(fixture_compute_instance_no_violation, [fixture_constraint], template_name, 1)
}

#3. One instance without correct key
test_enable_oslogin_project_compute_instance_violations {
	expected_resource_names := {"//compute.googleapis.com/projects/my-test-project/zones/us-central1-f/instances/test-jumphost-violation"}
	test_utils.check_test_violations_count(fixture_compute_instance_violation, [fixture_constraint], template_name, 1)
}

#4. An instance without metadata configured at all (metadata_config doesn't exist).
test_enable_oslogin_project_compute_instance_no_metadata {
	expected_resource_names := {"//compute.googleapis.com/projects/my-test-project/zones/us-central1-f/instances/test-jumphost"}
	expected_field_name := "key_in_violation"
	expected_field_values := {"enable-oslogin"}
	test_utils.check_test_violations_count(fixture_compute_instance_no_metadata, [fixture_constraint], template_name, 1)
	test_utils.check_test_violations_resources(fixture_compute_instance_no_metadata, [fixture_constraint], template_name, expected_resource_names)
	test_utils.check_test_violations_signature(fixture_compute_instance_no_metadata, [fixture_constraint], template_name)
	test_utils.check_test_violations_metadata(fixture_compute_instance_no_metadata, [fixture_constraint], template_name, expected_field_name, expected_field_values)
}
