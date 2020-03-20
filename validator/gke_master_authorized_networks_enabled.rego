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

package templates.gcp.GCPGKEMasterAuthorizedNetworksEnabledConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)

	asset := input.asset
	asset.asset_type == "container.googleapis.com/Cluster"
	cluster := asset.resource.data

	forbidden := forbidden_networks(cluster, params)
	count(forbidden) > 0

	message := sprintf("%v master is accessible from unauthorized networks: %v", [asset.name, forbidden])
	metadata := {"resource": asset.name}
}

# Checks that master authorized network is enabled.
# if it is not enabled, then the forbidden network is set
# to 0.0.0.0/0
forbidden_networks(cluster, params) = forbidden {
	master_network_config := lib.get_default(cluster, "masterAuthorizedNetworksConfig", {})
	enabled := lib.get_default(master_network_config, "enabled", false)
	enabled == false
	forbidden = ["0.0.0.0/0"]
}

# If authorized network parameter is not set, then no need of checking anything else
# If it is set to anything (e.g., a list of paramters, or an empty list) then
# enforce that only the listed networks are defined.
forbidden_networks(cluster, params) = forbidden {
	lib.has_field(params, "authorized_networks")
	allowed_authorized_networks = lib.get_default(params, "authorized_networks", [])

	master_network_config := lib.get_default(cluster, "masterAuthorizedNetworksConfig", {})
	master_network_config.enabled == true

	cidrBlocks = lib.get_default(master_network_config, "cidrBlocks", [])
	configured_networks := {network |
		network = cidrBlocks[_].cidrBlock
	}

	matched_networks := {network |
		network = configured_networks[_]
		net.cidr_contains(allowed_authorized_networks[_], network)
	}

	forbidden := configured_networks - matched_networks
}
