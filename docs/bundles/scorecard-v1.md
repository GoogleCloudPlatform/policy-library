# scorecard-v1

## Constraints

| Constraint                                                                                      | Control                | Description                                                                  |
| ----------------------------------------------------------------------------------------------- | ---------------------- | ---------------------------------------------------------------------------- |
| [service_versions](../../samples/appengine_versions.yaml)                                       | operational-efficiency |                                                                              |
| [require_bq_table_iam](../../samples/bigquery_world_readable.yaml)                              | security               |                                                                              |
| [dnssec_prevent_rsasha1_zsk](../../samples/dnssec_prevent_rsasha1_zsk.yaml)                     | security               | Ensure that RSASHA1 is not used for zone-signing key in Cloud DNS            |
| [gke_allowed_node_service_account_scope_default](../../samples/gke_allowed_node_sa_scope.yaml)  | security               |                                                                              |
| [disable_gke_dashboard](../../samples/gke_dashboard_disable.yaml)                               | security               | Ensure Kubernetes web UI / Dashboard is disabled                             |
| [disable_gke_legacy_endpoints](../../samples/gke_disable_legacy_endpoints.yaml)                 | security               |                                                                              |
| [disable_gke_legacy_abac](../../samples/gke_legacy_abac.yaml)                                   | security               | Ensure Legacy Authorization is set to Disabled on Kubernetes Engine Clusters |
| [enable_auto_repair](../../samples/gke_node_pool_auto_repair.yaml)                              | security               | Ensure automatic node repair is enabled on all node pools in a GKE cluster   |
| [allow_only_private_cluster](../../samples/gke_allow_only_private_cluster.yaml)                 | security               |                                                                              |
| [gke_restrict_pod_traffic](../../samples/gke_restrict_pod_traffic.yaml)                         | security               |                                                                              |
| [blacklist_all_users](../../samples/iam_blacklist_public.yaml)                                  | security               | Prevent public users from having access to resources via IAM                 |
| [enable_network_private_google_access](../../samples/network_enable_private_google_access.yaml) | security               | Ensure Private Google Access is enabled for all subnetworks in VPC           |
| [restrict-firewall-rule-ssh-world-open](../../samples/restrict_fw_rules_ssh_world_open.yaml)    | security               |                                                                              |
| [prevent-public-ip-cloudsql](../../samples/sql_public_ip.yaml)                                  | security               | Prevents a public IP from being assigned to a Cloud SQL instance.            |

