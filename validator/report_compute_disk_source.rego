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

package templates.gcp.GCPReportComputeDiskSourceV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	asset := input.asset
	asset.asset_type == "compute.googleapis.com/Disk"

	source_image := lib.get_default(asset.resource.data, "sourceImage", "")
	source_snapshot := lib.get_default(asset.resource.data, "sourceSnapshot", "")
	source_info := disk_source(source_image, source_snapshot)
	message := sprintf("%v.", [source_info])
	ancestry_path = lib.get_default(asset, "ancestry_path", "")

	metadata := {"resource": asset.name, "ancestry_path": ancestry_path}
}

#################
# Rule Utilities
#################

# Determine the overlap between locations under test and constraint
disk_source(source_image, source_snapshot) = source_info {
	source_image != ""
	source_snapshot == ""
	source_info = sprintf("sourceImage: %v", [source_image])
}

disk_source(source_image, source_snapshot) = source_info {
	source_snapshot != ""
	source_image == ""
	source_info = sprintf("sourceSnapshot: %v", [source_snapshot])
}

disk_source(source_image, source_snapshot) = source_info {
	source_snapshot == ""
	source_image == ""
	source_info = ""
}
