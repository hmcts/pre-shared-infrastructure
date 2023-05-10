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
      ukWest = {
        name         = "ukw-hub-nonprodi"
        peering_name = "hubUkW"
        next_hop_ip  = "10.49.72.36"
      }
    }
    sbox = {
      subscription = "ea3a8c1e-af9d-4108-bc86-a7e2d267f49c"
      ukSouth = {
        name         = "hmcts-hub-sbox-int"
        peering_name = "hubUkS"
        next_hop_ip  = "10.10.200.36"
      }
      ukWest = {
        name         = "ukw-hub-sbox-int"
        peering_name = "hubUkW"
        next_hop_ip  = "10.48.200.36"
      }
    }
    prod = {
      subscription = "0978315c-75fe-4ada-9d11-1eb5e0e0b214"
      ukSouth = {
        name         = "hmcts-hub-prod-int"
        peering_name = "hubUkS"
        next_hop_ip  = "10.11.8.36"
      }
      ukWest = {
        name         = "ukw-hub-prod-int"
        peering_name = "hubUkW"
        next_hop_ip  = "10.49.8.36"
      }
    }
  }

  hub_to_env_mapping = {
    sbox    = ["sbox", "ptlsbox"]
    nonprod = ["demo", "dev", "aat", "test", "ithc", "ptl"]
    prod    = ["prod", "stg", "ptl", "dev"]
  }

  regions = [
    "ukSouth",
    "ukWest"
  ]

  hub_name = [for x in keys(local.hub_to_env_mapping) : x if contains(local.hub_to_env_mapping[x], var.env)][0]

}

data "azurerm_virtual_network" "hub" {
  provider = azurerm.hub

  name                = local.hub[local.hub_name].ukSouth.name
  resource_group_name = local.hub[local.hub_name].ukSouth.name
}

resource "azurerm_virtual_network_peering" "to_hub" {
  name                         = "hub"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

}

resource "azurerm_virtual_network_peering" "from_hub" {
  provider = azurerm.hub

  name                         = var.PeeringFromHubName
  resource_group_name          = local.hub[local.hub_name].ukSouth.name
  virtual_network_name         = local.hub[local.hub_name].ukSouth.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
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





# module "vnet_peer_to_hub" {
#   source = "github.com/hmcts/terraform-module-vnet-peering"
#   for_each = toset([for r in local.regions : r if contains(local.hub_to_env_mapping["to_hub"], var.environment)])

#   peerings = {
#     source = {
#       name           = format("%s%s_To_%s", var.project, var.environment, local.hub["to_hub"][each.key].name)
#       vnet           = azurerm_virtual_network.virtual_network.name
#       resource_group = azurerm_virtual_network.virtual_network.resource_group_name
#     }
#     target = {
#       name           = format("%s_To_%s%s", local.hub["to_hub"][each.key].name, var.project, var.environment)
#       vnet           = local.hub["to_hub"][each.key].name
#       resource_group = local.hub["to_hub"][each.key].name
#     }
#   }

#   providers = {
#     azurerm.initiator = azurerm.to_hub
#     azurerm.target    = azurerm.hub
#   }
# } 


# module "vnet_peer_from_hub" {
#   source = "github.com/hmcts/terraform-module-vnet-peering"
#   for_each = toset([for r in local.regions : r if contains(local.hub_to_env_mapping["from_hub"], var.environment)])

#   peerings = {
#     source = {
#       name           = format("%s%s_To_%s", var.project, var.environment, local.hub["from_hub"][each.key].name)
#       vnet           = azurerm_virtual_network.virtual_network.name
#       resource_group = azurerm_virtual_network.virtual_network.resource_group_name
#     }
#     target = {
#       name           = format("%s_To_%s%s", local.hub["from_hub"][each.key].name, var.project, var.environment)
#       vnet           = local.hub["to_hub"][each.key].name
#       resource_group = local.hub["to_hub"][each.key].name
#     }
#   }

#   providers = {
#     azurerm.initiator = azurerm.from_hub
#     azurerm.target    = azurerm.hub
#   }
# } 
