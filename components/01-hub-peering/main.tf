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
