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

package templates.gcp.GCPExampleConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	# The special "input" object has a constraint field that maps to the
	# constraint .yaml content.
	constraint := input.constraint

	# The parameters are declared in the constraint template and
	# specified in the constraint.
	params := lib.get_constraint_params(constraint)

	# The "input" object also has an asset field that maps to an asset
	# to be validated against the constraint.
	asset := input.asset

	# In this example, the business logic is to check for the presence of
	# the asset name in the input parameter.
	# A violation happens if the given input asset name is in the
	# "asset_names" parameter.
	{asset.name} == {asset.name} & cast_set(params.asset_names)

	# You'd want to customize the error message and metadata here.
	message := sprintf("%v is a bad asset.", [asset.name])	
	metadata := {"resource": asset.name}
}
