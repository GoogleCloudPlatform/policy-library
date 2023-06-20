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

package templates.gcp.GCPNetworkEnableFlowLogsConstraintV1

import data.validator.gcp.lib as lib

resources_in_violation[resource] {
	asset := data.test.fixtures.network_enable_flow_logs.assets[_]
	constraint := data.test.fixtures.network_enable_flow_logs.constraints
	issues := deny with input.asset as asset
		 with input.constraint as constraint

	resource := issues[_].details.resource
}

test_flow_logs_enabled {
	not resources_in_violation["//compute.googleapis.com/projects/pso-cicd8/regions/us-west1/subnetworks/correct"]
}

test_flow_logs_disabled {
	resources_in_violation["//compute.googleapis.com/projects/pso-cicd8/regions/us-west1/subnetworks/bad"]
}

test_flow_logs_disabled_for_both {
	resources_in_violation["//compute.googleapis.com/projects/pso-cicd8/regions/us-west1/subnetworks/both_false"]
}

test_flow_logs_regional_managed_proxy {
	not resources_in_violation["//compute.googleapis.com/projects/pso-cicd8/regions/us-west1/subnetworks/regional_managed_proxy"]
}

test_flow_logs_internal_https_load_balancer {
	not resources_in_violation["//compute.googleapis.com/projects/pso-cicd8/regions/us-west1/subnetworks/internal_https_load_balancer"]
}

test_flow_logs_enabled_for_both {
	not resources_in_violation["//compute.googleapis.com/projects/pso-cicd8/regions/us-west1/subnetworks/both_correct"]
}

test_flow_logs_enabled_for_log_config {
	not resources_in_violation["//compute.googleapis.com/projects/pso-cicd8/regions/us-west1/subnetworks/only_log_config"]
}
