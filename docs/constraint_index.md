# Config validator constraint templates
Constraint templates specify the logic to be used by constraints. This repository contains pre-defined constraint templates that you can implement or modify for your own needs. 

## Creating a constraint template
You can create and implement your own custom constraint templates. For instructions on how to write constraint templates, see [How to write your own constraint templates](constraint_template_authoring.md).

## Available templates
The following pre-defined templates can be found in [policy-library/policies/templates](https://github.com/brightjustin/policy-library/tree/master/policies/templates).

Service(s) | Template | Description
---------- | -------- | -----------
Google Cloud Platform | [gcp-allowed-resource-types-v1](../policies/templates/gcp_allowed_resource_types_v1.yaml) | Validate the array of resource types that will be either authorized (mode: whitelist) or denied (mode: blacklist).
Google Cloud Platform | [gcp-always-violates-v1](../policies/templates/gcp_always_violates_v1.yaml) | Policy violates on all resources.
Google BigQuery | [gcp-bigquery-cmek-encryption-v1](../policies/templates/gcp_bigquery_cmek_encryption_v1.yaml) | Check if CMEK is enabled.
Google BigQuery | [gcp-bigquery-dataset-location-v1](../policies/templates/gcp_bigquery_dataset_location_v1.yaml) | Find BigQuery dataset location violations.
Google Key Management Services | [gcp-cmek-rotation-v1](../policies/templates/gcp_cmek_rotation_v1.yaml) | Validate CMEK rotation period.
Google Compute Engine | [gcp-compute-external-ip-access-v1](../policies/templates/gcp_compute_external_ip_access_v1.yaml) | Validate if the resources have access to external IP addresses.
Google Compute Engine | [gcp-compute-zone-v1](../policies/templates/gcp_compute_zone_v1.yaml) | Define zone restrictions for Google Compute Engine resources.
Cloud DNS | [gcp-dnssec-v1](../policies/templates/gcp_dnssec_v1.yaml) | Validate whether DNSSEC is enabled.
Google Cloud Platform | [gcp-enforce-labels-v1](../policies/templates/gcp_enforce_labels_v1.yaml) | Validate that mandatory labels are set on supported resources.
Google Kubernetes Engine | [gcp-gke-allowed-node-sa-scope](../policies/templates/gcp_gke_allowed_node_sa_v1.yaml) | Validate the OAuth scopes assigned to the node service account.

## Learn more
For more information about using Config Validator and constraint templates, see the [Config Validator user guide](user_guide.md).
