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

package templates.gcp.GCPGKEPrivateClusterConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	asset := input.asset
	asset.asset_type == "container.googleapis.com/Cluster"

	cluster := asset.resource.data
	private_cluster_config := lib.get_default(cluster, "privateClusterConfig", {})
	private_cluster_config != {}

	#Still considering if the goal for the policy is to check both private endpoint AND/OR private nodes only. For example:
	#OR: (private_cluster_config.enable_private_nodes == false) || (private_cluster_config.enable_private_endpoint == false)
	#AND: (private_cluster_config.enable_private_nodes == true && private_cluster_config.enable_private_endpoint == true)
	private_cluster_config.enable_private_nodes == false

	message := sprintf("Cluster %v is not private.", [asset.name])
	metadata := {"resource": asset.name}
}
