#
# Copyright 2021 Google LLC
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

package templates.gcp.GCPPostgreSQLCheckpointsConstraintV1

import data.validator.gcp.lib as lib

# A violation is generated only when the rule body evaluates to true.
deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	asset := input.asset
	asset.asset_type == "sqladmin.googleapis.com/Instance"
	instance := asset.resource.data
	key = "log_checkpoints"

	# get instance settings
	settings := lib.get_default(instance, "settings", {"databaseFlags": []})

	# check if key is available and values are as expected
	not settings_databaseflags(settings)

	message := sprintf("On this resource %v check the required key '%v' is in violation.", [asset.name, key])
	metadata := {"resource": asset.name, "key_in_violation": key}
}

# All other cases for settings databaseflags are violations
default settings_databaseflags(settings) = false

# check for log_checkpoints under settings databaseflags - no violation
settings_databaseflags(settings) {
	setdata := settings.databaseFlags[_]
	setdata.name == "log_checkpoints"
	setdata.value != "on"
}
