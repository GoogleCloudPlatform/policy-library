package templates.gcp.SQLPUBLICIPV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	asset := input.asset
	asset.asset_type == "sqladmin.googleapis.com/Instance"

	asset.resource.data.settings.ipConfiguration.ipv4Enabled == true

	message := sprintf("%v is not allowed to have an external IP.", [asset.name])
	metadata := {"resource": asset.name}
}
