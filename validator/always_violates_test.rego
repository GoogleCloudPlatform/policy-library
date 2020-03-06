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
test_always_violates_all_violations {
	violations := [violation | violations := deny with input.asset as data.test.fixtures.always_violates.assets[_]
		with input.constraint as data.test.fixtures.always_violates.constraints.always_violates_all
		violation := violations[_]]

	count(violations) == count(data.test.fixtures.always_violates.assets)
}
