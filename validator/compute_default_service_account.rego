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

package templates.gcp.GCPComputeDefaultServiceAccountConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	asset := input.asset

	asset.asset_type == "compute.googleapis.com/Instance"
	service_accounts := asset.resource.data.serviceAccounts[_]
	email := service_accounts.email
	re_match("-compute@developer.gserviceaccount.com$", email)

	check_full_scope := lib.get_default(params, "checkfullscope", true)

	scopes := lib.get_default(service_accounts, "scopes", [])
	scope_violation(check_full_scope, scopes)

	ancestry_path = lib.get_default(asset, "ancestry_path", "")

	message := sprintf("Instance %v uses default compute engine service account %v with access to scope %v.", [asset.name, email, concat(" ", scopes)])
	metadata := {"resource": asset.name, "ancestry_path": ancestry_path}
}

#################
# Rule Utilities
#################

# Determine the overlap between locations under test and constraint
scope_violation(checkfullscope, scopes) {
	checkfullscope == false
}

scope_violation(checkfullscope, scopes) {
	checkfullscope == true
	individual_scope := scopes[_]
	individual_scope == "https://www.googleapis.com/auth/cloud-platform"
}

scope_violation(checkfullscope, scopes) = false {
	checkfullscope == true
}
