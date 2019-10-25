package templates.gcp.GCPResourceValuePatternConstraintV1

import data.test.fixtures.resource_value_pattern.assets as fixture_assets
import data.test.fixtures.resource_value_pattern.constraints.list as fixture_constraints

# Helper to lookup a constraint based on its name via metadata, not package
lookup_constraint[name] = [c] {
	c := fixture_constraints[_]
	c.metadata.name = name
}

# Helper to execute constraints against assets
find_violations[violation] {
	asset := data.assets[_]
	constraint := data.test_constraints[_]
	issues := deny with input.asset as asset with input.constraint as constraint
	total_issues := count(issues)
	violation := issues[_]
}

# Helper to create a set of resource names from violations
resource_names[name] {
	# Not sure why I need this, data.violations was a array_set but unless
	# casted as an array all evals of X[_] would fail.  Tested iterating sets in
	# playground and they work fine, so I am not sure the problem here.
	a := cast_array(data.violations)
	i := a[_]

	name := i.details.resource
}

test_resource_value_pattern_optional_on_multiple_resources {
	expected_count := 2
	expected_resources := {
		"//compute.googleapis.com/projects/test-project/zones/us-east1-c/instances/vm-no-ip",
		"//cloudresourcemanager.googleapis.com/projects/15100256534",
	}

	found_violations := find_violations with data.assets as fixture_assets
		 with data.test_constraints as lookup_constraint.optional_billing_id_on_multiple_assets

	found_resources := resource_names with data.violations as found_violations

	found_resources == expected_resources
}

test_resource_value_pattern_required_field_with_pattern {
	expected_count := 2
	expected_resources := {
		"//cloudresourcemanager.googleapis.com/projects/1510025653",
		"//cloudresourcemanager.googleapis.com/projects/15100256534",
	}

	found_violations := find_violations with data.assets as fixture_assets
		 with data.test_constraints as lookup_constraint.required_billing_id_on_project

	found_resources := resource_names with data.violations as found_violations

	found_resources == expected_resources
}

test_resource_value_pattern_no_pattern_violations {
	expected_count := 1
	expected_resources := {"//cloudresourcemanager.googleapis.com/projects/1510025653"}

	found_violations := find_violations with data.assets as fixture_assets
		 with data.test_constraints as lookup_constraint.required_billing_id_no_pattern

	found_resources := resource_names with data.violations as found_violations

	found_resources == expected_resources
}

# Boolean truth table is 16 rows, 2^4 (2 states, 4 variables)
# Test all permutations to ensure we have full coverage, no multiple outputs
# and no unknowns
# [is_required, has_pattern, has_field, pattern, label_value]
count_of_test_scenarios = count(validation_scenario_table)

validation_scenario_table = [
	{"is_required": true, "has_pattern": true, "has_field": true, "pattern": "^\\d+$", "value": "1234", "result_is_invalid": false},
	{"is_required": true, "has_pattern": true, "has_field": true, "pattern": "^\\d+$", "value": "abcd", "result_is_invalid": true},
	{"is_required": true, "has_pattern": true, "has_field": false, "pattern": "^\\d+$", "value": "1234", "result_is_invalid": true},
	{"is_required": true, "has_pattern": true, "has_field": false, "pattern": "^\\d+$", "value": "abcd", "result_is_invalid": true},
	{"is_required": true, "has_pattern": false, "has_field": true, "pattern": "^\\d+$", "value": "1234", "result_is_invalid": false},
	{"is_required": true, "has_pattern": false, "has_field": true, "pattern": "^\\d+$", "value": "abcd", "result_is_invalid": false},
	{"is_required": true, "has_pattern": false, "has_field": false, "pattern": "^\\d+$", "value": "1234", "result_is_invalid": true},
	{"is_required": true, "has_pattern": false, "has_field": false, "pattern": "^\\d+$", "value": "abcd", "result_is_invalid": true},
	{"is_required": false, "has_pattern": true, "has_field": true, "pattern": "^\\d+$", "value": "1234", "result_is_invalid": false},
	{"is_required": false, "has_pattern": true, "has_field": true, "pattern": "^\\d+$", "value": "abcd", "result_is_invalid": true},
	{"is_required": false, "has_pattern": true, "has_field": false, "pattern": "^\\d+$", "value": "1234", "result_is_invalid": false},
	{"is_required": false, "has_pattern": true, "has_field": false, "pattern": "^\\d+$", "value": "abcd", "result_is_invalid": false},
	{"is_required": false, "has_pattern": false, "has_field": true, "pattern": "^\\d+$", "value": "1234", "result_is_invalid": false},
	{"is_required": false, "has_pattern": false, "has_field": true, "pattern": "^\\d+$", "value": "abcd", "result_is_invalid": false},
	{"is_required": false, "has_pattern": false, "has_field": false, "pattern": "^\\d+$", "value": "1234", "result_is_invalid": false},
	{"is_required": false, "has_pattern": false, "has_field": false, "pattern": "^\\d+$", "value": "abcd", "result_is_invalid": false},
]

is_valid_bool(obj) = output {
	is_valid(obj)
	output := true
}

is_valid_bool(obj) = output {
	not is_valid(obj)
	output := false
}

all_is_valid_test_scenarios[[i, scenario]] {
	t := validation_scenario_table[i]
	d := {"is_required": t.is_required, "has_pattern": t.has_pattern, "has_field": t.has_field, "pattern": t.pattern, "value": t.value}
	result := is_valid_bool(d)
	result != t.result_is_invalid
	scenario = {
		"scenario": t,
		"result": result,
	}
}

test_is_valid_test_scenarios {
	# ensure we are always returning a true / false from is_valid and not any unknowns
	count(all_is_valid_test_scenarios) == count_of_test_scenarios
}

test_has_field_by_path {
	doc := {
		"labels": {
			"f": false,
			"id": "1234",
			"t": true,
			"tf_foo": "foo/project/google/v123",
		},
		"name": "myname",
	}

	has_field_by_path(doc, "name")
	has_field_by_path(doc, "labels.id")
	has_field_by_path(doc, "labels.f")
	has_field_by_path(doc, "labels.t")

	not has_field_by_path(doc, "unknown")
	not has_field_by_path(doc, "labels.unknown")
	not has_field_by_path(doc, "labels.f.unknown")
	not has_field_by_path(doc, "labels.t.unknown")
	not has_field_by_path(doc, "labels.tf_foo.unknown")
}

# Verifying default behavior
test_get_default_by_path {
	doc := {
		"labels": {
			"f": false,
			"id": "1234",
			"t": true,
			"tf_foo": "foo/project/google/v123",
		},
		"name": "myname",
	}

	get_default_by_path(doc, "name", "foo") == "myname"
	get_default_by_path(doc, "labels.id", "foo") == "1234"
	get_default_by_path(doc, "labels.t", false) == true
	get_default_by_path(doc, "labels.f", true) == false

	get_default_by_path(doc, "name1", "foo") == "foo"
	get_default_by_path(doc, "labels.id1", "foo") == "foo"
	get_default_by_path(doc, "labels.t1", false) == false
	get_default_by_path(doc, "labels.f1", true) == true
	get_default_by_path(doc, "labels.tf_foo.unknown", true) == true
	get_default_by_path(doc, "labels.tf_foo.unknown", false) == false
}
