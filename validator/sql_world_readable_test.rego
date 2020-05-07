#
<<<<<<< HEAD
# Copyright 2020 Google LLC
=======
# Copyright 2018 Google LLC
>>>>>>> c091676d7a89b6003d414a615cb791479b746b4b
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

template_name := "GCPSQLWorldReadableConstraintV1"

import data.validator.test_utils as test_utils

import data.test.fixtures.sql_world_readable.assets as fixture_assets
import data.test.fixtures.sql_world_readable.constraints as fixture_constraints

test_sql_world_readable_violations_resources {
	expected_resource_names := {"//cloudsql.googleapis.com/projects/noble-history-87417/instances/authorized-networks-0"}

	test_utils.check_test_violations_resources(fixture_assets, [fixture_constraints], template_name, expected_resource_names)
}
