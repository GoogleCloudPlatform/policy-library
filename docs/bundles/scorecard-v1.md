# scorecard-v1

## Constraints

| Constraint                                                                                         | Control                | Description                                                                       |
| -------------------------------------------------------------------------------------------------- | ---------------------- | --------------------------------------------------------------------------------- |
| [service_versions](../../samples/appengine_versions.yaml)                                          | operational-efficiency |                                                                                   |
| [require_bq_table_iam](../../samples/bigquery_world_readable.yaml)                                 | security               |                                                                                   |
| [dnssec_prevent_rsasha1_zsk](../../samples/dnssec_prevent_rsasha1_zsk.yaml)                        | security               | Ensure that RSASHA1 is not used for zone-signing key in Cloud DNS                 |
| [gke_allowed_node_service_account_scope_default](../../samples/gke_allowed_node_sa_scope.yaml)     | security               |                                                                                   |
| [disable_gke_dashboard](../../samples/gke_dashboard_disable.yaml)                                  | security               | Ensure Kubernetes web UI / Dashboard is disabled                                  |
| [disable_gke_legacy_endpoints](../../samples/gke_disable_legacy_endpoints.yaml)                    | security               |                                                                                   |
| [enable_gke_master_authorized_networks](../../samples/gke_master_authorized_networks_enabled.yaml) | security               | Ensure Master authorized networks is set to Enabled on Kubernetes Engine Clusters |
| [enable_auto_upgrade](../../samples/gke_node_pool_auto_upgrade.yaml)                               | security               | Ensure Automatic node upgrades is enabled on Kubernetes Engine Clusters nodes     |
| [gke_restrict_client_auth_methods](../../samples/gke_restrict_client_auth_methods.yaml)            | security               |                                                                                   |
| [enable_network_private_google_access](../../samples/network_enable_private_google_access.yaml)    | security               | Ensure Private Google Access is enabled for all subnetworks in VPC                |
| [restrict-firewall-rule-ssh-world-open](../../samples/restrict_fw_rules_ssh_world_open.yaml)       | security               |                                                                                   |
| [prevent-public-ip-cloudsql](../../samples/sql_public_ip.yaml)                                     | security               | Prevents a public IP from being assigned to a Cloud SQL instance.                 |
| [blacklist_public_users](../../samples/storage_blacklist_public.yaml)                              | security               | Prevent public users from having access to resources via IAM                      |

