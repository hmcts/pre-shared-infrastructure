resource "azurerm_virtual_network" "vnet" {
  name                = "${var.product}-vnet01-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_address_space]

  subnet {
    name           = "${var.product}-snet01-${var.env}"
    address_prefix = var.snet01_address_prefix
  }

  subnet {
    name           = "${var.product}-snet02-${var.env}"
    address_prefix = var.snet02_address_prefix
  }

  common_tags = var.common_tags
}

//resource "azurerm_subnet" "ams_subnet" {
//  name                 = "${var.product}-snet01-${var.env}"
//  resource_group_name  = azurerm_resource_group.rg.name
//  virtual_network_name = azurerm_virtual_network.vnet.name
//  address_prefixes     = var.snet01_address_prefix
//  service_endpoints    = ["Microsoft.Storage"]
//}
//
//resource "azurerm_subnet" "vm_subnet" {
//  name                 = "${var.product}-snet02-${var.env}"
//  resource_group_name  = azurerm_resource_group.rg.name
//  virtual_network_name = azurerm_virtual_network.vnet.name
//  address_prefixes     = var.snet02_address_prefix
//  service_endpoints    = ["Microsoft.Storage"]
//}


