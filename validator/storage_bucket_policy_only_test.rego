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

package templates.gcp.GCPStorageBucketPolicyOnlyConstraintV1

import data.test.fixtures.storage_bucket_policy_only.assets as fixture_buckets

all_violations[violation] {
	constraint := data.test.fixtures.storage_bucket_policy_only.constraints.require_bucket_policy_only

	issues := deny with input.asset as fixture_buckets[_]
		 with input.constraint as constraint

	violation := issues[_]
}

# Confirm total violations count
test_storage_bucket_policy_only_violations_count {
	count(all_violations) == count(fixture_buckets) - 1
}

test_storage_bucket_policy_only_violations_no_data {
	violation := all_violations[_]
	violation.details.resource == "//storage.googleapis.com/my-storage-bucket-with-no-bucketpolicyonly-data"
}

test_storage_bucket_policy_only_violations_null_data {
	violation := all_violations[_]
	violation.details.resource == "//storage.googleapis.com/my-storage-bucket-with-null-bucketpolicyonly"
}
