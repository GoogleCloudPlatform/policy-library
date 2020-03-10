#
# Copyright 2020 Google LLC
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

package templates.gcp.GCPComputeDiskResourcePoliciesConstraintV1

import data.validator.gcp.lib as lib

#####################################
# Find Compute Persistent Disk Resource Policy Violations
#####################################
deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)

	# Verify that resource is Disk or RegionDisk
	asset := input.asset
	{asset.asset_type} == {asset.asset_type} & {"compute.googleapis.com/Disk", "compute.googleapis.com/RegionDisk"}

	# Check if resource is in exempt list
	exempt_list := params.exemptions
	matches := {asset.name} & cast_set(exempt_list)
	count(matches) == 0

	# Check that resource policy is in allowlist/denylist
	asset_resource_policies := lib.get_default(asset.resource.data, "resourcePolicies", [""])
	target_resource_policies := params.resourcePolicies
	resource_policies_matches := cast_set(asset_resource_policies) & cast_set(target_resource_policies)
	target_resource_policies_match_count(params.mode, desired_count)
	count(resource_policies_matches) == desired_count

	message := sprintf("%v has an empty or disallowed resource policy.", [asset.name])
	metadata := {"resource": asset.name, "resource_policies": asset_resource_policies}
}

#################
# Rule Utilities
#################

# Determine the overlap between resource policies under test and constraint
# By default (allowlist), we violate if there isn't overlap
target_resource_policies_match_count(mode) = 0 {
	mode != "denylist"
}

target_resource_policies_match_count(mode) = 1 {
	mode == "denylist"
}
