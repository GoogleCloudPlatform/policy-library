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

import data.validator.gcp.lib as lib

deny[{
    "msg": message,
    "details": metadata,
}] {
    constraint := input.constraint
    lib.get_constraint_params(constraint, params)

    # Update params (set all missing params to their default value)
    updated_params := update_params(params)

    asset := input.asset
    asset.asset_type == "compute.googleapis.com/Firewall"

    fw_rule = asset.resource.data

    fw_rule_is_restricted(fw_rule, updated_params)

    message := sprintf("%s Firewall rule is prohibited.", [asset.name])
    metadata := {
        "resource": asset.name,
        # "restricted_rules": updated_params
    }
}

###########################
# Rule Utilities
###########################

# update_params - set all the default to input parameters
# All parameters are optional. update_params set all missing parameters to "any"
update_params(params) = updated_params {

    parameters := {
        "direction",
        "rule_type",
        "port",
        "protocol",
        "source_ranges",
        "target_ranges",
        "source_tags",
        "target_tags",
        "source_service_accounts",
        "target_service_accounts"
    }

    # set all default parameters to "any"
    updated_params := { parameter_name: parameter_value |
                            parameter_name := parameters[i]
                            parameter_value := lib.get_default(params, parameters[i], "any")}
    # trace(sprintf("%s", [updated_params]))
}

# fw_rule_is_restricted for Ingress rules
fw_rule_is_restricted(fw_rule, params) {

    # check direction
    out1 = fw_rule_check_direction(fw_rule, params)
    trace(sprintf("out1 %s", [out1]))

    # check rule type
    out2 = fw_rule_check_rule_type(fw_rule, params)
    trace(sprintf("out2 %s", [out2]))

    # trace(sprintf("%s", [ip_configs]))
    trace(    sprintf("asset: %s", [fw_rule.name]))
    ip_configs := fw_rule_get_ip_configs(fw_rule, params.rule_type)
    trace(sprintf("out3 true - ip_configs = %s", [ip_configs]))

    # check protocol and port
    out4 = fw_rule_check_protocol_and_port(ip_configs, params.protocol, params.port)
    trace(sprintf("out4 %s", [out4]))

    # Check sources (ip ranges and/or tags and/or service accounts)
    # out5 =     fw_rule_check_all_sources(fw_rule, params)
    # trace(sprintf("out5 %s", [out5]))

    # Check targets
    # fw_rule_check_all_targets(fw_rule, params)
}

#### Check direction functions

# fw_rule_check_direction when direction is set to any
fw_rule_check_direction(fw_rule, params){
    params.direction == "any"
}

# fw_rule_check_direction when direction is not set to any
fw_rule_check_direction(fw_rule, params){
    params.direction != "any"
    lower(params.direction) ==  lower(fw_rule.direction)
}

#### Check Type functions

# fw_rule_check_type when rule_type is set to any
fw_rule_check_rule_type(fw_rule, params){
    params.rule_type == "any"
}

# fw_rule_check_direction when direction is not set to any
fw_rule_check_rule_type(fw_rule, params){
    params.rule_type != "any"

    # test that the key exists in the fw_rule (allowed or denied)
    fw_rule[lower(params.rule_type)]
}

##### Get IP Config from rule

### fw_rule_get_ip_configs when rule_type is set to any and rule is allowed type
fw_rule_get_ip_configs(fw_rule, rule_type) = ip_configs{
    rule_type == "any"
    ip_configs = fw_rule.allowed
}


### fw_rule_get_ip_configs when rule_type is set to any and rule is allowed type
fw_rule_get_ip_configs(fw_rule, rule_type) = ip_configs{
    rule_type == "any"
    ip_configs = fw_rule.denied
}

### fw_rule_get_ip_configs when rule_type is not set to any
fw_rule_get_ip_configs(fw_rule, rule_type) = ip_configs{

    rule_type != "any"
    ip_configs = fw_rule[rule_type]
}

#### Check protocol + port functions

# fw_rule_check_protocol when one ip_configs is set to "all"
fw_rule_check_protocol_and_port(ip_configs, protocol, port) {
    trace("fw_rule_check_protocol_and_port all 1")
    ip_configs[_].ipProtocol == "all"
    trace("fw_rule_check_protocol_and_port all 2")
}

# fw_rule_check_protocol when protocol is set to any
fw_rule_check_protocol_and_port(ip_configs, protocol, port) {
    protocol == "any"
    trace("protocol = any ")
    out = fw_rule_check_port(ip_configs[_], port)
    trace(sprintf("ouput: %s", [out]))
}

# fw_rule_check_protocol when protocol is not set to any
fw_rule_check_protocol_and_port(ip_configs, protocol, port) {
    trace("protocol != any ")
    protocol != "any"
    trace("protocol != any 2")
    # Check if the protocol is in the rule
    ip_configs[i].ipProtocol == protocol
    trace("protocol != any 3")

    # Check if the associated port is also a match
    fw_rule_check_port(    ip_configs[i], port)

    trace("protocol != any 4")
}

