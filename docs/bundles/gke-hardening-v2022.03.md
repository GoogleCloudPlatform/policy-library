# gke-hardening-v2022.03

This bundle can be installed via kpt:

```
export BUNDLE=gke-hardening-v2022.03
kpt pkg get https://github.com/GoogleCloudPlatform/policy-library.git ./policy-library
kpt fn source policy-library/samples/ | \
  kpt fn eval - --image gcr.io/config-validator/get-policy-bundle:latest -- bundle=$BUNDLE | \
  kpt fn sink policy-library/policies/constraints/
```

## Constraints

| Constraint                                                                                         | Control                           | Description                                                                               |
| -------------------------------------------------------------------------------------------------- | --------------------------------- | ----------------------------------------------------------------------------------------- |
| [allow_only_private_cluster](../../samples/gke_allow_only_private_cluster.yaml)                    | PRIVATE_CLUSTERS_ONLY             | Verifies all GKE clusters are Private Clusters.                                           |
| [disable_gke_dashboard](../../samples/gke_dashboard_disable.yaml)                                  | DISABLED_GKE_DASHBOARD            | Ensure Kubernetes web UI / Dashboard is disabled                                          |
| [disable_gke_legacy_abac](../../samples/gke_legacy_abac.yaml)                                      | DISABLED_LEGACY_AUTHORIZATION     | Ensure Legacy Authorization is set to Disabled on Kubernetes Engine Clusters              |
| [enable_alias_ip_ranges](../../samples/gke_enable_alias_ip_ranges.yaml)                            | ENABLE_IP_ALIAS                   | Ensure Kubernetes Cluster is created with Alias IP ranges enabled                         |
| [enable_auto_upgrade](../../samples/gke_node_pool_auto_upgrade.yaml)                               | ENABLED_NODE_AUTO_UPGRADE         | Ensure Automatic node upgrades is enabled on Kubernetes Engine Clusters nodes             |
| [enable_gke_master_authorized_networks](../../samples/gke_master_authorized_networks_enabled.yaml) | ENABLED_MASTER_AUTHORIZED_NETWORK | Ensure Master authorized networks is set to Enabled on Kubernetes Engine Clusters         |
| [enable_gke_shielded_nodes](../../samples/gke_enable_shielded_nodes.yaml)                          | ENABLE_SHIELDED_GKE_NODES         | Checks that GKE is using Shielded nodes (secure boot).                                    |
| [enable_gke_workload_identity](../../samples/gke_enable_workload_identity.yaml)                    | ENABLE_WORKLOAD_IDENTITY          | Ensure Workload Identity is enabled on a GKE cluster                                      |
| [gke_enable_private_endpoint](../../samples/gke_enable_private_endpoint.yaml)                      | ENABLE_PRIVATE_ENDPOINT           | Enable a private endpoint for the cluster to be accessible from an internal network only. |

