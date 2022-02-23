provider "azurerm" {
  alias                      = "mgmt"
  subscription_id            = "6c4d2513-a873-41b4-afdd-b05a33206631"
  skip_provider_registration = true
  features {}
}

provider "azurerm" {
  alias                      = "sbox_mgmt"
  subscription_id            = "64b1c6d6-1481-44ad-b620-d8fe26a2c768"
  skip_provider_registration = true
  features {}
}

locals {
  mgmt_network_name         =  var.mgmt_net_name 
  mgmt_network_rg_name      =  var.mgmt_net_rg_name 
 }

data "azurerm_subnet" "jenkins_subnet" {
  provider             = azurerm.mgmt
  name                 = "iaas"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

###########################
#
###################################
resource "azurerm_subnet" "storage" {
  name                                           = "${var.product}-storage-subnet-${var.env}"
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = var.privatelink_snet_address
  enforce_private_link_endpoint_network_policies = true
  
}


resource "azurerm_storage_account" "example" {
  name                     = "${var.product}endpoint${var.env}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "example" {
  name                  = "acctestcont"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
  
}

resource "azurerm_private_endpoint" "example" {
  name                = "${var.product}-pe-${var.env}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.storage.id

  private_service_connection {
    name                           = "${var.product}-psc-${var.env}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.example.id
    subresource_names              = ["blob"]
  }
  
}

