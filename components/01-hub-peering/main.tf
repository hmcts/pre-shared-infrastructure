data "azurerm_virtual_network" "hub" {
  provider = azurerm.hub

  name                = local.hub[local.hub_name].ukSouth.name
  resource_group_name = local.hub[local.hub_name].ukSouth.name
}

data "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet-${var.env}"
  resource_group_name = local.resource_group_name
}

resource "azurerm_virtual_network_peering" "to_hub" {
  name                         = "hub"
  resource_group_name          = local.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

}

resource "azurerm_virtual_network_peering" "from_hub" {
  provider = azurerm.hub

  name                         = var.PeeringFromHubName
  resource_group_name          = local.hub[local.hub_name].ukSouth.name
  virtual_network_name         = local.hub[local.hub_name].ukSouth.name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_route_table" "postgres" {
  name                          = "${var.prefix}-${var.env}-route-table"
  location                      = var.location
  resource_group_name           = local.resource_group_name
  disable_bgp_route_propagation = false

  route {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = local.hub[local.hub_name].ukSouth.next_hop_ip
  }

  tags = module.tags.common_tags
}

resource "azurerm_subnet_route_table_association" "dg_subnet" {
  subnet_id      = azurerm_subnet.datagateway_subnet.id
  route_table_id = azurerm_route_table.postgres.id
}