
package validator.gcp.lib

audit[result] {
	asset := data.assets[_]

	constraints := data.constraints
	constraint := constraints[_]
	spec := _get_default(constraint, "spec", {})
	match := _get_default(spec, "match", {})
	# Default matcher behavior is to match everything.
	target := _get_default(match, "target", ["organization/*"])
	gcp := _get_default(match, "gcp", {})
	gcp_target := _get_default(gcp, "target", target)
	re_match(gcp_target[_], asset.ancestry_path)
	exclude := _get_default(match, "exclude", [])
	gcp_exclude := _get_default(gcp, "exclude", exclude)
	exclusion_match := {asset.ancestry_path | re_match(gcp_exclude[_], asset.ancestry_path)}
	count(exclusion_match) == 0

	violations := data.templates.gcp[constraint.kind].deny with input.asset as asset
		 with input.constraint as constraint

	violation := violations[_]

	result := {
		"asset": asset.name,
		"constraint": constraint.metadata.name,
		"constraint_config": constraint,
		"violation": violation,
	}
}

# has_field returns whether an object has a field
_has_field(object, field) {
	object[field]
}

# False is a tricky special case, as false responses would create an undefined document unless
# they are explicitly tested for
_has_field(object, field) {
	object[field] == false
}

_has_field(object, field) = false {
	not object[field]
	not object[field] == false
}

# get_default returns the value of an object's field or the provided default value.
# It avoids creating an undefined state when trying to access an object attribute that does
# not exist
_get_default(object, field, _default) = output {
	_has_field(object, field)
	output = object[field]
}

_get_default(object, field, _default) = output {
	_has_field(object, field) == false
	output = _default
}