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

package templates.gcp.GCPStorageClassConstraintV1

import data.test.fixtures.storage_class.assets.storage_buckets as fixture_buckets
import data.test.fixtures.storage_class.constraints as fixture_constraints

# Final all violations of our test cases
find_violations[violation] {
	asset := data.assets[_]
	constraint := data.test_constraints[_]
	issues := deny with input.asset as asset with input.constraint as constraint
	total_issues := count(issues)
	violation := issues[_]
}

# Test allowlist with single class and one exemption
violations_with_single_allowlist_exemption[violation] {
	constraints := [fixture_constraints.allowlist_one_exemption]
	found_violations := find_violations with data.assets as fixture_buckets
		 with data.test_constraints as constraints

	violation := found_violations[_]
}

test_storage_bucket_class_allowlist_one_exemption {
	found_violations := violations_with_single_allowlist_exemption

	count(found_violations) == 1

	found_violations[_].details.resource == "//storage.googleapis.com/my-storage-bucket-with-logging"
}
