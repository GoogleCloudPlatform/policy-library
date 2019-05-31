package templates.gcp.GCPIAMAuditLogConstraintV1

# Find all violations from test constraint and data.
violations[violation] {
	asset := data.test.fixtures.assets.iam_audit_log[_]
	constraint := data.test.fixtures.constraints.iam_audit_log
	issues := deny with input.asset as asset
		 with input.constraint as constraint

	violation := issues[_]
}

test_audit_log_violation_count {
	count(violations) == 2
}

test_audit_log_missing_service {
	violations[_].details.resource == "//cloudresourcemanager.googleapis.com/projects/wrong-service"
}

test_audit_log_missing_log_types {
	violations[_].details.resource == "//cloudresourcemanager.googleapis.com/projects/wrong-log-type"
}


