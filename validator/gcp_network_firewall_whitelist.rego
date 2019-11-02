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

###########################
# Find Whitelist Violations
###########################

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)

	asset := input.asset
	asset.asset_type == "compute.googleapis.com/Firewall"

	fw_rule := asset.resource.data

	not is_there_any_match(fw_rule, params.rules)
	message := sprintf("%s Firewall rule is prohibited.", [asset.name])
	metadata := {
		"resource": asset.name,
		"allowed_rules": params.rules,
	}
}

is_there_any_match(fw_rule, param_rules) {
	check_any_match(fw_rule, param_rules[_])
}

check_any_match(fw_rule, param_rule) {
	# Direction match? ingress/egress
	lower(fw_rule.direction) == lower(param_rule.direction)

	# AND

	# The whitelist rule and actual firewall rule should have the same fields defined
	# any difference means that there is no match
do_all_fields_exist_in_both(	fw_rule, param_rule)

	# AND

	# check sourceRanges or destinationRanges overlap if they are defined
	# the actual firewall rule should be a subset of this whitelist
do_source_destination_cidr_ranges_overlap(	fw_rule, param_rule)

	# AND

	regex_array_fields := [
		"sourceTags",
		"sourceServiceAccounts",
		"targetTags",
		"targetServiceAccounts",
	]

	# each field of firewall rule should be a subset of the whitelist rule
	# basically, the regex match should happen.
do_all_regex_fields_match(	fw_rule, param_rule, regex_array_fields)

	# AND

	# the IPProtocol, and ports (or port ranges) defined by the actual firewall rule 
	# should be a subset of the whitelist rule
do_all_protocols_and_ports_match(	fw_rule, param_rule)
}

######### CHECKING IP RANGES ############

# We check either source or destination ranges match
do_source_destination_cidr_ranges_overlap(fw_rule, param_rule) {
	param_rule.direction == "ingress"
	do_cidr_ranges_overlap(fw_rule, param_rule, "sourceRanges")
}

do_source_destination_cidr_ranges_overlap(fw_rule, param_rule) {
	param_rule.direction == "egress"
	do_cidr_ranges_overlap(fw_rule, param_rule, "destinationRanges")
}

do_cidr_ranges_overlap(fw_rule, param_rule, field_name) {
	# if there are no ranges defined, simply skip
	# be aware that we have already checked the existence 
	# or non-existence of sourceRanges in both 
	# parameter and firewall rules
	not lib.has_field(param_rule, field_name)
}

do_cidr_ranges_overlap(fw_rule, param_rule, field_name) {
	overlapped_ranges := [t | t := fw_rule[field_name][i]; any_cidr_overlap(t, param_rule[field_name])]
	count(overlapped_ranges) == count(fw_rule[field_name])
}

any_cidr_overlap(fw_cidr_range, param_cidr_ranges) {
	net.cidr_contains(param_cidr_ranges[_], fw_cidr_range)
}

######### CHECKING TYPE ############

check_type(fw_rule) = "allowed" {
	lib.has_field(fw_rule, "allowed")
}

check_type(fw_rule) = "denied" {
	lib.has_field(fw_rule, "denied")
}

######### CHECKING PROTOCOL PORT MATCH ############

do_all_protocols_and_ports_match(fw_rule, param_rule) {
	allowed_or_denied := check_type(fw_rule)

	# we collect all the protocol-port pairs that are covered by the parameters
	matched_ones := [t | t := fw_rule[allowed_or_denied][i]; does_a_protocol_and_port_match(t, param_rule[allowed_or_denied])]

	count(matched_ones) == count(fw_rule[allowed_or_denied])
}

does_a_protocol_and_port_match(fw_protocol_port, param_protocols_ports) {
	any_protocol_port_match(fw_protocol_port, param_protocols_ports[_])
}

any_protocol_port_match(fw_proto_port, param_proto_port) {
	lower(fw_proto_port.IPProtocol) == lower(param_proto_port.IPProtocol)
	lib.has_field(fw_proto_port, "ports")
	lib.has_field(param_proto_port, "ports")
	all_ports_match(fw_proto_port.ports, param_proto_port.ports)
}

any_protocol_port_match(fw_proto_port, param_proto_port) {
	lower(fw_proto_port.IPProtocol) == lower(param_proto_port.IPProtocol)
	not lib.has_field(fw_proto_port, "ports")
	not lib.has_field(param_proto_port, "ports")
}

