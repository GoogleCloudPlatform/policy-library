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

all_violations[violation] {
	resource := data.test.fixtures.bigquery_dataset_world_readable.assets[_]
	constraint := data.test.fixtures.bigquery_dataset_world_readable.constraints

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

# Confirm total violations count
test_bigquery_iam_violations_count {
	count(all_violations) == 1
}

test_bigquery_iam_violations {
	all_violations[_].details.resource == "//bigquery.googleapis.com/projects/test-project/datasets/world-readable"
}
