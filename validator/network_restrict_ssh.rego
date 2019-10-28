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

package templates.gcp.GCPNetworkRestrictSSHConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	asset := input.asset
	asset.asset_type == "compute.googleapis.com/Firewall"

	rule := asset.resource.data

	allowed := rule.allowed[_]
	allowed.ipProtocol == "tcp"
	allowed.ports[_] == "22"

	rule.direction == "INGRESS"

	rule.sourceRanges[_] == "0.0.0.0/0"

	message := sprintf("SSH open to internet in firewall %v.", [asset.name])
	metadata := {"resource": asset.name}
}
