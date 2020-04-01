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

package templates.gcp.GCPFirewallRulesAllowlistConstraintV1

# Importing the test data
import data.test.fixtures.firewall_rules_allowlist.assets.misc as misc_fixture_assets
import data.test.fixtures.firewall_rules_allowlist.assets.protocol_and_port as protocol_and_port_fixture_assets
import data.test.fixtures.firewall_rules_allowlist.assets.sources as sources_fixture_assets
import data.test.fixtures.firewall_rules_allowlist.assets.targets as targets_fixture_assets

# Importing the test constraints
import data.test.fixtures.firewall_rules_allowlist.constraints.all as all_fixture_constraint
import data.test.fixtures.firewall_rules_allowlist.constraints.misc.advanced as misc_advanced_fixture_constraint
import data.test.fixtures.firewall_rules_allowlist.constraints.misc.basic as misc_basic_fixture_constraint
import data.test.fixtures.firewall_rules_allowlist.constraints.protocol_and_port.advanced as protocol_and_port_advanced_fixture_constraint
import data.test.fixtures.firewall_rules_allowlist.constraints.protocol_and_port.basic as protocol_and_port_basic_fixture_constraint
import data.test.fixtures.firewall_rules_allowlist.constraints.sources.advanced as sources_advanced_fixture_constraint
import data.test.fixtures.firewall_rules_allowlist.constraints.sources.basic as sources_basic_fixture_constraint
import data.test.fixtures.firewall_rules_allowlist.constraints.targets.advanced as targets_advanced_fixture_constraint
import data.test.fixtures.firewall_rules_allowlist.constraints.targets.basic as targets_basic_fixture_constraint

import data.validator.test_utils as test_utils

template_name := "GCPFirewallRulesAllowlistConstraintV1"

# Tests sources constraint on port and protocol test data
test_restricted_firewall_rule_protocol_and_port_violations_basic {
	# Basic constraint violations

	expected_resource_names := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-2",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-3",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-4",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-5",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-6",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-7",
	}

	test_utils.check_test_violations(protocol_and_port_fixture_assets, [protocol_and_port_basic_fixture_constraint], template_name, expected_resource_names)
}

# Tests sources constraint on port and protocol test data
test_restricted_firewall_rule_protocol_and_port_violations_advanced {
	# Advanced constraint violations

	expected_resource_names := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-2",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-3",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-4",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-5",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-6",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-7",
	}

	test_utils.check_test_violations(protocol_and_port_fixture_assets, [protocol_and_port_advanced_fixture_constraint], template_name, expected_resource_names)
}

# Tests sources constraint on sources test data
test_restricted_firewall_rule_sources_violations_basic {
	# Basic constraint violations

	expected_resource_names := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-5",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-6",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-8",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-9",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-10",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-11",
	}

	test_utils.check_test_violations(sources_fixture_assets, [sources_basic_fixture_constraint], template_name, expected_resource_names)
}

# Tests sources constraint on sources test data
test_restricted_firewall_rule_sources_violations_advanced {
	# Advanced constraint violations

	expected_resource_names := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-2",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-3",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-4",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-5",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-6",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-7",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-8",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-9",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-10",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-11",
	}

	test_utils.check_test_violations(sources_fixture_assets, [sources_advanced_fixture_constraint], template_name, expected_resource_names)
}

# Test targets constraint on targets test data
test_restricted_firewall_rule_targets_violations_basic {
	# Basic constraint violations

	expected_resource_names := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-7",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-8",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-9",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-10",
	}

	test_utils.check_test_violations(targets_fixture_assets, [targets_basic_fixture_constraint], template_name, expected_resource_names)
}

# Test targets constraint on targets test data
test_restricted_firewall_rule_targets_violations_advanced {
	# Advanced constraint violations

	expected_resource_names := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-2",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-3",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-4",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-5",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-6",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-7",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-8",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-9",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-10",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-11",
	}

	test_utils.check_test_violations(targets_fixture_assets, [targets_advanced_fixture_constraint], template_name, expected_resource_names)
}

# Test misc constraint on misc test data
test_restricted_firewall_rule_misc_violations_basic {
	# Basic constraint violations

	expected_resource_names := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-2",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-2",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-2",
	}

	test_utils.check_test_violations(misc_fixture_assets, [misc_basic_fixture_constraint], template_name, expected_resource_names)
}

# Test misc constraint on misc test data
test_restricted_firewall_rule_misc_violations_advanced {
	# Advanced constraint violations

	expected_resource_names := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-2",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-2",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-2",
	}

	test_utils.check_test_violations(misc_fixture_assets, [misc_advanced_fixture_constraint], template_name, expected_resource_names)
}

# Test for all constraints on misc test data
test_restricted_firewall_rule_all_violations {
	# All constraint violations

	expected_resource_names := {
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-2",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-source-2",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-0",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-1",
		"//compute.googleapis.com/projects/cf-gcp-challenge-dev/global/firewalls/cf-test-fw-rule-target-2",
	}

	test_utils.check_test_violations(misc_fixture_assets, [all_fixture_constraint], template_name, expected_resource_names)
}
