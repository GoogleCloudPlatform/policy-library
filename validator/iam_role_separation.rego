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

package templates.gcp.GCPIAMRoleSeparationConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	asset := input.asset

	conflicting_roles := cast_set(params.roles[_])

	all_members = {member | member := asset.iam_policy.bindings[_].members[_]}

	members_to_roles := {member: roles |
		member := all_members[_]
		roles := {binding.role |
			count({member} & cast_set(asset.iam_policy.bindings[b].members)) == 1
			binding := asset.iam_policy.bindings[b]
		}
	}

	have_roles := members_to_roles[member]

	potentially_conflicting_roles := have_roles & conflicting_roles
	count(potentially_conflicting_roles) > 1

	message := sprintf("IAM policy for %v grants %v to %v", [asset.name, concat(",", potentially_conflicting_roles), member])

	metadata := {
		"resource": asset.name,
		"member": member,
		"roles": potentially_conflicting_roles,
	}
}
