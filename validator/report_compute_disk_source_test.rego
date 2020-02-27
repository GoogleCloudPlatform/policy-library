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

package templates.gcp.GCPReportComputeDiskSourceV1

import data.validator.gcp.lib as lib

all_violations[violation] {
	resource := data.test.fixtures.report_compute_disk_source.assets[_]
	constraint := data.test.fixtures.report_compute_disk_source.constraints

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

#test_all_violations {
#	count(all_violations) == 2
#}
