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

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	asset := input.asset
	asset.asset_type == "container.googleapis.com/Cluster"

	cluster_location := asset.resource.data.location
	target_location := params.allowed_locations
	count({cluster_location} & cast_set(target_location)) == 0

	message := sprintf("Cluster %v is not allowed in the specified location", [asset.name])
	metadata := {"resource": asset.name}
}

###########################
# Rule Utilities
###########################
