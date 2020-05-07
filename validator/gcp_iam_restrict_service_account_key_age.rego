<<<<<<< HEAD
# Copyright 2020 Google LLC
=======
# Copyright 2019 Google LLC
>>>>>>> c091676d7a89b6003d414a615cb791479b746b4b
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

	check_key_not_expired(key)
	check_key_age(key, params.max_age)

	message := sprintf("%v: key should be rotated", [asset.name])
	ancestry_path = lib.get_default(asset, "ancestry_path", "")

	metadata := {"resource": asset.name, "ancestry_path": ancestry_path}
}

check_key_not_expired(key) = check_key_not_expired {
	expiry_time := time.parse_rfc3339_ns(lib.get_default(key, "validBeforeTime", "1900-01-01T01:00:006Z"))
	now := time.now_ns()
	check_key_not_expired := now < expiry_time
}

check_key_age(key, max_age) = check_key_age {
	created_time := time.parse_rfc3339_ns(lib.get_default(key, "validAfterTime", "2200-01-01T01:00:006Z"))
	max_age_parsed := time.parse_duration_ns(max_age)
	key_age := time.now_ns() - created_time
	check_key_age := key_age > max_age_parsed
}
