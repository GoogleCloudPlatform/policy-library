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

package templates.gcp.GCPRestrictedFirewallRulesConstraintV1

#Importing the test data
import data.test.fixtures.restricted_firewall_rules.assets.protocol_and_port as protocol_and_port_fixture_assets
import data.test.fixtures.restricted_firewall_rules.assets.sources as sources_fixture_assets
import data.test.fixtures.restricted_firewall_rules.assets.targets as targets_fixture_assets

# Importing the test constraints
import data.test.fixtures.restricted_firewall_rules.constraints.all as all_fixture_constraint
import data.test.fixtures.restricted_firewall_rules.constraints.misc.advanced as misc_advanced_fixture_constraint
import data.test.fixtures.restricted_firewall_rules.constraints.misc.basic as misc_basic_fixture_constraint
import data.test.fixtures.restricted_firewall_rules.constraints.protocol_and_port.advanced as protocol_and_port_advanced_fixture_constraint
import data.test.fixtures.restricted_firewall_rules.constraints.protocol_and_port.basic as protocol_and_port_basic_fixture_constraint
import data.test.fixtures.restricted_firewall_rules.constraints.sources.advanced as sources_advanced_fixture_constraint
import data.test.fixtures.restricted_firewall_rules.constraints.sources.basic as sources_basic_fixture_constraint
import data.test.fixtures.restricted_firewall_rules.constraints.targets.advanced as targets_advanced_fixture_constraint
import data.test.fixtures.restricted_firewall_rules.constraints.targets.basic as targets_basic_fixture_constraint

# Find all violations on our test cases
find_all_violations[violation] {
	resources := data.test_resources[_]
	constraint := data.test_constraints[_]
	issues := deny with input.asset as resources[_]
		 with input.constraint as constraint

	violation := issues[_]
}

fw_violations_protocol_and_port_basic[violation] {
	constraints := [protocol_and_port_basic_fixture_constraint]
	resources := [protocol_and_port_fixture_assets]

	violations := find_all_violations with data.test_resources as resources
		 with data.test_constraints as constraints

	violation := violations[_]
}

fw_violations_protocol_and_port_advanced[violation] {
	constraints := [protocol_and_port_advanced_fixture_constraint]
	resources := [protocol_and_port_fixture_assets]

	violations := find_all_violations with data.test_resources as resources
		 with data.test_constraints as constraints

	violation := violations[_]
}

fw_violations_sources_basic[violation] {
	constraints := [sources_basic_fixture_constraint]
	resources := [sources_fixture_assets]

	violations := find_all_violations with data.test_resources as resources
		 with data.test_constraints as constraints

	violation := violations[_]
}

fw_violations_sources_advanced[violation] {
	constraints := [sources_advanced_fixture_constraint]
	resources := [sources_fixture_assets]

	violations := find_all_violations with data.test_resources as resources
		 with data.test_constraints as constraints

	violation := violations[_]
}

fw_violations_targets_basic[violation] {
	constraints := [targets_basic_fixture_constraint]
	resources := [targets_fixture_assets]
	violations := find_all_violations with data.test_resources as resources
		 with data.test_constraints as constraints

	violation := violations[_]
}

fw_violations_targets_advanced[violation] {
	constraints := [targets_advanced_fixture_constraint]
	resources := [targets_fixture_assets]

	violations := find_all_violations with data.test_resources as resources
		 with data.test_constraints as constraints

	violation := violations[_]
}

fw_violations_misc_advanced[violation] {
	constraints := [misc_advanced_fixture_constraint]
	resources := [
		protocol_and_port_fixture_assets,
		sources_fixture_assets,
		targets_fixture_assets,
	]

	violations := find_all_violations with data.test_resources as resources
		 with data.test_constraints as constraints

	violation := violations[_]
}

fw_violations_misc_basic[violation] {
	constraints := [misc_basic_fixture_constraint]
	resources := [
		protocol_and_port_fixture_assets,
		sources_fixture_assets,
		targets_fixture_assets,
	]

	violations := find_all_violations with data.test_resources as resources
		 with data.test_constraints as constraints

	violation := violations[_]
}

fw_violations_all[violation] {
	constraints := [all_fixture_constraint]
	resources := [
		protocol_and_port_fixture_assets,
		sources_fixture_assets,
		targets_fixture_assets,
	]

	violations := find_all_violations with data.test_resources as resources
		 with data.test_constraints as constraints

	violation := violations[_]
}

