#
# Copyright 2021 Google LLC
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

package templates.gcp.GCPComputeEnableOSLoginProjectConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	asset := input.asset
	asset.asset_type == "compute.googleapis.com/Instance"
	instance := asset.resource.data
	meta := lib.get_default(instance, "metadata", {"items": []})
	key = "enable-oslogin"

	# check if key is available and values are as expected
	not metadata_enable_oslogin(meta)

	message := sprintf("On this resource %v check the required key '%v' is in violation.", [asset.name, key])
	metadata := {"resource": asset.name, "key_in_violation": key}
}

# All other cases for metadata items are violations
default metadata_enable_oslogin(meta) = false

# check for enable_oslogin under metadata items - no violation
metadata_enable_oslogin(meta) {
	metadatum := meta.items[_]
	metadatum.key == "enable-oslogin"
	metadatum.value == "true"
}
