# gke-hardening-v2019.11.11

## Constraints

| Constraint                                                                                         | Control                           | Description                                                                       |
| -------------------------------------------------------------------------------------------------- | --------------------------------- | --------------------------------------------------------------------------------- |
| [disable_gke_dashboard](../../samples/gke_dashboard_disable.yaml)                                  | DISABLED_GKE_DASHBOARD            | Ensure Kubernetes web UI / Dashboard is disabled                                  |
| [enable_gke_master_authorized_networks](../../samples/gke_master_authorized_networks_enabled.yaml) | ENABLED_MASTER_AUTHORIZED_NETWORK | Ensure Master authorized networks is set to Enabled on Kubernetes Engine Clusters |
| [enable_auto_upgrade](../../samples/gke_node_pool_auto_upgrade.yaml)                               | ENABLED_NODE_AUTO_UPGRADE         | Ensure Automatic node upgrades is enabled on Kubernetes Engine Clusters nodes     |

