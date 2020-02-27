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

package templates.gcp.GCPReportSharedVPCHostProjectConstraintV1

# Confirm total violations count
all_violations[output] {
	resource := data.test.fixtures.report_shared_vpc_projects.assets[_]
	constraint := data.test.fixtures.report_shared_vpc_projects.constraints

	output := deny[_] with input.asset as resource
		 with input.constraint as constraint
}

test_all_violations {
	count(all_violations) == 1
}
