#
# Copyright 2018 Google LLC
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

package templates.gcp.GCPLBAllowedForwardingRulesConstraintV2

import data.validator.gcp.lib as lib

###########################
# Find allowlist Violations
###########################
deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	asset := input.asset

	is_forwarding_rule(asset.asset_type)

	instance := asset.resource.data

	rule := get_allowlist_entry(params.allowlist, instance.target)
	rule

	invalid_forwarding_rule(rule, instance)

	message := sprintf("%v is not allowed, violates allowlist policy.", [asset.name])
	metadata := {"resource": asset.name}
}

###########################
# Rule Utilities
###########################

is_forwarding_rule(asset_type) {
	asset_type == "compute.googleapis.com/ForwardingRule"
}

is_forwarding_rule(asset_type) {
	asset_type == "compute.googleapis.com/GlobalForwardingRule"
}

get_allowlist_entry(allowlist, target) = output {
	rule := allowlist[_]
	rule.target == target
	output = rule
}

check_scheme(rule, resource) {
	rule.load_balancing_scheme
	rule.load_balancing_scheme == resource.loadBalancingScheme
}

check_scheme(rule, resource) {
	not rule.load_balancing_scheme
}

check_ip_protocol(rule, resource) {
	rule.ip_protocol
	rule.ip_protocol == resource.IPProtocol
}

check_ip_protocol(rule, resource) {
	not rule.ip_protocol
}

check_ip_address(rule, resource) {
	rule.ip_address
	rule.ip_address == resource.IPAddress
}

check_ip_address(rule, resource) {
	not rule.ip_address
}

check_port_range(rule, resource) {
	rule.port_range
	rule.port_range == resource.portRange
}

check_port_range(rule, resource) {
	not rule.port_range
}

invalid_forwarding_rule(rule, resource) {
	not check_scheme(rule, resource)
}

invalid_forwarding_rule(rule, resource) {
	not check_ip_address(rule, resource)
}

invalid_forwarding_rule(rule, resource) {
	not check_ip_protocol(rule, resource)
}

invalid_forwarding_rule(rule, resource) {
	not check_port_range(rule, resource)
}
