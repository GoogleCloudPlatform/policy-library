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

package templates.gcp.GCPSQLMaintenanceWindowConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	# Verify that resource is Cloud SQL instance and is not a first gen
	# Maintenance window is supported only on 2nd generation instances
	asset := input.asset
	asset.asset_type == "sqladmin.googleapis.com/Instance"
	asset.resource.data.backendType != "FIRST_GEN"

	# get the day object
	maintenance_window := lib.get_default(asset.resource.data.settings, "maintenanceWindow", {})
	day := lib.get_default(maintenance_window, "day", 0)

	# Verify day is zero to trigger a non compliance
	day == 0

	message := sprintf("%v missing maintenance window.", [asset.name])
	metadata := {"resource": asset.name}
}
