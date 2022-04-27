resource "azurerm_virtual_network" "vnet" {
  name                = "${var.product}-vnet01-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_address_space]

  # subnet {
  #   name                  = "${var.product}-videoeditvm-snet-${var.env}"
  #   address_prefix        = var.video_edit_vm_snet_address
  # }

  # subnet {
  #   name           = "${var.product}-privatendpt-snet-${var.env}"
  #   address_prefix = var.privatendpt_snet_address
  #   service_endpoints     = ["Microsoft.Storage"]
  #   # enforce_private_link_endpoint_network_policies = false
  # // enforce_private_link_service_network_policies = false
  # }
  # subnet {
  #   name           = "AzureBastionSubnet" 
  #   address_prefix = var.bastion_snet_address
  # }

  #  subnet {
  #   name           = "${var.product}-datagateway-snet-${var.env}"
  #   address_prefix = var.data_gateway_snet_address
  # }

 tags = var.common_tags
}

//resource "azurerm_subnet" "sa_subnet" {
//  name                 = "${var.product}-snet01-${var.env}"
//  resource_group_name  = azurerm_resource_group.rg.name
//  virtual_network_name = azurerm_virtual_network.vnet.name
//  address_prefixes     = var.video_edit_vm_snet_address
//  service_endpoints    = ["Microsoft.Storage"]
//}
//


#------------------------------------------------------###################
#SUBNET with ENDPOINT 
#------------------------------------------------------###################
resource "azurerm_subnet" "datagateway_subnet" {
 name                  = "${var.product}-datagateway-snet-${var.env}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.data_gateway_snet_address]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault"]
 }

resource "azurerm_subnet" "videoeditvm_subnet" {
 name                  = "${var.product}-videoeditvm-snet-${var.env}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.video_edit_vm_snet_address]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault"]
}


resource "azurerm_subnet" "endpoint_subnet" {
 name                  = "${var.product}-privatendpt-snet-${var.env}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.privatendpt_snet_address]
  service_endpoints    = ["Microsoft.Storage","Microsoft.KeyVault"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "AzureBastionSubnet_subnet" {
 name                  = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.bastion_snet_address]
}
