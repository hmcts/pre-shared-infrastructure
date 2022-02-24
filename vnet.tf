

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.product}-vnet01-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_address_space]

  subnet {
    name           = "${var.product}-videoeditvm-snet-${var.env}"
    address_prefix = var.video_edit_vm_snet_address
  }

  subnet {
    name           = "${var.product}-privatelink-snet-${var.env}"
    address_prefix = var.privatelink_snet_address
  }
  subnet {
    name           = "AzureBastionSubnet" 
    address_prefix = var.bastion_snet_address
  }

   subnet {
    name           = "${var.product}-data-gateway-snet-${var.env}"
    address_prefix = var.data_gateway_snet_address
  }

 tags = var.common_tags
}

//resource "azurerm_subnet" "ams_subnet" {
//  name                 = "${var.product}-snet01-${var.env}"
//  resource_group_name  = azurerm_resource_group.rg.name
//  virtual_network_name = azurerm_virtual_network.vnet.name
//  address_prefixes     = var.video_edit_vm_snet_address
//  service_endpoints    = ["Microsoft.Storage"]
//}
//
//resource "azurerm_subnet" "vm_subnet" {
//  name                 = "${var.product}-snet02-${var.env}"
//  resource_group_name  = azurerm_resource_group.rg.name
//  virtual_network_name = azurerm_virtual_network.vnet.name
//  address_prefixes     = var.privatelink_snet_address
//  service_endpoints    = ["Microsoft.Storage"]
//}



output "subnet_ids" {
   value = values(azurerm_virtual_network.vnet.subnet)[*].id
}