# Tests sources constraint on port and protocol test data
test_restricted_firewall_rule_protocol_and_port_violations {
	# Basic constraint violations
	basic_violations := fw_violations_protocol_and_port_basic
	trace("here")
	count(basic_violations) == 5
	trace("2")

	resource_names_protocol_and_port_basic := {x | x = basic_violations[_].details.resource}
	expected_resource_name_protocol_and_port_basic := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-2",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-3",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-4",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-5",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-6",
	}

	resource_names_protocol_and_port_basic == expected_resource_name_protocol_and_port_basic

	# Advanced constraint violations
	advanced_violations := fw_violations_protocol_and_port_advanced

	# Note: the following resources raise 2 violations for the advanced constraint:
	# * cf-test-fw-rule-2
	# * cf-test-fw-rule-3
	# * cf-test-fw-rule-5
	count(advanced_violations) == 9

	resource_names_protocol_and_port_advanced := {x | x = advanced_violations[_].details.resource}
	expected_resource_name_protocol_and_port_advanced := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-2",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-3",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-4",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-5",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-6",
	}

	resource_names_protocol_and_port_advanced == expected_resource_name_protocol_and_port_advanced

	violations := [basic_violations, advanced_violations]
	violation := violations[_][_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Tests sources constraint on sources test data
test_restricted_firewall_rule_sources_violations {
	# Basic constraint violations
	basic_violations := fw_violations_sources_basic

	count(basic_violations) == 6

	resource_names_sources_basic := {x | x = basic_violations[_].details.resource}
	expected_resource_names_sources_basic := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-2",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-3",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-4",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-7",
	}

	resource_names_sources_basic == expected_resource_names_sources_basic

	# Advanced constraint violations
	advanced_violations := fw_violations_sources_advanced

	count(advanced_violations) == 2

	resource_names_sources_advanced := {x | x = advanced_violations[_].details.resource}
	expected_resource_name_sources_advanced := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-7",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-6",
	}

	resource_names_sources_advanced == expected_resource_name_sources_advanced

	violations := [basic_violations, advanced_violations]
	violation := violations[_][_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Test targets constraint on targets test data
test_restricted_firewall_rule_targets_violations {
	basic_violations := fw_violations_targets_basic

	count(basic_violations) == 8

	resource_names_target_basic_allowed := {x | x = basic_violations[_].details.resource}
	expected_resource_name_targets__allowed := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-2",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-3",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-4",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-5",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-6",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-11",
	}

	resource_names_target_basic_allowed == expected_resource_name_targets__allowed

	advanced_violations := fw_violations_targets_advanced

	count(advanced_violations) == 2

	resource_names_targets_advanced := {x | x = advanced_violations[_].details.resource}
	expected_resource_name_targets_advanced := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-7",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-9",
	}

	resource_names_targets_advanced == expected_resource_name_targets_advanced

	violations := [basic_violations, advanced_violations]
	violation := violations[_][_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Tests the misc constraint on misc test data
test_restricted_firewall_rule_misc_violations {
	allowed_violations := fw_violations_misc_advanced

	count(allowed_violations) == 4

	resource_names_misc_advanced := {x | x = allowed_violations[_].details.resource}
	expected_resource_name_misc_advanced := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-8",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-11",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-8",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-11",
	}

	resource_names_misc_advanced == expected_resource_name_misc_advanced

	basic_violations := fw_violations_misc_basic

	count(basic_violations) == 4

	resource_names_misc_basic := {x | x = basic_violations[_].details.resource}
	expected_resource_name_misc_basic := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-9",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-10",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-9",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-10",
	}

	resource_names_misc_basic == expected_resource_name_misc_basic

	violations := [allowed_violations, basic_violations]
	violation := violations[_][_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Tests "all" constraint on "all" test data
test_restricted_firewall_rule_all_violations {
	# test "all" constraint violations
	violations := fw_violations_all
	count(violations) == 10

	resource_names_all := {x | x = violations[_].details.resource}
	expected_resource_name_all := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-4",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-8",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-9",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-10",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-11",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-8",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-9",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-10",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-11",
	}

	resource_names_all == expected_resource_name_all

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}
