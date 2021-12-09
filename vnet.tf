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
}

output "subnet01_id" {
  value = azurerm_virtual_network.vnet.subnets[0]
}
