package templates.gcp.GCPIAMAuditLogConstraintV1

# Find all violations from test constraint and data.
violations[violation] {
	asset := data.test.fixtures.assets.iam_audit_log[_]
	constraint := data.test.fixtures.constraints.iam_audit_log
	issues := deny with input.asset as asset
		 with input.constraint as constraint

	violation := issues[_]
}

test_audit_log_violation {
	count(violations) == 0
}
