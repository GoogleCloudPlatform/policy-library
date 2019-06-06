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

package templates.gcp.GCPAlwaysViolatesConstraintV1

# Confirm total violations count
always_violates_all_violations[output] {
	resource := data.test.fixtures.always_violates.assets[_]
	constraint := data.test.fixtures.always_violates.constraints.always_violates_all

	output := deny[_] with input.asset as resource
		 with input.constraint as constraint
}

test_always_violates_all_violations {
	count(always_violates_all_violations) == count(data.test.fixtures.always_violates.assets)
}
