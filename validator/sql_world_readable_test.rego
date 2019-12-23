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

package templates.gcp.GCPSQLWorldReadableConstraintV1

import data.test.fixtures.sql_allowed_authorized_networks.constraints as fixture_constraints

all_violations[violation] {
	resource := data.test.fixtures.sql_world_readable.assets[_]
	constraint := data.test.fixtures.sql_world_readable.constraints

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

test_violations_basic {
	violation_resources := {r | r = all_violations[_].details.resource}
	violation_resources == {"//cloudsql.googleapis.com/projects/noble-history-87417/instances/authorized-networks-0"}
}
