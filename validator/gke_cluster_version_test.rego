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

package templates.gcp.GKEClusterVersionConstraintV1

# Importing the test data
import data.test.fixtures.gke_cluster_version.assets as fixture_assets

# Importing the test constraints for testing master version
import data.test.fixtures.gke_cluster_version.constraints.master_version_allowlist_all as master_version_allowlist_all
import data.test.fixtures.gke_cluster_version.constraints.master_version_allowlist_none as master_version_allowlist_none
import data.test.fixtures.gke_cluster_version.constraints.master_version_allowlist_one as master_version_allowlist_one
import data.test.fixtures.gke_cluster_version.constraints.master_version_allowlist_one_exemption as master_version_allowlist_one_exemption
import data.test.fixtures.gke_cluster_version.constraints.master_version_denylist_all as master_version_denylist_all
import data.test.fixtures.gke_cluster_version.constraints.master_version_denylist_none as master_version_denylist_none
import data.test.fixtures.gke_cluster_version.constraints.master_version_denylist_one as master_version_denylist_one
import data.test.fixtures.gke_cluster_version.constraints.master_version_denylist_one_exemption as master_version_denylist_one_exemption

# Importing the test constraints for testing node version
import data.test.fixtures.gke_cluster_version.constraints.node_version_allowlist_all as node_version_allowlist_all
import data.test.fixtures.gke_cluster_version.constraints.node_version_allowlist_none as node_version_allowlist_none
import data.test.fixtures.gke_cluster_version.constraints.node_version_allowlist_one as node_version_allowlist_one
import data.test.fixtures.gke_cluster_version.constraints.node_version_allowlist_one_exemption as node_version_allowlist_one_exemption
import data.test.fixtures.gke_cluster_version.constraints.node_version_denylist_all as node_version_denylist_all
import data.test.fixtures.gke_cluster_version.constraints.node_version_denylist_none as node_version_denylist_none
import data.test.fixtures.gke_cluster_version.constraints.node_version_denylist_one as node_version_denylist_one
import data.test.fixtures.gke_cluster_version.constraints.node_version_denylist_one_exemption as node_version_denylist_one_exemption

# Find all violations on our test cases
find_all_violations[violation] {
	resources := data.resources[_]
	constraint := data.test_constraints[_]
	issues := deny with input.asset as resources
		 with input.constraint as constraint

	violation := issues[_]
}

# Test logic for master version allowlisting/denylisting
test_target_version_match_count_allowlist {
	target_version_match_count("allowlist", match_count)
	match_count == 0
}

test_target_version_match_count_denylist {
	target_version_match_count("denylist", match_count)
	match_count == 1
}

# Test for master version no violations with no assets
test_gke_cluster_no_assets_master_version {
	violations := find_all_violations with data.resources as []

	count(violations) == 0
}

