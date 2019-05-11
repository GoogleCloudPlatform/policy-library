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

package templates.gcp.GKERestrictPodTrafficConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	asset := input.asset
	asset.asset_type == "container.googleapis.com/Cluster"

	container := asset.resource.data
	network_policy_config_enabled := network_policy_config_enabled(container)
	pod_security_policy_config_enabled := pod_security_policy_config_enabled(container)
	network_policy_enabled := network_policy_enabled(container)

	disabled := network_policy_config_enabled && pod_security_policy_config_enabled && network_policy_enabled
	disabled == true
	
	message := sprintf("%v doesn't restrict traffic among pods with a network policy.", [asset.name])
	metadata := {"resource": asset.name}
}

###########################
# Rule Utilities
###########################
network_policy_config_enabled(container) = network_policy_config_enabled {
	addons_config := lib.get_default(container, "addonsConfig", {})
	networkPolicyConfig := lib.get_default(addons_config, "networkPolicyConfig", {})
	network_policy_config_enabled := lib.get_default(networkPolicyConfig, "disabled", true)
}
pod_security_policy_config_enabled(container) = pod_security_policy_config_enabled {
	pod_security_policy_config := lib.get_default(container, "podSecurityPolicyConfig", {})
	pod_security_policy_config_enabled := pod_security_policy_config != {}
}
network_policy_enabled(container) = network_policy_enabled {
	network_policy := lib.get_default(container, "networkPolicy", {})
	network_policy_enabled := network_policy != {}
}
