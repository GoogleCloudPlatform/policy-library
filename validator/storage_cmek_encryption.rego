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

package templates.gcp.GCPStorageCMEKEncryptionConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	asset := input.asset
	asset.asset_type == "storage.googleapis.com/Bucket"

	bucket := asset.resource.data
	kms_key_name := default_kms_key_name(bucket)
	kms_key_name == ""

	message := sprintf("%v does not have the required CMEK encryption configured.", [asset.name])
	metadata := {
		"default_kms_key_name": kms_key_name,
		"resource": asset.name,
	}
}

###########################
# Rule Utilities
###########################
default_kms_key_name(bucket) = default_kms_key_name {
	encryption := lib.get_default(bucket, "encryption", {})
	default_kms_key_name := lib.get_default(encryption, "defaultKmsKeyName", "")
}
