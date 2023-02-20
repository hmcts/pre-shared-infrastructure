resource "azurerm_virtual_network_peering" "from_hub" {
  provider = azurerm.hub

  name                         = var.PeeringFromHubName
  resource_group_name          = local.hub[local.hub_name].ukSouth.name
  virtual_network_name         = local.hub[local.hub_name].ukSouth.name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
resource "azurerm_virtual_network_peering" "to_hub" {
  name                         = "hub"
  resource_group_name          = data.azurerm_resource_group.rg.name
  virtual_network_name         = data.azurerm_virtual_network.vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

}

# resource "azurerm_virtual_network_peering" "from_hub" {
#   provider = azurerm.hub

#   name                         = var.PeeringFromHubName
#   resource_group_name          = local.hub[local.hub_name].ukSouth.name
#   virtual_network_name         = local.hub[local.hub_name].ukSouth.name
#   remote_virtual_network_id    = data.azurerm_virtual_network.vnet.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }

# resource "azurerm_route_table" "postgres" {
#   name                          = "${var.prefix}-${var.env}-route-table"
#   location                      = var.location
#   resource_group_name           = data.azurerm_resource_group.rg.id
#   disable_bgp_route_propagation = false

#   route {
#     name                   = "default"
#     address_prefix         = "0.0.0.0/0"
#     next_hop_type          = "VirtualAppliance"
#     next_hop_in_ip_address = local.hub[local.hub_name].ukSouth.next_hop_ip
#   }

#   tags = module.tags.common_tags
# }

# resource "azurerm_subnet_route_table_association" "dg_subnet" {
#   subnet_id      = data.azurerm_subnet.datagateway_subnet.id
#   route_table_id = azurerm_route_table.postgres.id
# }