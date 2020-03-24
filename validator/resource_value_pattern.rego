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

package templates.gcp.GCPResourceValuePatternConstraintV1

import data.validator.gcp.lib as lib

###########################
# Matches any field, including nested fields in asset data against
# a regular expression pattern for validity checking.
# fields can be optional such that missing fields in data
# will not trigger a violation; or by default required
# such that missing fields will trigger a violation.
###########################
deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	params := lib.get_constraint_params(constraint)
	asset := input.asset

	asset.asset_type = params.asset_types[_]

	field_name := params.field_name
	mode := lib.get_default(params, "mode", "allowlist")

	rule_data := {
		"is_required": lib.get_default(params, "required", true),
		"has_field": has_field_by_path(asset.resource.data, field_name),
		"has_pattern": lib.has_field(params, "pattern"),
		"pattern": lib.get_default(params, "pattern", ""),
		"value": get_default_by_path(asset.resource.data, field_name, ""),
	}

	is_valid(mode, rule_data)

	message := sprintf("%v has %v violation for field named '%v' with a value '%v' matching pattern '%v'.", [
		asset.name,
		mode,
		field_name,
		rule_data.value,
		rule_data.pattern,
	])

	metadata := {
		"resource": asset.name,
		"mode": mode,
	}
}

###########################
# Rule Utilities
###########################

is_valid(mode, {
	"is_required": is_required,
	"has_field": has_field,
	"has_pattern": has_pattern,
	"pattern": pattern,
	"value": field_value,
}) {
	mode == "allowlist"
	is_allowlist_valid(has_field, has_pattern, pattern, field_value, is_required, has_field)
}

is_valid(mode, {
	"is_required": is_required,
	"has_field": has_field,
	"has_pattern": has_pattern,
	"pattern": pattern,
	"value": field_value,
}) {
	mode == "denylist"
	is_denylist_valid(has_field, has_pattern, pattern, field_value, is_required, has_field)
}

is_denylist_valid(has_field, has_pattern, pattern, field_value, is_required, has_field) {
	is_required_field_valid(is_required, has_field)
	is_denylist_pattern_valid(has_field, has_pattern, pattern, field_value)
}

is_denylist_valid(has_field, has_pattern, pattern, field_value, is_required, has_field) {
	not is_required_field_valid(is_required, has_field)
}

is_required_field_valid(is_required, has_field) {
	has_field == true
}

is_required_field_valid(is_required, has_field) {
	is_required == false
	has_field == false
}

is_denylist_pattern_valid(has_field, has_pattern, pattern, value) {
	has_pattern == true
	has_field == true
	re_match(pattern, value)
}

is_allowlist_valid(has_field, has_pattern, pattern, field_value, is_required, has_field) {
	is_required_field_valid(is_required, has_field)
	not is_allowlist_pattern_valid(has_field, has_pattern, pattern, field_value)
}

is_allowlist_valid(has_field, has_pattern, pattern, field_value, is_required, has_field) {
	not is_required_field_valid(is_required, has_field)
}

is_allowlist_pattern_valid(has_field, has_pattern, pattern, value) {
	has_pattern == false
}

is_allowlist_pattern_valid(has_field, has_pattern, pattern, value) {
	has_field == false
}

is_allowlist_pattern_valid(has_field, has_pattern, pattern, value) {
	has_pattern == true
	has_field == true
	re_match(pattern, value)
}

###
# Rule Library Functions
###
get_field_by_path(obj, path) = output {
	split(path, ".", path_parts)
	walk(obj, [path_parts, output])
}

# wrapper around walk to explicitly capture the output in order to generate a
# true / false output instead of undefined.
# see: https://openpolicyagent.slack.com/messages/C1H19LW4F/convo/C1H19LW4F-1552948594.244300/
_has_field_by_path(obj, path) {
	_ := get_field_by_path(obj, path)
}

has_field_by_path(obj, path) {
	_has_field_by_path(obj, path)
}

has_field_by_path(obj, path) = false {
	not _has_field_by_path(obj, path)
}

get_default_by_path(obj, path, _default) = output {
	has_field_by_path(obj, path)
	output := get_field_by_path(obj, path)
}

get_default_by_path(obj, path, _default) = output {
	false == has_field_by_path(obj, path)
	output := _default
}
