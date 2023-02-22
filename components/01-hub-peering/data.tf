data "azurerm_resource_group" "rg" {
  name = "${var.prefix}-${var.env}"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_virtual_network" "hub" {
  provider            = azurerm.hub
  name                = local.hub[local.hub_name].ukSouth.name
  resource_group_name = local.hub[local.hub_name].ukSouth.name
}