# fw_rule_check_port when protocol is set to any
fw_rule_check_port(ip_configs, port) {
    port == "any"
    trace("fw_rule_check_port any")
}

# fw_rule_check_port when protocol is tcp, udp or all AND port is not set (i.e all ports match)
fw_rule_check_port(ip_config, port) {
    protocol_with_ports := {"tcp", "udp", "all"}
    trace("fw_rule_check_port for all")
    # only for protocol with ports or "all" - since it includes tcp and udp
    ip_config.ipProtocol == protocol_with_ports[_]

    trace("fw_rule_check_port for all 2")
    # if port is not set in ip_config, any port passed as a param matches
not     ip_config.port

    trace("fw_rule_check_port for all 3")
}

# fw_rule_check_port when port is a single number
fw_rule_check_port(ip_config, port) {
    port != "any"
    not re_match("-", port)

    # check if the port matches
    rule_ports := ip_config.port

    # check if port is in one of rule_ports values
	port_is_in_values(port, rule_ports[_])
}

# fw_rule_check_port when port is a range (e.g 100-200)
fw_rule_check_port(ip_config, port) {
    port != "any"
    re_match("-", port)

    trace("port is a range")

    # check if the port range is included in the fw_rule port
    rule_ports := ip_config.port
    trace(sprintf("almost %s", [rule_ports]))
	rule_port := rule_ports[_]

    # check if port range is included in one of rule_ports values
	# Note: if rule_port is not a range, range_match will return False
   	out = range_match(port, rule_port)
	trace(sprintf("all done out = %s for: %s", [out ,port]))
}

# port_is_in_values if rule_port is not a range
# Note: only called when port is not a range
port_is_in_values(port, rule_port) {
    # check if rule_port is not a range
    not re_match("-", rule_port)

    # test if rule port matches
    rule_port == port
}

# port_is_in_values if rule_port is a range
# Note: only called when port is not a range
port_is_in_values(port, rule_port) {
	trace(sprintf("ports_is_in_values, rule_port = %s port = %s", [rule_port, port]))
    # check if rule_port is a range
    re_match("-", rule_port)

	# build a simple port-port range to test if it belongs to rule_port range
	port_range := sprintf("%s-%s", [port, port])

	# Check if port is included in rule port
    range_match(port_range, rule_port)
}

# range_match tests if test_range is included in target_range
# returns true if test_range is equal to, or included in target_range
range_match(test_range, target_range) {
    # trace(sprintf("target range: %s vs test range: %s ", [target_range, test_range]))

    # check if target_range is a range
	re_match("-", target_range)

    # check if test_range is a range
	re_match("-", test_range)

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

#### Check source functions

# fw_rule_check_sources returns true if all sources matches based on parameters
# checks for source ranges, tags and service accounts
fw_rule_check_all_sources(fw_rule, params) {
    fw_rule_check_source_ranges(fw_rule, params)
    fw_rule_check_source_tags(fw_rule, params)
    # fw_rule_check_source_sas(fw_rule, params)
}

# fw_rule_check_source when source range is passed
fw_rule_check_source_ranges(fw_rule, params) {
    # Check if the source ranges are set in the params
    input_source_ranges := params.source_ranges

    # test if sourceRange exists in the rule
    fw_rule.sourceRange

    # check that source ranges are set
    source_ranges = fw_rule.sourceRange

    # check if any range matches
    # no CIDR matching logic at this time
    input_source_ranges[_] == source_ranges[_]
}

# fw_rule_check_source_ranges if no source range is passed
# any fw source range matches
fw_rule_check_source_ranges(fw_rule, params) {
    not params.source_ranges
}

# fw_rule_check_source when source tag is passed
fw_rule_check_source_tags(fw_rule, params) {
    # Check if the source tags are set in the params
    input_source_tags := params.source_tags

    # check that source tags are set
    source_tags := fw_rule.sourceTag

    # check if any tag matches
	re_match(input_source_tags[_], source_tags[_])
}

# fw_rule_check_source_tags if no source tag is passed
# any fw rule source tag matches
fw_rule_check_source_tags(fw_rule, params) {
    not params.source_tags
}

# fw_rule_check_source when source service account is passed
fw_rule_check_source_sas(fw_rule, params) {
    # Check if the source service account is set in the params
    input_source_sas := params.source_service_accounts

    # check that source service accounts are set
    source_sas = fw_rule.sourceServiceAccount

    # check if any service account matches
	re_match(input_source_sas[_], source_sas[_])
}

# fw_rule_check_source_sas if no source service account is passed
# any fw rule source service account matches
fw_rule_check_source_sas(fw_rule, params) {
    not params.source_service_accounts
}
