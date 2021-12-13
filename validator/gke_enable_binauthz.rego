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

package templates.gcp.GCPGKEEnableBinAuthzConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	asset := input.asset
	asset.asset_type == "container.googleapis.com/Cluster"

	cluster := asset.resource.data
	bin_authz := lib.get_default(cluster, "binaryAuthorization", {})
	bin_authz_enabled := lib.get_default(bin_authz, "enabled", false)
	bin_authz_enabled == false

	message := sprintf("Binary authorization is not enabled in cluster %v.", [asset.name])
	metadata := {"resource": asset.name}
}
