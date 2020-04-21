# cis-v1.1

This bundle can be installed via kpt:

```
export BUNDLE=cis-v1.1
kpt pkg get https://github.com/forseti-security/policy-library.git ./policy-library
kpt fn source policy-library/samples/ | \
  kpt fn run --image gcr.io/config-validator/get_policy_bundle:latest -- bundle=$BUNDLE | \
  kpt fn sink policy-library/policies/constraints/
```

## Constraints

| Constraint                                                                                                                    | Control | Description                                                                          |
| ----------------------------------------------------------------------------------------------------------------------------- | ------- | ------------------------------------------------------------------------------------ |
| [blacklist_gmail](../../samples/iam_restrict_gmail.yaml)                                                                      | 1.01    | Enforce corporate domain by banning gmail.com addresses                              |
| [blacklist_serviceaccount_token_creator](../../samples/iam_blacklist_service_account_creator_role.yaml)                       | 1.0X    | Ban any users from being granted Service Account Token Creator access                |
| [blacklist_serviceaccount_user](../../samples/iam_blacklist_role.yaml)                                                        | 1.05    | Ban any users from being granted Service Account User access                         |
| [cmek_rotation](../../samples/cmek_rotation.yaml)                                                                             | 1.08    |                                                                                      |
| [disable_gke_dashboard](../../samples/gke_dashboard_disable.yaml)                                                             | 7.06    | Ensure Kubernetes web UI / Dashboard is disabled                                     |
| [disable_gke_default_service_account](../../samples/gke_disable_default_service_account.yaml)                                 | 7.17    | Ensure default Service account is not used for Project access in Kubernetes Clusters |
| [disable_gke_legacy_abac](../../samples/gke_legacy_abac.yaml)                                                                 | 7.03    | Ensure Legacy Authorization is set to Disabled on Kubernetes Engine Clusters         |
| [dnssec_prevent_rsasha1_ksk](../../samples/dnssec_prevent_rsasha1_ksk.yaml)                                                   | 3.04    | Ensure that RSASHA1 is not used for key-signing key in Cloud DNS                     |
| [dnssec_prevent_rsasha1_zsk](../../samples/dnssec_prevent_rsasha1_zsk.yaml)                                                   | 3.05    | Ensure that RSASHA1 is not used for zone-signing key in Cloud DNS                    |
| [enable_alias_ip_ranges](../../samples/gke_enable_alias_ip_ranges.yaml)                                                       | 7.13    | Ensure Kubernetes Cluster is created with Alias IP ranges enabled                    |
| [enable_auto_repair](../../samples/gke_node_pool_auto_repair.yaml)                                                            | 7.07    | Ensure automatic node repair is enabled on all node pools in a GKE cluster           |
| [enable_auto_upgrade](../../samples/gke_node_pool_auto_upgrade.yaml)                                                          | 7.08    | Ensure Automatic node upgrades is enabled on Kubernetes Engine Clusters nodes        |
| [enable_gke_master_authorized_networks](../../samples/gke_master_authorized_networks_enabled.yaml)                            | 7.04    | Ensure Master authorized networks is set to Enabled on Kubernetes Engine Clusters    |
| [enable_gke_stackdriver_kubernetes_engine_monitoring](../../samples/gke_enable_stackdriver_kubernetes_engine_monitoring.yaml) | 7.01    | Ensure Stackdriver Kubernetes Engine Monitoring is enabled                           |
| [enable_network_flow_logs](../../samples/network_enable_flow_logs.yaml)                                                       | 3.09    | Ensure VPC Flow logs is enabled for every subnet in VPC Network                      |
| [enable_network_private_google_access](../../samples/network_enable_private_google_access.yaml)                               | 3.08    | Ensure Private Google Access is enabled for all subnetworks in VPC                   |
| [forbid_external_ip_whitelist](../../samples/vm_external_ip.yaml)                                                             | 4.08    |                                                                                      |
| [forbid_ip_forward](../../samples/compute_forbid_ip_forward.yaml)                                                             | 4.04    |                                                                                      |
| [gke_container_optimized_os](../../samples/gke_container_optimized_os.yaml)                                                   | 7.09    | Ensure Container-Optimized OS (cos) is used for Kubernetes Engine Clusters           |
| [gke_restrict_client_auth_methods](../../samples/gke_restrict_client_auth_methods.yaml)                                       | 7.12    |                                                                                      |
| [iam-restrict-service-account-key-age-ninety-days](../../samples/gcp_iam_restrict_service_account_key_age.yaml)               | 1.06    |                                                                                      |
| [iam_restrict_service_account_key_type](../../samples/gcp_iam_restrict_service_account_key_type.yaml)                         | 1.03    |                                                                                      |
| [prevent-public-ip-cloudsql](../../samples/sql_public_ip.yaml)                                                                | 6.05    | Prevents a public IP from being assigned to a Cloud SQL instance.                    |
| [require_bq_table_iam](../../samples/constraints/bigquery_world_readable.yaml)                                                | 5.03    |                                                                                      |
| [require_bucket_policy_only](../../samples/constraints/storage_bucket_policy_only.yaml)                                       | 5.02    |                                                                                      |
| [require_sql_ssl](../../samples/sql_ssl.yaml)                                                                                 | 6.01    |                                                                                      |
| [restrict-firewall-rule-rdp-world-open](../../samples/restrict_fw_rules_rdp_world_open.yaml)                                  | 3.07    |                                                                                      |
| [restrict-firewall-rule-ssh-world-open](../../samples/restrict_fw_rules_ssh_world_open.yaml)                                  | 3.06    |                                                                                      |
| [sql-world-readable](../../samples/constraints/sql_world_readable.yaml)                                                       | 6.02    |                                                                                      |

