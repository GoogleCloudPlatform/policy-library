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

package templates.gcp.GKEClusterLocationConstraintV1

all_violations[violation] {
	resource := data.test.fixtures.gke_cluster_location.assets[_]
	constraint := data.test.fixtures.gke_cluster_location.constraints

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

test_gke_cluster_location_violations_basic {
	count(all_violations) == 2

	resource_names := {x | x = all_violations[_].details.resource}

	expected_resource_name := {
		"//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/joe-clust",
		"//container.googleapis.com/projects/transfer-repos/zones/us-central1-c/clusters/joe-clust2",
	}

	resource_names == expected_resource_name

	violation := all_violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}
