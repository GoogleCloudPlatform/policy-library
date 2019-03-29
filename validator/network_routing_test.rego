package templates.gcp.GCPNetworkRoutingConstraint

all_violations[violation] {
	resource := data.test.fixtures.assets.networks[_]
	constraint := data.test.fixtures.constraints.network_routing

	issues := deny with input.asset as resource
		 with input.constraint as constraint

	violation := issues[_]
}

# Confirm total violations count
test_routing_violations_count {
	count(all_violations) == 1
}

test_routing_violations_basic {
	violation := all_violations[_]
	violation.details.resource == "//compute.googleapis.com/projects/test-project/global/networks/regional-example"
}
