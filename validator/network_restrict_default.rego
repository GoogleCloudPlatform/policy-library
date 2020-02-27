# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#			http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package templates.gcp.GCPNetworkRestrictDefaultConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	a := input.asset
	count({a.asset_type} & {"compute.googleapis.com/Network", "google.compute.Network"}) == 1
	a.resource.data.name == "default"
	name := a.name
	message := sprintf("Default network in use: %v", [name])
	ancestry_path = lib.get_default(input.asset, "ancestry_path", "")

	metadata := {"resource": name, "ancestry_path": ancestry_path}
}