# Test master version empty denylist
violations_with_empty_denylist_master_version[violation] {
	constraints := [master_version_denylist_none]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_denylist_none_master_version {
	violations := violations_with_empty_denylist_master_version

	count(violations) == 0
}

# Test master version empty allowlist
violations_with_empty_allowlist_master_version[violation] {
	constraints := [master_version_allowlist_none]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_master_version_allowlist_none_master_version {
	violations := violations_with_empty_allowlist_master_version

	count(violations) == count(fixture_assets)

	resource_names := {x | x = violations[_].details.resource}

	expected_resource_names := {
		"//container.googleapis.com/projects/pso-cicd8/zones/us-west1-b/clusters/canary-west",
		"//container.googleapis.com/projects/cicd-prod/zones/us-west1-a/clusters/redditmobile-canary-west",
		"//container.googleapis.com/projects/release-2-19-0-gke/zones/us-central1-a/clusters/forseti-cluster",
		"//container.googleapis.com/projects/cicd-staging/zones/us-west1-a/clusters/redditmobile-staging",
	}

	resource_names == expected_resource_names

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Test master version denylist with single version
violations_with_single_denylist_master_version[violation] {
	constraints := [master_version_denylist_one]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_denylist_one_master_version {
	violations := violations_with_single_denylist_master_version

	count(violations) == 2

	resource_name := {x | x = violations[_].details.resource}

	expected_resource_name := {
		"//container.googleapis.com/projects/pso-cicd8/zones/us-west1-b/clusters/canary-west",
		"//container.googleapis.com/projects/cicd-staging/zones/us-west1-a/clusters/redditmobile-staging",
	}

	resource_name == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Test master version allowlist with single version
violations_with_single_allowlist_master_version[violation] {
	constraints := [master_version_allowlist_one]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_allowlist_one_master_version {
	violations := violations_with_single_allowlist_master_version

	count(violations) == 2

	resource_names := {x | x = violations[_].details.resource}

	expected_resource_names := {
		"//container.googleapis.com/projects/cicd-prod/zones/us-west1-a/clusters/redditmobile-canary-west",
		"//container.googleapis.com/projects/release-2-19-0-gke/zones/us-central1-a/clusters/forseti-cluster",
	}

	resource_names == expected_resource_names

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Test master version denylist with single version and one exemption
violations_with_single_denylist_exemption_master_version[violation] {
	constraints := [master_version_denylist_one_exemption]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_denylist_one_exemption_master_version {
	violations := violations_with_single_denylist_exemption_master_version

	count(violations) == 1

	resource_name := {x | x = violations[_].details.resource}

	expected_resource_name := {"//container.googleapis.com/projects/pso-cicd8/zones/us-west1-b/clusters/canary-west"}

	resource_name == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Test master version allowlist with single version and one exemption
violations_with_single_allowlist_exemption_master_version[violation] {
	constraints := [master_version_allowlist_one_exemption]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_allowlist_one_exemption_master_version {
	violations := violations_with_single_allowlist_exemption_master_version

	count(violations) == 1

	resource_name := {x | x = violations[_].details.resource}

	expected_resource_name := {"//container.googleapis.com/projects/release-2-19-0-gke/zones/us-central1-a/clusters/forseti-cluster"}

	resource_name == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Test master version denylist with all versions
violations_with_full_denylist_master_version[violation] {
	constraints := [master_version_denylist_all]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_denylist_all_master_version {
	violations := violations_with_full_denylist_master_version

	count(violations) == count(fixture_assets)

	resource_names := {x | x = violations[_].details.resource}

	expected_resource_names := {
		"//container.googleapis.com/projects/pso-cicd8/zones/us-west1-b/clusters/canary-west",
		"//container.googleapis.com/projects/cicd-prod/zones/us-west1-a/clusters/redditmobile-canary-west",
		"//container.googleapis.com/projects/release-2-19-0-gke/zones/us-central1-a/clusters/forseti-cluster",
		"//container.googleapis.com/projects/cicd-staging/zones/us-west1-a/clusters/redditmobile-staging",
	}

	resource_names == expected_resource_names

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Test master version allowlist with all versions
violations_with_full_allowlist_master_version[violation] {
	constraints := [master_version_allowlist_all]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_allowlist_all_master_version {
	violations := violations_with_full_allowlist_master_version

	count(violations) == 0
}

# Test logic for node version allowlisting/denylisting
test_target_version_match_count_allowlist_node_version {
	target_version_match_count("allowlist", match_count)
	match_count == 0
}

test_target_version_match_count_denylist_node_version {
	target_version_match_count("denylist", match_count)
	match_count == 1
}

# Test for node version no violations with no assets
test_gke_cluster_no_assets_node_version {
	violations := find_all_violations with data.resources as []

	count(violations) == 0
}

# Test node version empty denylist
violations_with_empty_denylist_node_version[violation] {
	constraints := [node_version_denylist_none]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_denylist_none_node_version {
	violations := violations_with_empty_denylist_node_version

	count(violations) == 0
}

# Test node version empty allowlist
violations_with_empty_allowlist_node_version[violation] {
	constraints := [node_version_allowlist_none]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_allowlist_none_node_version {
	violations := violations_with_empty_allowlist_node_version

	count(violations) == count(fixture_assets)

	resource_names := {x | x = violations[_].details.resource}

	expected_resource_names := {
		"//container.googleapis.com/projects/pso-cicd8/zones/us-west1-b/clusters/canary-west",
		"//container.googleapis.com/projects/cicd-prod/zones/us-west1-a/clusters/redditmobile-canary-west",
		"//container.googleapis.com/projects/release-2-19-0-gke/zones/us-central1-a/clusters/forseti-cluster",
		"//container.googleapis.com/projects/cicd-staging/zones/us-west1-a/clusters/redditmobile-staging",
	}

	resource_names == expected_resource_names

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Test node version denylist with single version
violations_with_single_denylist_node_version[violation] {
	constraints := [node_version_denylist_one]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_denylist_one_node_version {
	violations := violations_with_single_denylist_node_version

	count(violations) == 1

	resource_name := {x | x = violations[_].details.resource}

	expected_resource_name := {"//container.googleapis.com/projects/pso-cicd8/zones/us-west1-b/clusters/canary-west"}

	resource_name == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Test node version allowlist with single version
violations_with_single_allowlist_node_version[violation] {
	constraints := [node_version_allowlist_one]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_allowlist_one_node_version {
	violations := violations_with_single_allowlist_node_version

	count(violations) == 3

	resource_names := {x | x = violations[_].details.resource}

	expected_resource_names := {
		"//container.googleapis.com/projects/cicd-prod/zones/us-west1-a/clusters/redditmobile-canary-west",
		"//container.googleapis.com/projects/cicd-staging/zones/us-west1-a/clusters/redditmobile-staging",
		"//container.googleapis.com/projects/release-2-19-0-gke/zones/us-central1-a/clusters/forseti-cluster",
	}

	resource_names == expected_resource_names

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Test node version denylist with versions and one exemption
violations_with_single_denylist_exemption_node_version[violation] {
	constraints := [node_version_denylist_one_exemption]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_denylist_one_exemption_node_version {
	violations := violations_with_single_denylist_exemption_node_version

	count(violations) == 1

	resource_name := {x | x = violations[_].details.resource}

	expected_resource_name := {"//container.googleapis.com/projects/cicd-staging/zones/us-west1-a/clusters/redditmobile-staging"}

	resource_name == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Test node version allowlist with versions and one exemption
violations_with_single_allowlist_exemption_node_version[violation] {
	constraints := [node_version_allowlist_one_exemption]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_allowlist_one_exemption_node_version {
	violations := violations_with_single_allowlist_exemption_node_version

	count(violations) == 2

	resource_name := {x | x = violations[_].details.resource}

	expected_resource_name := {
		"//container.googleapis.com/projects/cicd-staging/zones/us-west1-a/clusters/redditmobile-staging",
		"//container.googleapis.com/projects/release-2-19-0-gke/zones/us-central1-a/clusters/forseti-cluster",
	}

	resource_name == expected_resource_name

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Test node version denylist with all versions
violations_with_full_denylist_node_version[violation] {
	constraints := [node_version_denylist_all]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_denylist_all_node_version {
	violations := violations_with_full_denylist_node_version

	count(violations) == count(fixture_assets)

	resource_names := {x | x = violations[_].details.resource}

	expected_resource_names := {
		"//container.googleapis.com/projects/pso-cicd8/zones/us-west1-b/clusters/canary-west",
		"//container.googleapis.com/projects/cicd-prod/zones/us-west1-a/clusters/redditmobile-canary-west",
		"//container.googleapis.com/projects/release-2-19-0-gke/zones/us-central1-a/clusters/forseti-cluster",
		"//container.googleapis.com/projects/cicd-staging/zones/us-west1-a/clusters/redditmobile-staging",
	}

	resource_names == expected_resource_names

	violation := violations[_]
	is_string(violation.msg)
	is_object(violation.details)
}

# Test node version allowlist with all versions
violations_with_full_allowlist_node_version[violation] {
	constraints := [node_version_allowlist_all]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_gke_cluster_allowlist_all_node_version {
	violations := violations_with_full_allowlist_node_version

	count(violations) == 0
}
