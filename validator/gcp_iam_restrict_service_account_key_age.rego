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
	metadata := {"resource": asset.name}
}

check_key_not_expired(key) {
	expiry_time := time.parse_rfc3339_ns(lib.get_default(key, "validBeforeTime", "1900-01-01T01:00:006Z"))
	expiry_time >= 0
	now := time.now_ns()
	now < expiry_time
}

# Workaround for dates in the far future - https://github.com/open-policy-agent/opa/issues/4098
check_key_not_expired(key) {
	expiry_time := time.parse_rfc3339_ns(lib.get_default(key, "validBeforeTime", "1900-01-01T01:00:006Z"))
	expiry_time < 0
}

check_key_age(key, max_age) {
	created_time := time.parse_rfc3339_ns(lib.get_default(key, "validAfterTime", "2200-01-01T01:00:006Z"))
	max_age_parsed := time.parse_duration_ns(max_age)
	key_age := time.now_ns() - created_time
	key_age > max_age_parsed
}
