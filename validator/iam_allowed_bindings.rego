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

package templates.gcp.GCPIAMAllowedBindingsConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	asset := input.asset

	binding := asset.iam_policy.bindings[_]
	member := binding.members[_]
	role := binding.role

	glob.match(params.role, [], role)

	mode := lib.get_default(params, "mode", "whitelist")

	matches_found = [m | m = params.members[_]; glob.match(m, [], member)]
	target_match_count(mode, desired_count)
	count(matches_found) != desired_count

	message := sprintf("IAM policy for %v grants %v to %v", [asset.name, role, member])

	metadata := {
		"resource": asset.name,
		"member": member,
		"role": role,
	}
}

###########################
# Rule Utilities
###########################

# Determine the overlap between matches under test and constraint
target_match_count(mode) = 0 {
	mode == "blacklist"
}

target_match_count(mode) = 1 {
	mode == "whitelist"
}
