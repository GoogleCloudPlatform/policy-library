# Config Validator Constraint Templates

## Available templates
The following templates can be found in [policy-library/policies/templates](https://github.com/brightjustin/policy-library/tree/master/policies/templates).

Service(s) | Template | Description
---------- | -------- | -----------
Google Cloud Platform | [gcp-always-violates-v1](../policies/templates/gcp-always-violates-v1.yaml) | Policy violates on all resources.
Google BigQuery | [gcp-bigquery-cmek-encryption-v1](../policies/templates/gcp-bigquery-cmek-encryption-v1.yaml) | Check if CMEK is enabled.
Google BigQuery | [gcp-bigquery-dataset-location-v1](../policies/templates/gcp-bigquery-dataset-location-v1.yaml) | Find BigQuery dataset location violations.
Google Key Management Services | [gcp-cmek-rotation-v1](../policies/templates/gcp-cmek-rotation-v1.yaml) | Validate CMEK rotation period.
