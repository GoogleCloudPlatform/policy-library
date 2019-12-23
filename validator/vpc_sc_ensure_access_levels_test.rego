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

package templates.gcp.GCPVPCSCEnsureAccessLevelsConstraintV1

import data.validator.gcp.lib as lib

old_style_violations[violation] {
	resource := data.test.fixtures.vpc_sc_ensure_access_levels.assets[_]
	constraint := data.test.fixtures.vpc_sc_ensure_access_levels.constraints.old

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

require_violations[violation] {
	resource := data.test.fixtures.vpc_sc_ensure_access_levels.assets[_]
	constraint := data.test.fixtures.vpc_sc_ensure_access_levels.constraints.require

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

whitelist_violations[violation] {
	resource := data.test.fixtures.vpc_sc_ensure_access_levels.assets[_]
	constraint := data.test.fixtures.vpc_sc_ensure_access_levels.constraints.whitelist

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

blacklist_violations[violation] {
	resource := data.test.fixtures.vpc_sc_ensure_access_levels.assets[_]
	constraint := data.test.fixtures.vpc_sc_ensure_access_levels.constraints.blacklist

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

test_violations_old_style {
	violation_resources := {r | r = old_style_violations[_].details.service_perimeter_name}
	violation_resources == {"accessPolicies/1008882730434/servicePerimeters/Test_Service_Perimeter_Bad"}
}

test_violations_require {
	violation_resources := {r | r = require_violations[_].details.service_perimeter_name}
	violation_resources == {"accessPolicies/1008882730434/servicePerimeters/Test_Service_Perimeter_Bad"}
}

test_violations_whitelist {
	violation_resources := {r | r = whitelist_violations[_].details.service_perimeter_name}
	violation_resources == {"accessPolicies/1008882730433/servicePerimeters/Test_Service_Perimeter_Good"}
}

test_violations_blacklist {
	violation_resources := {r | r = blacklist_violations[_].details.service_perimeter_name}
	violation_resources == {"accessPolicies/1008882730433/servicePerimeters/Test_Service_Perimeter_Good"}
}
