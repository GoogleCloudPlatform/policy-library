# scorecard-v1

This bundle can be installed via kpt:

```
export BUNDLE=scorecard-v1
kpt pkg get https://github.com/forseti-security/policy-library.git ./policy-library
kpt fn source policy-library/samples/ | \
  kpt fn run --image gcr.io/config-validator/get_policy_bundle:latest -- bundle=$BUNDLE | \
  kpt fn sink policy-library/policies/constraints/
```

## Constraints

| Constraint                                                                                         | Control                | Description                                                                          |
| -------------------------------------------------------------------------------------------------- | ---------------------- | ------------------------------------------------------------------------------------ |
| [allow_only_private_cluster](../../samples/gke_allow_only_private_cluster.yaml)                    | security               |                                                                                      |
| [blacklist_all_users](../../samples/iam_blacklist_public.yaml)                                     | security               | Prevent public users from having access to resources via IAM                         |
| [blacklist_public_users](../../samples/constraints/storage_blacklist_public.yaml)                  | security               | Prevent public users from having access to resources via IAM                         |
| [disable_gke_dashboard](../../samples/gke_dashboard_disable.yaml)                                  | security               | Ensure Kubernetes web UI / Dashboard is disabled                                     |
| [disable_gke_default_service_account](../../samples/gke_disable_default_service_account.yaml)      | security               | Ensure default Service account is not used for Project access in Kubernetes Clusters |
| [disable_gke_legacy_abac](../../samples/gke_legacy_abac.yaml)                                      | security               | Ensure Legacy Authorization is set to Disabled on Kubernetes Engine Clusters         |
| [disable_gke_legacy_endpoints](../../samples/gke_disable_legacy_endpoints.yaml)                    | security               |                                                                                      |
| [dnssec_prevent_rsasha1_ksk](../../samples/dnssec_prevent_rsasha1_ksk.yaml)                        | security               | Ensure that RSASHA1 is not used for key-signing key in Cloud DNS                     |
| [dnssec_prevent_rsasha1_zsk](../../samples/dnssec_prevent_rsasha1_zsk.yaml)                        | security               | Ensure that RSASHA1 is not used for zone-signing key in Cloud DNS                    |
| [enable_alias_ip_ranges](../../samples/gke_enable_alias_ip_ranges.yaml)                            | security               | Ensure Kubernetes Cluster is created with Alias IP ranges enabled                    |
| [enable_auto_repair](../../samples/gke_node_pool_auto_repair.yaml)                                 | security               | Ensure automatic node repair is enabled on all node pools in a GKE cluster           |
| [enable_auto_upgrade](../../samples/gke_node_pool_auto_upgrade.yaml)                               | security               | Ensure Automatic node upgrades is enabled on Kubernetes Engine Clusters nodes        |
| [enable_gke_master_authorized_networks](../../samples/gke_master_authorized_networks_enabled.yaml) | security               | Ensure Master authorized networks is set to Enabled on Kubernetes Engine Clusters    |
| [enable_network_flow_logs](../../samples/network_enable_flow_logs.yaml)                            | security               | Ensure VPC Flow logs is enabled for every subnet in VPC Network                      |
| [enable_network_private_google_access](../../samples/network_enable_private_google_access.yaml)    | security               | Ensure Private Google Access is enabled for all subnetworks in VPC                   |
| [gke_allowed_node_service_account_scope_default](../../samples/gke_allowed_node_sa_scope.yaml)     | security               |                                                                                      |
| [gke_container_optimized_os](../../samples/gke_container_optimized_os.yaml)                        | security               | Ensure Container-Optimized OS (cos) is used for Kubernetes Engine Clusters           |
| [gke_restrict_client_auth_methods](../../samples/gke_restrict_client_auth_methods.yaml)            | security               |                                                                                      |
| [gke_restrict_pod_traffic](../../samples/gke_restrict_pod_traffic.yaml)                            | security               |                                                                                      |
| [prevent-public-ip-cloudsql](../../samples/sql_public_ip.yaml)                                     | security               | Prevents a public IP from being assigned to a Cloud SQL instance.                    |
| [require_bq_table_iam](../../samples/constraints/bigquery_world_readable.yaml)                     | security               |                                                                                      |
| [require_bucket_policy_only](../../samples/constraints/storage_bucket_policy_only.yaml)            | security               |                                                                                      |
| [require_sql_ssl](../../samples/sql_ssl.yaml)                                                      | security               |                                                                                      |
| [restrict-firewall-rule-rdp-world-open](../../samples/restrict_fw_rules_rdp_world_open.yaml)       | security               |                                                                                      |
| [restrict-firewall-rule-ssh-world-open](../../samples/restrict_fw_rules_ssh_world_open.yaml)       | security               |                                                                                      |
| [restrict-firewall-rule-world-open](../../samples/constraints/restrict_fw_rules_world_open.yaml)   | security               |                                                                                      |
| [service_versions](../../samples/appengine_versions.yaml)                                          | operational-efficiency |                                                                                      |

