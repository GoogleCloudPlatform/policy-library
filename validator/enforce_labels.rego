#
# Copyright 2018 Google LLC
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

# Note: supported resource types for this rule: 
# - projects
# - buckets
# - k8s pods

package templates.gcp.GCPResourceLabelsV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	asset := input.asset

	mandatory_labels := params.mandatory_labels[_]
	not labelIsValid(mandatory_labels, asset)

	message := sprintf("%v doesn't have a required label.", [asset.name])

	metadata := {"resource": asset.name, "mandatory_labels": mandatory_labels}
}

# generic labelIsValid for all resources
labelIsValid(label, asset) {
	resource := getLabel(asset)
	resourceLabels := lib.get_default(resource, "labels", {})
	labelValue := resourceLabels[label]
}

# getGenericLabel Object for standard resources
getGenericLabel(asset) = resource {
	resource := asset.resource.data
}

# getLabel for standard resources
getLabel(asset) = resource {
	standard_resource_types = [
		"cloudresourcemanager.googleapis.com/Project",
		"storage.googleapis.com/Bucket",
		"compute.googleapis.com/Instance"
	]

	standard_resource_types[_] == asset.asset_type
	resource := getGenericLabel(asset)
}

# Non-standard labels locations for resources
# i.e not in resource.data

# getLabel for resources with lables in metadata
getLabel(asset) = resource {
	matching_resource_types = [
		"k8s.io/Pod"
	]
	matching_resource_types[_] == asset.asset_type 
	resource := asset.resource.data.metadata
}
