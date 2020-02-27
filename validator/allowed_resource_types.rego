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

package templates.gcp.GCPAllowedResourceTypesConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)

	asset := input.asset

	# Retrieve the current mode if passed, use "whitelist" as a default
	mode := lower(lib.get_default(params, "mode", "whitelist"))

	# Retrieve the resource types list - default to empty set
	ressource_types_list := cast_set(lib.get_default(params, "resource_type_list", {}))

	# The asset raises a violation if resource_type_is_valid is evaluated to false (both of them)
	not resource_type_is_valid(mode, asset, ressource_types_list)

	message := sprintf("%v is in violation.", [asset.name])
	ancestry_path = lib.get_default(asset, "ancestry_path", "")
	metadata := {
		"resource": asset.name,
		"mode": mode,
		"resource_type_list": ressource_types_list,
		"ancestry_path": ancestry_path,
	}
}

###########################
# Rule Utilities
###########################

resource_type_is_valid(mode, asset, resource_type_list) {
	# anything other than blacklist is treated as "whitelist"
	mode != "blacklist"

	# Retrieve the asset type
	asset_type := asset.asset_type

	# the asset is valid if it's in the resource_type_list
	asset_type == resource_type_list[_]
}

resource_type_is_valid(mode, asset, resource_type_list) {
	# "if we are in a blacklist mode"
	mode == "blacklist"

	# Retrieve the asset type
	asset_type := asset.asset_type

	# the asset is valid only if it's not in the resource_type_list
	not resource_type_list[asset_type]
}
