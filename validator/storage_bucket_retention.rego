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

package templates.gcp.GCPStorageBucketRetentionConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)

	min_retention_days := lib.get_default(params, "minimum_retention_days", "")
	max_retention_days := lib.get_default(params, "maximum_retention_days", "")

	asset := input.asset
	asset.asset_type == "storage.googleapis.com/Bucket"

	# Check if resource is in exempt list
	exempt_list := params.exemptions
	matches := {asset.name} & cast_set(exempt_list)
	count(matches) == 0

	violation_msg := get_diff(asset, min_retention_days, max_retention_days)
	is_string(violation_msg)

	message := sprintf("Storage bucket %v has a retention policy violation: %v", [asset.name, violation_msg])

	metadata := {
		"resource": asset.name,
		"violation_type": violation_msg,
	}
}

###########################
# Rule Utilities
###########################

# Generate a violation if there is no bucket lifecycle Delete condition and maximum_retention_days is defined.
get_diff(asset, minimum_retention_days, maximum_retention_days) = output {
	maximum_retention_days != ""
	lifecycle_delete_exists := [is_delete | is_delete = asset.resource.data.lifecycle.rule[_].action.type == "Delete"; is_delete = true]
	count(lifecycle_delete_exists) == 0
	output := "Lifecycle delete action does not exist when maximum_retention_days is defined"
}

# Generate a violation if the bucket lifecycle Delete 'age' condition is greater than the maximum_retention_days defined.
else = output {
	some i
	maximum_retention_days != ""
	asset.resource.data.lifecycle.rule[i].action.type == "Delete"
	lifecycle_age := asset.resource.data.lifecycle.rule[i].condition.age
	lifecycle_age > maximum_retention_days
	output := "Lifecycle age is greater than maximum_retention_days"
}

# Generate a violation if the bucket lifecycle Delete 'age' condition does NOT exist and maximum_retention_days is defined.
else = output {
	some i
	maximum_retention_days != ""
	asset.resource.data.lifecycle.rule[i].action.type == "Delete"
	lifecycle_age := lib.get_default(asset.resource.data.lifecycle.rule[i].condition, "age", "")
	lifecycle_age == ""
	output := "Lifecycle age is not set when maximum_retention_days is defined"
}

# Generate a violation if lifecycle Delete 'age' condition (i.e. retention days) is less than minimum_retention_days
else = output {
	some i
	minimum_retention_days != ""
	asset.resource.data.lifecycle.rule[i].action.type == "Delete"
	rule_condition := asset.resource.data.lifecycle.rule[i].condition
	output := get_min_retention_age_violation(rule_condition, minimum_retention_days)
}

# lifecycle Delete 'createdBefore' condition is less than minimum_retention_days
else = output {
	some i
	minimum_retention_days != ""
	asset.resource.data.lifecycle.rule[i].action.type == "Delete"
	rule_condition := asset.resource.data.lifecycle.rule[i].condition
	output := get_min_retention_created_before_violation(rule_condition, minimum_retention_days)
}

# lifecycle Delete 'numNewerVersions' is 0 or does NOT exist when minimum_retention_days is defined
else = output {
	some i
	minimum_retention_days != ""
	asset.resource.data.lifecycle.rule[i].action.type == "Delete"
	rule_condition := asset.resource.data.lifecycle.rule[i].condition
	output := get_min_retention_num_newer_versions_violation(rule_condition, minimum_retention_days)
}

# Generate a violation if the bucket lifecycle Delete 'age' condition is less than the minimum_retention_days defined.
get_min_retention_age_violation(rule_condition, minimum_retention_days) = "Lifecycle age is less than minimum_retention_days" {
	lifecycle_age := rule_condition.age
	lifecycle_age != ""
	lifecycle_age < minimum_retention_days
}

# Generate a violation if the difference between now and the bucket lifecycle Delete 'createdBefore' condition is less than the minimum_retention_days defined.
get_min_retention_created_before_violation(rule_condition, minimum_retention_days) = "createdBefore condition is less than minimum_retention_days" {
	created_before := rule_condition.createdBefore
	created_before != ""
	created_before_date_ns := convert_rfc3339_compatible(created_before)
	diff_days := get_diff_in_days_from_now(created_before_date_ns)

	diff_days < minimum_retention_days
}

# Generate a violation if the bucket lifecycle Delete 'numNewerVersions' condition is 0 or does NOT exist when minimum_retention_days is defined.
get_min_retention_num_newer_versions_violation(rule_condition, minimum_retention_days) = "numNewerVersions condition is 0 or non-existent" {
	num_newer_versions := lib.get_default(rule_condition, "numNewerVersions", 0)

	num_newer_versions == 0
}

# Convert 'createdBefore' time to ns
convert_rfc3339_compatible(input_time) = converted_ns {
	t_format := "T00:00:00Z"
	input_time_array := [input_time, t_format]
	concat_array := concat("", input_time_array)
	converted_ns := time.parse_rfc3339_ns(concat_array)
}

# Get the difference in days between now and 'createdBefore' time
get_diff_in_days_from_now(time_ns) = diff_in_days {
	ns_in_days := ((((24 * 60) * 60) * 1000) * 1000) * 1000
	time_now_ms := time.now_ns()
	diff_ns := time_now_ms - time_ns
	diff_in_days := round(diff_ns / ns_in_days)
}
