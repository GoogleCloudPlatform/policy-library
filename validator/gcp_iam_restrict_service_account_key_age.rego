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

package templates.gcp.GCPIAMRestrictServiceAccountKeyAgeConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	asset := input.asset
	asset.asset_type == "iam.googleapis.com/ServiceAccountKey"
	key := asset.resource.data

	lib.get_constraint_params(constraint, params)

	valid_after_time := lib.get_default(key, "validAfterTime", "2200-01-01T01:00:006Z")
	created_time := time.parse_rfc3339_ns(valid_after_time)
	max_age = time.parse_duration_ns(params.max_age)
	now := time.now_ns()

	now - created_time > max_age

	valid_before_time := lib.get_default(key, "validBeforeTime", "1900-01-01T01:00:006Z")
	expiry_time := time.parse_rfc3339_ns(valid_before_time)
	now < expiry_time

	ancestry_path = lib.get_default(asset, "ancestry_path", "")

	message := sprintf("v%: key created since v% should be rotated", [key.name, valid_after_time])
	metadata := {"resource": asset.name, "ancestry_path": ancestry_path}
}
