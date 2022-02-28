

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.product}-vnet01-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_address_space]

  subnet {
    name                  = "${var.product}-videoeditvm-snet-${var.env}"
    address_prefix        = var.video_edit_vm_snet_address
  }

  # subnet {
  #   name           = "${var.product}-privatendpt-snet-${var.env}"
  #   address_prefix = var.privatendpt_snet_address
  #   service_endpoints     = ["Microsoft.Storage"]
  #   # enforce_private_link_endpoint_network_policies = false
  # // enforce_private_link_service_network_policies = false
  # }
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


#------------------------------------------------------###################
# ENDPOINT SUBNET
#------------------------------------------------------###################
resource "azurerm_subnet" "endpoint_subnet" {
 name                  = "${var.product}-privatendpt-snet-${var.env}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.privatendpt_snet_address
  service_endpoints    = ["Microsoft.Storage"]
  enforce_private_link_endpoint_network_policies = true
}

output "subnet_ids" {
   value = azurerm_virtual_network.vnet.subnet[*].id
}


output "private_endpt_subnet_ids" {
   value = azurerm_subnet.endpoint_subnet.id
  #  "${data.azurerm_virtual_network.test.id}"
}