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

# data "azurerm_subnet" "sbox_jenkins_subnet" {
#   provider             = azurerm.sbox_mgmt
#   name                 = "iaas"
#   virtual_network_name = local.sbox_mgmt_network_name
#   resource_group_name  = local.sbox_mgmt_network_rg_name
# }

module "ams_storage_account" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                      = var.env
  storage_account_name     = replace("${var.product}ams${var.env}", "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = var.sa_account_tier
  account_replication_type = var.sa_replication_type
  //  sa_subnets               = concat([data.azurerm_subnet.jenkins_subnet.id], azurerm_virtual_network.vnet.subnet.*.id)
  sa_subnets = [data.azurerm_subnet.jenkins_subnet.id, azurerm_virtual_network.vnet.subnet.*.id[0]]

  common_tags = var.common_tags
}


###################################################
#                PRIVATE ENDPOINT                 #
###################################################
resource "azurerm_private_endpoint" "finalendpoint" {
  name                     = "${var.product}finalprivendpoint${var.env}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  subnet_id                = azurerm_virtual_network.vnet.subnet.*.id[2]

  private_service_connection {
    name                           = "${var.product}finalpsc${var.env}" 
    private_connection_resource_id = module.final_storage_account.id
    is_manual_connection           = false
    subresource_names              =  [ "blob" ]
    
  
  }
 depends_on = [module.final_storage_account.storageaccount_name]
#   private_dns_zone_group {
#     name = lower(var.storage_account_name)
#     private_dns_zone_ids = var.private_dns_zone_ids
#   }
 }



module "final_storage_account" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                      = var.env
  storage_account_name     = replace("${var.product}final${var.env}", "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = var.sa_account_tier
  account_replication_type = var.sa_replication_type
  //  sa_subnets               = concat([data.azurerm_subnet.jenkins_subnet.id], slice(azurerm_virtual_network.vnet.subnet.*.id, 0, 1))
  sa_subnets = [data.azurerm_subnet.jenkins_subnet.id]
  # enforce_private_link_endpoint_network_policies = false
  containers = [{
    name        = "final"
    access_type = "private"
  }]

  common_tags = var.common_tags
}

module "streaming_storage_account" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                      = var.env
  storage_account_name     = replace("${var.product}streaming${var.env}", "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = var.sa_account_tier
  account_replication_type = var.sa_replication_type
  //  sa_subnets               = concat([data.azurerm_subnet.jenkins_subnet.id], slice(azurerm_virtual_network.vnet.subnet.*.id, 0, 1))
  sa_subnets = [data.azurerm_subnet.jenkins_subnet.id, data.azurerm_subnet.jenkins_subnet.id]
  containers = [{
    name        = "final"
    access_type = "private"
  }]

  common_tags = var.common_tags
}

module "sa_storage_account" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                      = var.env
  storage_account_name     = replace("${var.product}sa${var.env}", "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = var.sa_account_tier
  account_replication_type = var.sa_replication_type
  //  sa_subnets               = concat([data.azurerm_subnet.jenkins_subnet.id], slice(azurerm_virtual_network.vnet.subnet.*.id, 0, 1))
  sa_subnets = [data.azurerm_subnet.jenkins_subnet.id, data.azurerm_subnet.jenkins_subnet.id]
  containers = [{
    name        = "final"
    access_type = "private"
  }]

 common_tags = var.common_tags
}
# Store the connection string for the SAs in KV
resource "azurerm_key_vault_secret" "ams_storage_account_connection_string" {
  name         = "ams-storage-account-connection-string"
  value        = module.ams_storage_account.storageaccount_primary_connection_string
  key_vault_id = module.key-vault.key_vault_id
}
resource "azurerm_key_vault_secret" "final_storage_account_connection_string" {
  name         = "final-storage-account-connection-string"
  value        = module.final_storage_account.storageaccount_primary_connection_string
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "streaming_storage_account_connection_string" {
  name         = "streaming-storage-account-connection-string"
  value        = module.streaming_storage_account.storageaccount_primary_connection_string
  key_vault_id = module.key-vault.key_vault_id
}


resource "azurerm_key_vault_secret" "sa_storage_account_connection_string" {
  name         = "sa-storage-account-connection-string"
  value        = module.sa_storage_account.storageaccount_primary_connection_string
  key_vault_id = module.key-vault.key_vault_id
}

output "ams_storage_account_name" {
  value = module.ams_storage_account.storageaccount_name
}

output "ams_storage_account_id" {
    value = module.ams_storage_account.storage.id
}


output "final_storage_account_name" {
  value = module.final_storage_account.storageaccount_name
}

output "streaming_storage_account_name" {
  value = module.streaming_storage_account.storageaccount_name
}

output "sa_storage_account_name" {
  value = module.sa_storage_account.storageaccount_name
}
output "ams_storage_account_primary_key" {
  sensitive = true
  value     = module.ams_storage_account.storageaccount_primary_access_key
}

output "final_storage_account_primary_key" {
  sensitive = true
  value     = module.final_storage_account.storageaccount_primary_access_key
}
output "streaming_storage_account_primary_key" {
  sensitive = true
  value     = module.streaming_storage_account.storageaccount_primary_access_key
}

output "sa_storage_account_primary_key" {
  sensitive = true
  value     = module.sa_storage_account.storageaccount_primary_access_key
}