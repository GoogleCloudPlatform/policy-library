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

package templates.gcp.GCPComputeNetworkInterfaceWhitelistConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	asset := input.asset
	asset.asset_type == "compute.googleapis.com/Instance"

	lib.get_constraint_params(input.constraint, params)

	instance := asset.resource.data

	interfaces := lib.get_default(instance, "networkInterface", [])
	interface := interfaces[_]
	full_network_uri := interface.network

	whitelist := lib.get_default(params, "whitelist", [])
	allowed_networks := {n | n = whitelist[_]}

	access_configs := lib.get_default(interface, "accessConfig", [])

	is_external_network := count(access_configs) > 0
	is_network_whitelisted := count({full_network_uri} - allowed_networks) == 0

	is_external_network == true
	is_network_whitelisted == false

	ancestry_path = lib.get_default(asset, "ancestry_path", "")

	message := sprintf("Compute instance %v has interface %v with invalid access configuration.", [asset.name, interface.name])
	metadata := {"resource": asset.name, "ancestry_path": ancestry_path}
}
