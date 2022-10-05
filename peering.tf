// HUB

module "vnet_peer_hub_prod" {
  source = "./modules/vnet_peering/"

  for_each = toset([for r in local.regions : r if contains(local.hubs_to_peer[var.environment], "prod")])

  initiator_peer_name = format("%s%s_To_%s",
    var.project,
    var.environment,
    local.hub["prod"][each.key].name
  )

  target_peer_name = format("%s_To_%s%s",
    local.hub["prod"][each.key].name,
    var.project,
    var.environment
  )

  initiator_vnet                = azurerm_virtual_network.vnet.name
  initiator_vnet_resource_group = azurerm_virtual_network.vnet.resource_group_name
  initiator_vnet_subscription   = var.subscription_id

  target_vnet                = local.hub["prod"][each.key].name
  target_vnet_resource_group = local.hub["prod"][each.key].name
  target_vnet_subscription   = local.hub["prod"].subscription

  providers = {
    azurerm           = azurerm
    azurerm.initiator = azurerm
    azurerm.target    = azurerm.hub-prod
  }
}

module "vnet_peer_hub_nonprod" {
  source = "./modules/vnet_peering/"

  for_each = toset([for r in local.regions : r if contains(local.hubs_to_peer[var.environment], "nonprod")])

  initiator_peer_name = format("%s%s_To_%s",
    var.project,
    var.environment,
    local.hub["nonprod"][each.key].name
  )

  target_peer_name = format("%s_To_%s%s",
    local.hub["nonprod"][each.key].name,
    var.project,
    var.environment
  )

  initiator_vnet                = azurerm_virtual_network.vnet.name
  initiator_vnet_resource_group = azurerm_virtual_network.vnet.resource_group_name
  initiator_vnet_subscription   = var.subscription_id

  target_vnet                = local.hub["nonprod"][each.key].name
  target_vnet_resource_group = local.hub["nonprod"][each.key].name
  target_vnet_subscription   = local.hub["nonprod"].subscription

  providers = {
    azurerm           = azurerm
    azurerm.initiator = azurerm
    azurerm.target    = azurerm.hub-nonprod
  }
}

module "vnet_peer_hub_sbox" {
  source = "./modules/vnet_peering/"

  for_each = toset([for r in local.regions : r if contains(local.hubs_to_peer[var.environment], "sbox")])

  initiator_peer_name = format("%s%s_To_%s",
    var.project,
    var.environment,
    local.hub["sbox"][each.key].name
  )

  target_peer_name = format("%s_To_%s%s",
    local.hub["sbox"][each.key].name,
    var.project,
    var.environment
  )

  initiator_vnet                = azurerm_virtual_network.vnet.name
  initiator_vnet_resource_group = azurerm_virtual_network.vnet.resource_group_name
  initiator_vnet_subscription   = var.subscription_id

  target_vnet                = local.hub["sbox"][each.key].name
  target_vnet_resource_group = local.hub["sbox"][each.key].name
  target_vnet_subscription   = local.hub["sbox"].subscription

  providers = {
    azurerm           = azurerm
    azurerm.initiator = azurerm
    azurerm.target    = azurerm.hub-sbox
  }
}

// VPN

module "vnet_peer_vpn" {
  source = "./modules/vnet_peering/"

  initiator_peer_name = "vpn"

  target_peer_name = format("%s%s",
    var.project,
    var.environment
  )

  initiator_vnet                = azurerm_virtual_network.vnet.name
  initiator_vnet_resource_group = azurerm_virtual_network.vnet.resource_group_name
  initiator_vnet_subscription   = var.subscription_id

  target_vnet                = "core-infra-vnet-mgmt"
  target_vnet_resource_group = "rg-mgmt"
  target_vnet_subscription   = "ed302caf-ec27-4c64-a05e-85731c3ce90e"

  providers = {
    azurerm           = azurerm
    azurerm.initiator = azurerm
    azurerm.target    = azurerm.vpn
  }
}