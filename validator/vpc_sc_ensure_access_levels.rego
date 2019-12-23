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

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	asset := input.asset

	asset.asset_type == "cloudresourcemanager.googleapis.com/Organization"
	lib.has_field(asset, "service_perimeter")

	lib.get_constraint_params(constraint, params)
	mode := lib.get_default(params, "mode", "require")

	perimeter_access_levels_raw := {split(r, "/") | r = asset.service_perimeter.status.access_levels[_]}
	perimeter_access_levels := {r[3] | r = perimeter_access_levels_raw[_]}

	# For compatibility reasons, we support the old key name required_access_levels
	configured_access_levels := cast_set(lib.get_default(params, "access_levels", lib.get_default(params, "required_access_levels", [])))

	check_access_level(perimeter_access_levels, configured_access_levels, mode)

	message := sprintf("Invalid access levels in service perimeter %v.", [asset.service_perimeter.name])

	metadata := {"resource": asset.name, "service_perimeter_name": asset.service_perimeter.name}
}

check_access_level(perimeter_access_levels, configured_access_levels, mode) {
	mode == "whitelist"
	perimeter := perimeter_access_levels[_]
	matches := {perimeter} & configured_access_levels
	count(matches) == 0
}

check_access_level(perimeter_access_levels, configured_access_levels, mode) {
	mode == "blacklist"
	perimeter := perimeter_access_levels[_]
	matches := {perimeter} & configured_access_levels
	count(matches) > 0
}

check_access_level(perimeter_access_levels, configured_access_levels, mode) {
	mode == "require"
	intersection := perimeter_access_levels & configured_access_levels
	count(intersection) != count(configured_access_levels)
}
