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

package templates.gcp.GCPBigQueryCMEKEncryptionConstraintV1

# Importing the test constraints
import data.test.fixtures.bigquery_cmek.constraints as fixture_constraint

test_bigquery_cmek_logic {
	violations := [violation |
		violations := deny with input.asset as data.test.fixtures.bigquery_cmek.assets[_]
			 with input.constraint as fixture_constraint

		violation := violations[_]
	]

	count(violations) == 1

	violation := violations[_]
	violation.details.resource == "//bigquery.googleapis.com/projects/anand-spanner/datasets/anand_bq_test_3/tables/test_google_encryption_key"
}
