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

package templates.gcp.GCPBigQueryDatasetWorldReadableConstraintV1

template_name := "GCPBigQueryDatasetWorldReadableConstraintV1"

import data.validator.test_utils as test_utils

test_bigquery_iam_violations {
	expected_resource_names := {
		"//bigquery.googleapis.com/projects/test-project/datasets/world-readable-allUsers",
		"//bigquery.googleapis.com/projects/test-project/datasets/world-readable-allAuthenticatedUsers",
		"//bigquery.googleapis.com/projects/test-project/datasets/world-readable-both",
		# TODO: fix the (existing) bug in this constraint:
		"//bigquery.googleapis.com/projects/test-project/datasets/not-world-readable",
	}

	test_utils.check_test_violations(data.test.fixtures.bigquery_dataset_world_readable.assets, [data.test.fixtures.bigquery_dataset_world_readable.constraints], template_name, expected_resource_names)
}
