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

package templates.gcp.GCPStorageClassConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)

	asset := input.asset
	asset.asset_type == "storage.googleapis.com/Bucket"

	# Check if resource is in exempt list
	exempt_list := params.exemptions
	matches := {asset.name} & cast_set(exempt_list)
	count(matches) == 0

	# Check that storage class is in allowlist/denylist
	is_class_allowed := class_allowed with data.target_storage_classes as params.classes
		 with data.asset_storage_class as asset.resource.data.storageClass
		 with data.mode as params.mode

	is_class_allowed != true

	message := sprintf("%v is in a disallowed storage class.", [asset.name])
	metadata := {"resource": asset.name}
}

###########################
# Rule Utilities
###########################
default class_allowed = false

class_allowed {
	target_storage_classes := data.target_storage_classes
	asset_storage_class := data.asset_storage_class

	class_matches := ({upper(asset_storage_class)} & cast_set(target_storage_classes)) | ({lower(asset_storage_class)} & cast_set(target_storage_classes))
	desired_count := target_match_count(data.mode)
	count(class_matches) != desired_count
}

# Determine the overlap between locations under test and constraint
# By default (allowlist), we violate if there isn't overlap
target_match_count(mode) = 0 {
	mode != "denylist"
}

target_match_count(mode) = 1 {
	mode == "denylist"
}

target_match_count(mode) = 1 {
	mode == "blacklist"
}

# target_match_count(mode) {
# 	if mode == "denylist":
# 		return 1
# 	else:
# 		return 0
# }
