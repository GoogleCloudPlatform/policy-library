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

package templates.gcp.GCPNetworkFirewallWhitelistConstraintV1

import data.validator.gcp.lib as lib

import data.test.fixtures.gcp_network_firewall_whitelist.assets.ingress_ssh.with_target_tag as ingress_ssh_assets
import data.test.fixtures.gcp_network_firewall_whitelist.constraints.ingress_ssh.with_target_tag as ingress_ssh_constraint_with_target_tag
import data.test.fixtures.gcp_network_firewall_whitelist.constraints.ingress_ssh.without_target_tag as ingress_ssh_constraint_without_target_tag

import data.test.fixtures.gcp_network_firewall_whitelist.assets.egress as egress_assets
import data.test.fixtures.gcp_network_firewall_whitelist.constraints.egress as egress_constraint

find_violations[violation] {
	firewall := data.firewalls[_]

	constraint := data.constraint
	issues := deny with input.asset as firewall
		 with input.constraint as constraint

	trace(sprintf("ISSUES: %v", [issues[_].details.resource]))
	violation := issues[_]
}

test_ingress_ssh_with_target_tag {
	violation := find_violations with data.firewalls as ingress_ssh_assets
		 with data.constraint as ingress_ssh_constraint_with_target_tag

	count(violation) == 1

	violation[_].details.resource != "//compute.googleapis.com/projects/self-perimeter-yunusd/global/firewalls/forseti-test"
}

test_ingress_ssh_without_target_tag {
	violation := find_violations with data.firewalls as ingress_ssh_assets
		 with data.constraint as ingress_ssh_constraint_without_target_tag

	count(violation) == 1

	violation[_].details.resource == "//compute.googleapis.com/projects/self-perimeter-yunusd/global/firewalls/forseti-test"
}

test_egress {
	violation := find_violations with data.firewalls as egress_assets
		 with data.constraint as egress_constraint

	count(violation) == 2

	violation[_].details.resource != "//compute.googleapis.com/projects/self-perimeter-yunusd/global/firewalls/forseti-test-egress"
}

test_do_all_regex_fields_match {
	do_all_regex_fields_match({"targetServiceAccounts": ["sa1", "sa2"], "targetTags": ["tag1"]}, {"targetServiceAccounts": ["sa.*"], "targetTags": ["tag.*"]}, ["not_exist", "targetTags", "targetServiceAccounts"])
}

test_not_all_regex_fields_match {
	not do_all_regex_fields_match({"targetServiceAccounts": ["sa1", "sa2"], "targetTags": ["tag1"]}, {"targetServiceAccounts": ["sa.*"], "targetTags": ["nomatch"]}, ["not_exist", "targetTags", "targetServiceAccounts"])
}

fields_match_violations {
	do_fields_match(data.rule, data.param, data.field)
}

test_do_fields_match_not_exist {
	do_fields_match({"targetServiceAccounts": ["sa1", "sa2"], "targetTags": ["tag1"]}, {"targetServiceAccounts": ["sa.*"], "targetTags": ["tag.*"]}, "not_exist")
}

test_do_fields_match {
	do_fields_match({"targetServiceAccounts": ["sa1", "sa2"], "targetTags": ["tag1"]}, {"targetServiceAccounts": ["sa.*"], "targetTags": ["tag.*"]}, "targetServiceAccounts")
}

test_do_fields_no_match {
	not do_fields_match({"targetServiceAccounts": ["sa1", "sa2"]}, {"targetServiceAccounts": ["nomatch"]}, "targetServiceAccounts")
}

test_do_all_protocols_and_ports_match {
	do_all_protocols_and_ports_match({"allowed": [{"IPProtocol": "tcp", "ports": ["0-65535"]}, {"IPProtocol": "udp", "ports": ["0-65535"]}, {"IPProtocol": "icmp"}]}, {"allowed": [{"IPProtocol": "tcp", "ports": ["0-65535"]}, {"IPProtocol": "udp", "ports": ["0-65535"]}, {"IPProtocol": "icmp"}]})
}

test_not_all_protocols_and_ports_match {
	not do_all_protocols_and_ports_match({"allowed": [{"IPProtocol": "tcp", "ports": ["0-65535"]}, {"IPProtocol": "udp", "ports": ["0-65535"]}, {"IPProtocol": "icmp"}]}, {"allowed": [{"IPProtocol": "udp", "ports": ["0-65535"]}, {"IPProtocol": "icmp"}]})
}

test_exact_protocol_port_match {
	does_a_protocol_and_port_match({"IPProtocol": "tcp", "ports": ["80", "443"]}, [{"IPProtocol": "tcp", "ports": ["80", "443"]}])
}

test_one_port_missin_no_match {
	not does_a_protocol_and_port_match({"IPProtocol": "tcp", "ports": ["80", "443"]}, [{"IPProtocol": "tcp", "ports": ["80"]}])
}

test_one_extra_port_match {
	does_a_protocol_and_port_match({"IPProtocol": "tcp", "ports": ["80"]}, [{"IPProtocol": "tcp", "ports": ["80", "443"]}, {"IPProtocol": "udp", "ports": ["80", "443"]}])
}

test_range_port_match {
	does_a_protocol_and_port_match({"IPProtocol": "tcp", "ports": ["80"]}, [{"IPProtocol": "tcp", "ports": ["79-90", "443"]}])
}

test_no_fw_port_no_match {
	not does_a_protocol_and_port_match({"IPProtocol": "tcp"}, [{"IPProtocol": "tcp", "ports": ["79-90", "443"]}])
}

test_no_param_port_no_match {
	not does_a_protocol_and_port_match({"IPProtocol": "tcp", "ports": ["80"]}, [{"IPProtocol": "tcp"}])
}

test_no_port_match {
	does_a_protocol_and_port_match({"IPProtocol": "icmp"}, [{"IPProtocol": "icmp"}])
}

test_cidr_ranges {
	do_source_destination_cidr_ranges_overlap({"direction": "ingress", "sourceRanges": ["0.0.0.0/0"]}, {"direction": "ingress", "sourceRanges": ["0.0.0.0/0"]})
	do_source_destination_cidr_ranges_overlap({"direction": "ingress", "sourceRanges": ["0.0.0.0/0"]}, {"direction": "ingress", "sourceRanges": ["0.0.0.0/0", "10.0.0.0/8"]})
	not do_source_destination_cidr_ranges_overlap({"direction": "ingress", "sourceRanges": ["0.0.0.0/0", "10.0.0.0/8"]}, {"direction": "ingress", "sourceRanges": ["10.0.0.0/8"]})
	do_source_destination_cidr_ranges_overlap({"direction": "egress", "sourceRanges": ["10.0.0.0/8"]}, {"direction": "egress", "sourceRanges": ["0.0.0.0/0"]})
}