all_ports_match(fw_ports, param_ports) {
	trace(sprintf("matching fw_ports %v to param_ports %v", [fw_ports, param_ports]))
	matched_ports := [t | t := fw_ports[i]; do_ports_match(t, param_ports[_])]
	trace(sprintf("matched fw_ports %v ", [matched_ports]))
	count(matched_ports) == count(fw_ports)
}

do_ports_match(fw_port, param_port) {
	fw_port == param_port
}

do_ports_match(fw_port, param_port) {
	# If both are ranges
	contains(fw_port, "-")
	contains(param_port, "-")
	range_match(fw_port, param_port)
}

do_ports_match(fw_port, param_port) {
	# If fw_port is a range but not parameter 
	contains(fw_port, "-")
	not contains(param_port, "-")
	param_port_range := sprintf("%s-%s", [param_port, param_port])
	range_match(fw_port, param_port_range)
}

do_ports_match(fw_port, param_port) {
	# If param_port is a range but not the actual firewall port 
	not contains(fw_port, "-")
	contains(param_port, "-")
	fw_port_range := sprintf("%s-%s", [fw_port, fw_port])
	range_match(fw_port_range, param_port)
}

# range_match tests if test_range is included in target_range
# returns true if test_range is equal to, or included in target_range
range_match(test_range, target_range) {
	# check if target_range is a range
	re_match("-", target_range)

	# check if test_range is a range
re_match(	"-", test_range)

	# getting the target range bounds
	target_range_bounds := split(target_range, "-")
	target_low_bound := to_number(target_range_bounds[0])
	target_high_bound := to_number(target_range_bounds[1])

	# getting the test range bounds
	test_range_bounds := split(test_range, "-")
	test_low_bound := to_number(test_range_bounds[0])
	test_high_bound := to_number(test_range_bounds[1])

	# check if test low bound is >= target low bound and target high bound >= test high bound
	test_low_bound >= target_low_bound

	test_high_bound <= target_high_bound
}

######### CHECKING REGEX MATCH FOR TAGS and SERVICE ACCOUNTS ############

do_all_regex_fields_match(fw_rule, param_rule, field_names) {
	matched_fields := [t | t := field_names[i]; do_fields_match(fw_rule, param_rule, t)]
	count(matched_fields) == count(field_names)
}

do_fields_match(fw_rule, param_rule, field_name) {
	# if the field does not exist in both, that's fine.
	not lib.has_field(fw_rule, field_name)
	not lib.has_field(param_rule, field_name)
}

# all the fields inside a firewall rules should be matched
# to achive this, we filter out matched ones. If any unmatched is left
# return false.
do_fields_match(fw_rule, param_rule, field_name) {
	matched_firewall_tags_sas := [t | t := fw_rule[field_name][i]; any_fw_tag_sa_match(t, param_rule[field_name])]
	trace(sprintf("field_name %v, matched_firewall_tags_sas %v, firewall items %v, tags_sas_param %v", [field_name, matched_firewall_tags_sas, fw_rule[field_name], param_rule[field_name]]))

	# if all the network tags of the firewall rule matches, 
	# then this rule is covered
	count(fw_rule[field_name]) == count(matched_firewall_tags_sas)
}

any_fw_tag_sa_match(fw_rule_items, tags_sas_param) {
	re_match(tags_sas_param[_], fw_rule_items)
}

######### CHECKING EXISTENCE OF FIELDS ############

# make sure that if a field is defined in fw_rule it should exist in parameter as well.
# and vice-versa. Any deviation means not match.
# We don't check protocol and port since they are displayed differently
do_all_fields_exist_in_both(fw_rule, param_rule) {
	fields := [
		"sourceTags",
		"sourceRanges",
		"sourceServiceAccounts",
		"targetTags",
		"targetServiceAccounts",
		"destinationRanges",
		"allowed",
		"denied",
		"direction",
	]

	field_in_both(fw_rule, param_rule, fields[_])
}

field_in_both(fw_rule, param_rule, field) {
	lib.has_field(fw_rule, field)
	lib.has_field(param_rule, field)
}

field_in_both(fw_rule, param_rule, field) {
	not lib.has_field(fw_rule, field)
	not lib.has_field(param_rule, field)
}
