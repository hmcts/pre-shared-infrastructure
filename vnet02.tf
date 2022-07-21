# resource "azurerm_network_ddos_protection_plan" "pre-ddos" {
#   name                = "pre-ddos-protection-plan"
#   resource_group_name = azurerm_resource_group.rg02.name
#   location            = azurerm_resource_group.rg.location
#   tags = var.common_tags
# }
resource "azurerm_virtual_network" "vnet02" {
  name                = "${var.product}-vnet02-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg02.name
  address_space       = [var.vnet02_address_space]
  # ddos_protection_plan {
  #   id          = azurerm_network_ddos_protection_plan.pre-ddos.id
  #   enable      = true
  # }
  
 tags = var.common_tags
}

//resource "azurerm_subnet" "sa_subnet" {
//  name                 = "${var.product}-snet01-${var.env}"
//  resource_group_name  = azurerm_resource_group.rg02.name
//  virtual_network_name = azurerm_virtual_network.vnet02.name
//  address_prefixes     = var.video_edit_vm_snet_address
//  service_endpoints    = ["Microsoft.Storage"]
//}
//


#------------------------------------------------------###################
#SUBNET with ENDPOINT 
#------------------------------------------------------###################
resource "azurerm_subnet" "datagateway02_subnet" {
 name                  = "${var.product}-datagateway-snet-${var.env}"
  resource_group_name  = azurerm_resource_group.rg02.name
  virtual_network_name = azurerm_virtual_network.vnet02.name
  address_prefixes     = [var.dtgtway02_snet_address]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault"]
 }

resource "azurerm_subnet" "videoeditvm02_subnet" {
 name                  = "${var.product}-videoeditvm-snet-${var.env}"
  resource_group_name  = azurerm_resource_group.rg02.name
  virtual_network_name = azurerm_virtual_network.vnet02.name
  address_prefixes     = [var.vid02_edit_vm_snet_address]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.KeyVault"]
}


resource "azurerm_subnet" "endpoint02_subnet" {
 name                  = "${var.product}-privatendpt-snet-${var.env}"
  resource_group_name  = azurerm_resource_group.rg02.name
  virtual_network_name = azurerm_virtual_network.vnet02.name
  address_prefixes     = [var.privatendpt02_snet_address]
  service_endpoints    = ["Microsoft.Storage","Microsoft.KeyVault"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "AzureBastionSubnet02_subnet" {
 name                  = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg02.name
  virtual_network_name = azurerm_virtual_network.vnet02.name
  address_prefixes     = [var.bastion02_snet_address]
}
