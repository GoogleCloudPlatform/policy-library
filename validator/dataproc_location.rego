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

package templates.gcp.GCPDataprocLocationConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)

	asset := input.asset

	# Applies to dataproc clusters only
	asset.asset_type == "dataproc.googleapis.com/Cluster"

	# Retrieve the list of allowed locations
	locations := params.locations

	# The asset raises a violation if location_is_valid is evaluated to false
	not location_is_valid(asset, locations)

	message := sprintf("%v is in violation.", [asset.name])
	metadata := {
		"resource": asset.name,
		"valid-locations": locations,
	}
}

###########################
# Rule Utilities
###########################

location_is_valid(asset, locations) {
	# ensure we have a data object
	resource := asset.resource.data

	# Retrieve the location 
	resouce_location := resource.labels["goog-dataproc-location"]

	# iterate through the locations
	location := locations[_]

	# the resource location is valid if it matches one of the passed locations
	re_match(location, resouce_location)
}
