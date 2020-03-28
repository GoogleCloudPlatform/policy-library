# cis-v1.1

## Constraints

| Constraint                                                                                                                    | Control | Description                                                                       |
| ----------------------------------------------------------------------------------------------------------------------------- | ------- | --------------------------------------------------------------------------------- |
| [require_bq_table_iam](../../samples/bigquery_world_readable.yaml)                                                            | 5.03    |                                                                                   |
| [cmek_rotation](../../samples/cmek_rotation.yaml)                                                                             | 1.08    |                                                                                   |
| [forbid_external_ip_whitelist](../../samples/vm_external_ip.yaml)                                                             | 4.08    |                                                                                   |
| [dnssec_prevent_rsasha1_zsk](../../samples/dnssec_prevent_rsasha1_zsk.yaml)                                                   | 3.05    | Ensure that RSASHA1 is not used for zone-signing key in Cloud DNS                 |
| [disable_gke_dashboard](../../samples/gke_dashboard_disable.yaml)                                                             | 7.06    | Ensure Kubernetes web UI / Dashboard is disabled                                  |
| [enable_gke_stackdriver_kubernetes_engine_monitoring](../../samples/gke_enable_stackdriver_kubernetes_engine_monitoring.yaml) | 7.01    | Ensure Stackdriver Kubernetes Engine Monitoring is enabled                        |
| [enable_gke_master_authorized_networks](../../samples/gke_master_authorized_networks_enabled.yaml)                            | 7.04    | Ensure Master authorized networks is set to Enabled on Kubernetes Engine Clusters |
| [enable_auto_upgrade](../../samples/gke_node_pool_auto_upgrade.yaml)                                                          | 7.08    | Ensure Automatic node upgrades is enabled on Kubernetes Engine Clusters nodes     |
| [gke_restrict_client_auth_methods](../../samples/gke_restrict_client_auth_methods.yaml)                                       | 7.12    |                                                                                   |
| [blacklist_gmail](../../samples/iam_restrict_gmail.yaml)                                                                      | 1.01    | Enforce corporate domain by banning gmail.com addresses                           |
| [blacklist_serviceaccount_user](../../samples/iam_blacklist_role.yaml)                                                        | 1.05    | Ban any users from being granted Service Account User access                      |
| [iam_restrict_service_account_key_type](../../samples/gcp_iam_restrict_service_account_key_type.yaml)                         | 1.03    |                                                                                   |
| [enable_network_private_google_access](../../samples/network_enable_private_google_access.yaml)                               | 3.08    | Ensure Private Google Access is enabled for all subnetworks in VPC                |
| [restrict-firewall-rule-ssh-world-open](../../samples/restrict_fw_rules_ssh_world_open.yaml)                                  | 3.06    |                                                                                   |
| [prevent-public-ip-cloudsql](../../samples/sql_public_ip.yaml)                                                                | 6.05    | Prevents a public IP from being assigned to a Cloud SQL instance.                 |

