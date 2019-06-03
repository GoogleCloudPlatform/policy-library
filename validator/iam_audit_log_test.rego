package templates.gcp.GCPIAMAuditLogConstraintV1

# Find all violations from test constraint and data.
resources_in_violation[resource] {
	asset := data.test.fixtures.assets.iam_audit_log[_]
	constraint := data.test.fixtures.constraints.iam_audit_log
	issues := deny with input.asset as asset
		 with input.constraint as constraint

	resource := issues[_].details.resource
}

test_audit_log_skip_good_project {
	not resources_in_violation["//cloudresourcemanager.googleapis.com/projects/good"]
}

test_audit_log_skip_irrelevant_asset_type {
	not resources_in_violation["//cloudresourcemanager.googleapis.com/projects/ignore-asset-type"]
}

test_audit_log_missing_service {
	resources_in_violation["//cloudresourcemanager.googleapis.com/projects/wrong-service"]
}

test_audit_log_missing_log_types {
	resources_in_violation["//cloudresourcemanager.googleapis.com/projects/wrong-log-type"]
}
