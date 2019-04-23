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

# If a primary domain is whitelisted, all of its sub domains are whitelisted as well.
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

	# Check if a match is found
	# not binding_matches(member, role, params.bindings)

	# member_type_whitelist := lib.get_default(params, "member_type_whitelist", ["projectOwner", "projectEditor", "projectViewer"])

	# members_to_check := [m | m = unique_members[_]; not starts_with_whitelisted_type(member_type_whitelist, m)]
	# member := members_to_check[_]
	# matched_domains := [m | m = member; re_match(sprintf("[:@.]%v$", [params.domains[_]]), member)]
	# count(matched_domains) == 0

	message := sprintf("IAM policy for %v grants %v to %v", [asset.name, role, member])

	metadata := {
		"member": member,
		# "binding": binding,
		# "constraint": desired_count,
		# "match": matches_found,
		"member": member,
		"role": role
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
