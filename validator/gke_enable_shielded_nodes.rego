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

package templates.gcp.GCPGKEEnableShieldedNodesConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	asset := input.asset
	asset.asset_type == "container.googleapis.com/Cluster"

	cluster := asset.resource.data
	node_pools := lib.get_default(cluster, "nodePools", [])
	node_pool := node_pools[_]

	# We fail if either the cluster doesn't have shielded vms, or
	# one of the node pools doesn't have the proper settings.
	cluster_shielded_nodes_disabled(cluster, node_pool)

	message := sprintf("Cluster %v doesn't use shielded VMs with integrity and secure boot in node pool %v.", [asset.name, node_pool.name])
	metadata := {"resource": asset.name}
}

###########################
# Rule Utilities
###########################

# Checks the Shielded Nodes setting in the cluster configuration.
cluster_shielded_nodes_disabled(cluster, node_pool) {
	shielded_nodes := lib.get_default(cluster, "shieldedNodes", {})
	enabled := lib.get_default(shielded_nodes, "enabled", false)
	enabled == false
}

# Checks that all shielded nodes options are enabled for all node pools.
cluster_shielded_nodes_disabled(cluster, node_pool) {
	single_pool := lib.get_default(node_pool, "config", {})
	shieldedInstanceConfig := lib.get_default(single_pool, "shieldedInstanceConfig", {})
	integrity_monitoring := lib.get_default(shieldedInstanceConfig, "enableIntegrityMonitoring", false)
	secure_boot := lib.get_default(shieldedInstanceConfig, "enableSecureBoot", false)
	node_pool_has_insufficient_configuration(integrity_monitoring, secure_boot)
}

node_pool_has_insufficient_configuration(integrity_monitoring, secure_boot) {
	integrity_monitoring == false
}

node_pool_has_insufficient_configuration(integrity_monitoring, secure_boot) {
	secure_boot == false
}
