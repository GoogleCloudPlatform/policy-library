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

package templates.gcp.GKEDashboardConstraintV1

all_violations[violation] {
	resource := data.test.fixtures.assets.gke[_]
	constraint := data.test.fixtures.constraints.disable_gke_dashboard

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

# Confirm total violations count
test_dashboard_disable_violations_count {
	count(all_violations) == 1
}

test_dashboard_disable_violations_basic {
	violation := all_violations[_]
	violation.details.resource == "//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/joe-clust"
}
