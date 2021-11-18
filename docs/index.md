# Config Validator Policy Library

Constraint templates specify the logic to be used by constraints.
This repository contains pre-defined constraint templates that you can implement or modify for your own needs.

## Creating a constraint template
You can create and implement your own custom constraint templates.
For instructions on how to write constraint templates, see [How to write your own constraint templates](./constraint_template_authoring.md).

## Policy Bundles
In addition to browsing all [Available Templates](#available-templates) and [Sample Constraints](#sample-constraints),
you can explore these policy bundles:

- [CFT Scorecard](./bundles/scorecard-v1.md)
- [CIS v1.0](./bundles/cis-v1.0.md)
- [CIS v1.1](./bundles/cis-v1.1.md)
- [Forseti Security](./bundles/forseti-security.md)
- [GKE Hardening](./bundles/gke-hardening-v2019.11.11.md)
- [Healthcare Baseline](./bundles/healthcare-baseline-v1.md)


## Available Templates

| Template                                                                                                                                     | Samples |
| -------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| [GCPAllowedResourceTypesConstraintV1](../policies/templates/legacy/gcp_allowed_resource_types_v1.yaml)                                       |         |
| [GCPAllowedResourceTypesConstraintV2](../policies/templates/gcp_allowed_resource_types.yaml)                                                 |         |
| [GCPAlwaysViolatesConstraintV1](../policies/templates/gcp_always_violates_v1.yaml)                                                           |         |
| [GCPAppEngineServiceVersionsConstraintV1](../policies/templates/gcp_app_service_versions.yaml)                                               |         |
| [GCPAppengineLocationConstraintV1](../policies/templates/gcp_appengine_location_v1.yaml)                                                     |         |
| [GCPBigQueryCMEKEncryptionConstraintV1](../policies/templates/gcp_bigquery_cmek_encryption_v1.yaml)                                          |         |
| [GCPBigQueryDatasetLocationConstraintV1](../policies/templates/gcp_bq_dataset_location_v1.yaml)                                              |         |
| [GCPBigQueryDatasetWorldReadableConstraintV1](../policies/templates/gcp_bigquery_dataset_world_readable_v1.yaml)                             |         |
| [GCPBigQueryTableRetentionConstraintV1](../policies/templates/gcp_bigquery_table_retention_v1.yaml)                                          |         |
| [GCPCMEKRotationConstraintV1](../policies/templates/gcp_cmek_rotation_v1.yaml)                                                               |         |
| [GCPCMEKSettingsConstraintV1](../policies/templates/gcp_cmek_settings_v1.yaml)                                                               |         |
| [GCPComputeAllowedNetworksConstraintV2](../policies/templates/gcp_compute_allowed_networks.yaml)                                             |         |
| [GCPComputeDiskResourcePoliciesConstraintV1](../policies/templates/gcp_compute_disk_resource_policies_v1.yaml)                               |         |
| [GCPComputeExternalIpAccessConstraintV1](../policies/templates/legacy/gcp_compute_external_ip_access_v1.yaml)                                |         |
| [GCPComputeExternalIpAccessConstraintV2](../policies/templates/gcp_compute_external_ip_address.yaml)                                         |         |
| [GCPComputeIpForwardConstraintV1](../policies/templates/legacy/gcp_compute_ip_forward_v1.yaml)                                               |         |
| [GCPComputeIpForwardConstraintV2](../policies/templates/gcp_compute_ip_forward.yaml)                                                         |         |
| [GCPComputeNetworkInterfaceWhitelistConstraintV1](../policies/templates/legacy/gcp_compute_network_interface_whitelist_v1.yaml)              |         |
| [GCPComputeZoneConstraintV1](../policies/templates/gcp_compute_zone_v1.yaml)                                                                 |         |
| [GCPDNSSECConstraintV1](../policies/templates/gcp_dnssec_v1.yaml)                                                                            |         |
| [GCPDNSSECPreventRSASHA1ConstraintV1](../policies/templates/gcp_dnssec_prevent_rsasha1_v1.yaml)                                              |         |
| [GCPDataprocLocationConstraintV1](../policies/templates/gcp_dataproc_location_v1.yaml)                                                       |         |
| [GCPEnforceLabelConstraintV1](../policies/templates/gcp_enforce_labels_v1.yaml)                                                              |         |
| [GCPEnforceNamingConstraintV1](../policies/templates/gcp_enforce_naming_v1.yaml)                                                             |         |
| [GCPExternalIpAccessConstraintV1](../policies/templates/legacy/gcp_external_ip_access_v1.yaml)                                               |         |
| [GCPGKEAllowedNodeSAConstraintV1](../policies/templates/gcp_gke_allowed_node_sa_v1.yaml)                                                     |         |
| [GCPGKEContainerOptimizedOSConstraintV1](../policies/templates/gcp_gke_container_optimized_os.yaml)                                          |         |
| [GCPGKEDashboardConstraintV1](../policies/templates/gcp_gke_dashboard_v1.yaml)                                                               |         |
| [GCPGKEDisableDefaultServiceAccountConstraintV1](../policies/templates/gcp_gke_disable_default_service_account_v1.yaml)                      |         |
| [GCPGKEDisableLegacyEndpointsConstraintV1](../policies/templates/gcp_gke_disable_legacy_endpoints_v1.yaml)                                   |         |
| [GCPGKEEnableAliasIPRangesConstraintV1](../policies/templates/gcp_gke_enable_alias_ip_ranges.yaml)                                           |         |
| [GCPGKEEnablePrivateEndpointConstraintV1](../policies/templates/gcp_gke_enable_private_endpoint.yaml)                                        |         |
| [GCPGKEEnableShieldedNodesConstraintV1](../policies/templates/gcp_gke_enable_shielded_nodes_v1.yaml)                                         |         |
| [GCPGKEEnableStackdriverKubernetesEngineMonitoringV1](../policies/templates/gcp_gke_enable_stackdriver_kubernetes_engine_monitoring_v1.yaml) |         |
| [GCPGKEEnableStackdriverLoggingConstraintV1](../policies/templates/gcp_gke_enable_stackdriver_logging_v1.yaml)                               |         |
| [GCPGKEEnableStackdriverMonitoringConstraintV1](../policies/templates/gcp_gke_enable_stackdriver_monitoring_v1.yaml)                         |         |
| [GCPGKEEnableWorkloadIdentityConstraintV1](../policies/templates/gcp_gke_enable_workload_identity_v1.yaml)                                   |         |
| [GCPGKELegacyAbacConstraintV1](../policies/templates/gcp_gke_legacy_abac_v1.yaml)                                                            |         |
| [GCPGKEMasterAuthorizedNetworksEnabledConstraintV1](../policies/templates/gcp_gke_master_authorized_networks_enabled_v1.yaml)                |         |
| [GCPGKENodeAutoRepairConstraintV1](../policies/templates/gcp_gke_node_auto_repair_v1.yaml)                                                   |         |
| [GCPGKENodeAutoUpgradeConstraintV1](../policies/templates/gcp_gke_node_auto_upgrade_v1.yaml)                                                 |         |
| [GCPGKEPrivateClusterConstraintV1](../policies/templates/gcp_gke_private_cluster_v1.yaml)                                                    |         |
| [GCPGKERestrictClientAuthenticationMethodsConstraintV1](../policies/templates/gcp_gke_restrict_client_auth_methods_v1.yaml)                  |         |
| [GCPGKERestrictPodTrafficConstraintV1](../policies/templates/gcp_gke_restrict_pod_traffic_v1.yaml)                                           |         |
| [GCPGLBExternalIpAccessConstraintV1](../policies/templates/gcp_glb_external_ip_access_constraint_v1.yaml)                                    |         |
| [GCPIAMAllowedBindingsConstraintV1](../policies/templates/legacy/gcp_iam_allowed_bindings_v1.yaml)                                           |         |
| [GCPIAMAllowedBindingsConstraintV2](../policies/templates/legacy/gcp_iam_allowed_bindings_v2.yaml)                                           |         |
| [GCPIAMAllowedBindingsConstraintV3](../policies/templates/gcp_iam_allowed_bindings.yaml)                                                     |         |
| [GCPIAMAllowedPolicyMemberDomainsConstraintV1](../policies/templates/legacy/gcp_iam_allowed_policy_member_domains_v1.yaml)                   |         |
| [GCPIAMAllowedPolicyMemberDomainsConstraintV2](../policies/templates/gcp_iam_allowed_policy_member_domains.yaml)                             |         |
| [GCPIAMAuditLogConstraintV1](../policies/templates/gcp_iam_audit_log.yaml)                                                                   |         |
| [GCPIAMCustomRolePermissionsConstraintV1](../policies/templates/gcp_iam_custom_role_permissions_v1.yaml)                                     |         |
| [GCPIAMRequiredBindingsConstraintV1](../policies/templates/gcp_iam_required_bindings_v1.yaml)                                                |         |
| [GCPIAMRestrictServiceAccountCreationConstraintV1](../policies/templates/gcp_iam_restrict_service_account_creation_v1.yaml)                  |         |
| [GCPIAMRestrictServiceAccountKeyAgeConstraintV1](../policies/templates/gcp_iam_restrict_service_account_key_age_v1.yaml)                     |         |
| [GCPIAMRestrictServiceAccountKeyTypeConstraintV1](../policies/templates/gcp_iam_restrict_service_account_key_type_v1.yaml)                   |         |
| [GCPLBAllowedForwardingRulesConstraintV2](../policies/templates/gcp_lb_forwarding_rules.yaml)                                                |         |
| [GCPNetworkEnableFirewallLogsConstraintV1](../policies/templates/gcp_network_enable_firewall_logs_v1.yaml)                                   |         |
| [GCPNetworkEnableFlowLogsConstraintV1](../policies/templates/gcp_network_enable_flow_logs_v1.yaml)                                           |         |
| [GCPNetworkEnablePrivateGoogleAccessConstraintV1](../policies/templates/gcp_network_enable_private_google_access_v1.yaml)                    |         |
| [GCPNetworkRestrictDefaultV1](../policies/templates/gcp_network_restrict_default_v1.yaml)                                                    |         |
| [GCPNetworkRoutingConstraintV1](../policies/templates/gcp_network_routing_v1.yaml)                                                           |         |
| [GCPResourceValuePatternConstraintV1](../policies/templates/gcp_resource_value_pattern_v1.yaml)                                              |         |
| [GCPRestrictedFirewallRulesConstraintV1](../policies/templates/gcp_restricted_firewall_rules_v1.yaml)                                        |         |
| [GCPSQLAllowedAuthorizedNetworksConstraintV1](../policies/templates/gcp_sql_allowed_authorized_networks_v1.yaml)                             |         |
| [GCPSQLBackupConstraintV1](../policies/templates/gcp_sql_backup_v1.yaml)                                                                     |         |
| [GCPSQLInstanceTypeConstraintV1](../policies/templates/gcp_sql_instance_type_v1.yaml)                                                        |         |
| [GCPSQLLocationConstraintV1](../policies/templates/gcp_sql_location_v1.yaml)                                                                 |         |
| [GCPSQLMaintenanceWindowConstraintV1](../policies/templates/gcp_sql_maintenance_window_v1.yaml)                                              |         |
| [GCPSQLPublicIpConstraintV1](../policies/templates/gcp_sql_public_ip_v1.yaml)                                                                |         |
| [GCPSQLSSLConstraintV1](../policies/templates/gcp_sql_ssl_v1.yaml)                                                                           |         |
| [GCPSQLWorldReadableConstraintV1](../policies/templates/gcp_sql_world_readable_v1.yaml)                                                      |         |
| [GCPServiceUsageConstraintV1](../policies/templates/gcp_serviceusage_allowed_services_v1.yaml)                                               |         |
| [GCPSpannerLocationConstraintV1](../policies/templates/gcp_spanner_location_v1.yaml)                                                         |         |
| [GCPStorageBucketPolicyOnlyConstraintV1](../policies/templates/gcp_storage_bucket_policy_only_v1.yaml)                                       |         |
| [GCPStorageBucketRetentionConstraintV1](../policies/templates/gcp_storage_bucket_retention_v1.yaml)                                          |         |
| [GCPStorageBucketWorldReadableConstraintV1](../policies/templates/gcp_storage_bucket_world_readable_v1.yaml)                                 |         |
| [GCPStorageCMEKEncryptionConstraintV1](../policies/templates/gcp_storage_cmek_encryption_v1.yaml)                                            |         |
| [GCPStorageLocationConstraintV1](../policies/templates/gcp_storage_location_v1.yaml)                                                         |         |
| [GCPStorageLoggingConstraintV1](../policies/templates/gcp_storage_logging_v1.yaml)                                                           |         |
| [GCPVPCSCAllowedRegionsConstraintV2](../policies/templates/gcp_vpc_sc_allowed_regions.yaml)                                                  |         |
| [GCPVPCSCEnsureAccessLevelsConstraintV1](../policies/templates/gcp_vpc_sc_ensure_access_levels_v1.yaml)                                      |         |
| [GCPVPCSCEnsureProjectConstraintV1](../policies/templates/gcp_vpc_sc_ensure_project_v1.yaml)                                                 |         |
| [GCPVPCSCEnsureServicesConstraintV1](../policies/templates/gcp_vpc_sc_ensure_services_v1.yaml)                                               |         |
| [GCPVPCSCIPRangeConstraintV1](../policies/templates/gcp_vpc_sc_ip_range_v1.yaml)                                                             |         |
| [GCPVPCSCProjectPerimeterConstraintV1](../policies/templates/legacy/gcp_vpc_sc_project_perimeter_v1.yaml)                                    |         |
| [GCPVPCSCProjectPerimeterConstraintV2](../policies/templates/legacy/gcp_vpc_sc_project_perimeter_v2.yaml)                                    |         |
| [GCPVPCSCProjectPerimeterConstraintV3](../policies/templates/gcp_vpc_sc_project_perimeter.yaml)                                              |         |
| [GCPVPCSCWhitelistRegionsConstraintV1](../policies/templates/legacy/gcp_vpc_sc_whitelist_regions_v1.yaml)                                    |         |
| [GKEClusterLocationConstraintV1](../policies/templates/legacy/gcp_gke_cluster_location_v1.yaml)                                              |         |
| [GKEClusterLocationConstraintV2](../policies/templates/legacy/gcp_gke_cluster_location_v2.yaml)                                              |         |
| [GKEClusterVersionConstraintV1](../policies/templates/gcp_gke_cluster_version_v1.yaml)                                                       |         |
## Sample Constraints

    The repo also contains a number of sample constraints:

    | Sample | Template | Description |
| ------ | -------- | ----------- |