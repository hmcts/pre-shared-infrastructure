resource "azurerm_virtual_network" "vnet" {
  name                = "${var.product}-vnet01-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_address_space]
  # ddos_protection_plan {
  #   id          = azurerm_network_ddos_protection_plan.pre-ddos.id
  #   enable      = true
  # }

  tags = var.common_tags
}

#------------------------------------------------------###################
#SUBNET with ENDPOINT
#------------------------------------------------------###################
resource "azurerm_subnet" "datagateway_subnet" {
  name                 = "${var.product}-datagateway-snet-${var.env}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.data_gateway_snet_address]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault"]
}

resource "azurerm_subnet" "videoeditvm_subnet" {
  name                 = "${var.product}-videoeditvm-snet-${var.env}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.video_edit_vm_snet_address]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault"]
}


resource "azurerm_subnet" "endpoint_subnet" {
  name                 = "${var.product}-privatendpt-snet-${var.env}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.privatendpt_snet_address]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault"]
  # enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "AzureBastionSubnet_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.bastion_snet_address]
}

###########################
#
# Hub connection
#
###########################

locals {
  hub = {
    nonprod = {
      subscription = "fb084706-583f-4c9a-bdab-949aac66ba5c"
      ukSouth = {
        name         = "hmcts-hub-nonprodi"
        peering_name = "hubUkS"
        next_hop_ip  = "10.11.72.36"
      }
    }
    sbox = {
      subscription = "ea3a8c1e-af9d-4108-bc86-a7e2d267f49c"
      ukSouth = {
        name         = "hmcts-hub-sbox-int"
        peering_name = "hubUkS"
        next_hop_ip  = "10.10.200.36"
      }
    }
    prod = {
      subscription = "0978315c-75fe-4ada-9d11-1eb5e0e0b214"
      ukSouth = {
        name         = "hmcts-hub-prod-int"
        peering_name = "hubUkS"
        next_hop_ip  = "10.11.8.36"
    }
  }

  hub_to_env_mapping = {
    sbox    = ["sbox", "ptlsbox"]
    nonprod = ["demo", "dev", "aat", "test", "ithc", "ptl"]
    prod    = ["prod", "stg", "ptl", "dev"]
  }

  regions = [
    "ukSouth"
  ]

  hub_name = [for x in keys(local.hub_to_env_mapping) : x if contains(local.hub_to_env_mapping[x], var.env)][0]

}

data "azurerm_virtual_network" "hub" {
  provider = azurerm.hub

  name                = local.hub[local.hub_name].ukSouth.name
  resource_group_name = local.hub[local.hub_name].ukSouth.name
}

resource "azurerm_route_table" "postgres" {
  name                          = "${var.product}-${var.env}-route-table"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false

  route {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = local.hub[local.hub_name].ukSouth.next_hop_ip
  }

  tags = var.common_tags
}

resource "azurerm_subnet_route_table_association" "dg_subnet" {
  subnet_id      = azurerm_subnet.datagateway_subnet.id
  route_table_id = azurerm_route_table.postgres.id
}

module "vnet_peer_to_hub" {
  source = "git@github.com:hmcts/terraform-module-vnet-peering.git?ref=master"
  peerings = {
    source = {
      name           = "hub"
      vnet           = azurerm_virtual_network.vnet.name
      resource_group = azurerm_virtual_network.vnet.resource_group_name
    }
    target = {
      name           = var.PeeringFromHubName
      vnet           = local.hub[local.hub_name].ukSouth.name
      resource_group = local.hub[local.hub_name].ukSouth.name
    }
  }

  providers = {
    azurerm.initiator = azurerm
    azurerm.target    = azurerm.hub
  }
}

#vnet logs
resource "azurerm_monitor_diagnostic_setting" "vnet" {

  name                       = azurerm_virtual_network.vnet.name
  target_resource_id         = azurerm_virtual_network.vnet.id
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  enabled_log {
    category = "VMProtectionAlerts"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
}
