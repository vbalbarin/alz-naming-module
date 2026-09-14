locals {
  environment       = lower(trimspace(var.environment))
  environment_infix = lookup(var.environment_infixes, local.environment, contains(var.environments_without_infix, local.environment) ? "" : "-${local.environment}")
  regional_suffix   = "${local.environment_infix}-${var.location}"

  generated_names = {
    primary_management_resource_group_name                 = "rg-management${local.regional_suffix}"
    primary_amba_resource_group_name                       = "rg-amba${local.regional_suffix}"
    primary_connectivity_hub_resource_group_name           = "rg-hub${local.regional_suffix}"
    dns_resource_group_name                                = "rg-hub-dns${local.regional_suffix}"
    primary_log_analytics_workspace_name                   = "law-management${local.regional_suffix}"
    primary_automation_account_name                        = "aa-management${local.regional_suffix}"
    primary_ama_user_assigned_managed_identity_name        = "uami-management-ama${local.regional_suffix}"
    primary_amba_user_assigned_managed_identity_name       = "uami-amba${local.regional_suffix}"
    dcr_change_tracking_name                               = "dcr-change-tracking"
    dcr_defender_sql_name                                  = "dcr-defender-sql"
    dcr_vm_insights_name                                   = "dcr-vm-insights"
    primary_virtual_network_name                           = "vnet-hub${local.regional_suffix}"
    primary_firewall_name                                  = "azfw-hub${local.regional_suffix}"
    primary_firewall_public_ip_name                        = "pip-azfw-hub${local.regional_suffix}"
    primary_firewall_mgmt_public_ip_name                   = "pip-azfw-hub-mgmt${local.regional_suffix}"
    primary_firewall_policy_name                           = "afp-hub${local.regional_suffix}"
    primary_route_table_firewall_name                      = "rt-hub-fw${local.regional_suffix}"
    primary_route_table_user_subnets_name                  = "rt-hub-std${local.regional_suffix}"
    primary_gateway_subnet_route_table_name                = "rt-gw-hub${local.regional_suffix}"
    primary_gateway_subnet_route_table_firewall_route_name = "rt-hub-gateway-fw${local.regional_suffix}"
    primary_express_route_resource_group_name              = "rg-er${local.regional_suffix}"
    primary_virtual_network_gateway_express_route_name     = "vgw-hub-er${local.regional_suffix}"
    primary_express_route_circuit_name                     = "erc-hub${local.regional_suffix}"
    primary_express_route_connection_name                  = "cn-er-vng${local.regional_suffix}"
    primary_virtual_network_gateway_vpn_name               = "vgw-hub-vpn${local.regional_suffix}"
    primary_virtual_network_gateway_vpn_public_ip_name_1   = "pip-vgw-hub-vpn${local.regional_suffix}-001"
    primary_virtual_network_gateway_vpn_public_ip_name_2   = "pip-vgw-hub-vpn${local.regional_suffix}-002"
    primary_auto_registration_zone_name                    = "${var.location}.azure.local"
    primary_private_dns_resolver_name                      = "pdr-hub-dns${local.regional_suffix}"
    primary_private_dns_resolver_inbound_subnet_name       = "InboundEndpointSubnet"
    primary_private_dns_resolver_outbound_subnet_name      = "OutboundEndpointSubnet"
    primary_bastion_host_name                              = "bas-hub${local.regional_suffix}"
    primary_bastion_host_public_ip_name                    = "pip-bastion-hub${local.regional_suffix}"
    primary_ddos_protection_plan_name                      = "ddos-plan${local.regional_suffix}"
  }

  names = merge(local.generated_names, var.name_overrides)

  management_resource_group_id = try(
    "/subscriptions/${var.subscription_ids["management"]}/resourceGroups/${local.names.primary_management_resource_group_name}",
    null
  )
  connectivity_resource_group_id = try(
    "/subscriptions/${var.subscription_ids["connectivity"]}/resourceGroups/${local.names.primary_connectivity_hub_resource_group_name}",
    null
  )

  resource_group_identifiers = {
    primary_management_resource_group_id    = local.management_resource_group_id
    primary_amba_resource_group_id          = try("/subscriptions/${var.subscription_ids["management"]}/resourceGroups/${local.names.primary_amba_resource_group_name}", null)
    primary_hub_resource_group_id           = local.connectivity_resource_group_id
    dns_resource_group_id                   = try("/subscriptions/${var.subscription_ids["connectivity"]}/resourceGroups/${local.names.dns_resource_group_name}", null)
    primary_express_route_resource_group_id = try("/subscriptions/${var.subscription_ids["connectivity"]}/resourceGroups/${local.names.primary_express_route_resource_group_name}", null)
  }

  resource_identifiers = {
    primary_log_analytics_workspace_id                  = local.management_resource_group_id == null ? null : "${local.management_resource_group_id}/providers/Microsoft.OperationalInsights/workspaces/${local.names.primary_log_analytics_workspace_name}"
    primary_ama_change_tracking_data_collection_rule_id = local.management_resource_group_id == null ? null : "${local.management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/${local.names.dcr_change_tracking_name}"
    primary_ama_mdfc_sql_data_collection_rule_id        = local.management_resource_group_id == null ? null : "${local.management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/${local.names.dcr_defender_sql_name}"
    primary_ama_vm_insights_data_collection_rule_id     = local.management_resource_group_id == null ? null : "${local.management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/${local.names.dcr_vm_insights_name}"
    primary_ama_user_assigned_managed_identity_id       = local.management_resource_group_id == null ? null : "${local.management_resource_group_id}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${local.names.primary_ama_user_assigned_managed_identity_name}"
    primary_express_route_circuit_id                    = local.resource_group_identifiers.primary_express_route_resource_group_id == null ? null : "${local.resource_group_identifiers.primary_express_route_resource_group_id}/providers/Microsoft.Network/expressRouteCircuits/${local.names.primary_express_route_circuit_name}"
    primary_ddos_protection_plan_id                     = local.connectivity_resource_group_id == null ? null : "${local.connectivity_resource_group_id}/providers/Microsoft.Network/ddosProtectionPlans/${local.names.primary_ddos_protection_plan_name}"
  }
}