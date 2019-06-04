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

package templates.gcp.GCPGKEReduceNodeSAConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	# Default scopes are documented here:
	# https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster#reduce_node_sa_scopes
	default_oauth_scopes := [
		"https://www.googleapis.com/auth/devstorage.read_only",
		"https://www.googleapis.com/auth/logging.write",
		"https://www.googleapis.com/auth/servicecontrol",
		"https://www.googleapis.com/auth/service.management.readonly",
		"https://www.googleapis.com/auth/trace.append",
		"https://www.googleapis.com/auth/monitoring",
	]

	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	asset := input.asset
	asset.asset_type == "container.googleapis.com/Cluster"
	oauth_scopes := lib.get_default(params, "oauth_scopes", default_oauth_scopes)

	container := asset.resource.data
	additional_scopes := find_additional_oauth_scopes(container, oauth_scopes)
	count(additional_scopes) != 0

	message := sprintf("Additional OAuth scope %v is assigned to the node service account.", additional_scopes)
	metadata := {"resource": asset.name}
}

###########################
# Rule Utilities
###########################
find_additional_oauth_scopes(container, oauth_scopes) = additional_scopes {
	node_pools := lib.get_default(container, "nodePools", [])
	node_pool := node_pools[_]
	config := lib.get_default(node_pool, "config", {})
	node_oauth_scopes := lib.get_default(config, "oauthScopes", [])

	additional_scopes := [scope | scope = node_oauth_scopes[_]; not check_scope_in_scopes(oauth_scopes, scope)]
}

check_scope_in_scopes(oauth_scopes, scope) {
	oauth_scope := oauth_scopes[_]
	oauth_scope == scope
}
