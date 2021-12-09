provider "azurerm" {
  alias                      = "mgmt"
  subscription_id            = "6c4d2513-a873-41b4-afdd-b05a33206631"
  skip_provider_registration = true
  features {}
}

locals {
  mgmt_network_name    = "ss-ptl-vnet"
  mgmt_network_rg_name = "ss-ptl-network-rg"
}

data "azurerm_subnet" "jenkins_subnet" {
  provider             = azurerm.mgmt
  name                 = "iaas"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

module "ams_storage_account" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                      = var.env
  storage_account_name     = replace("${var.product}amssa${var.env}", "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = var.sa_account_tier
  account_replication_type = var.sa_replication_type
//  sa_subnets               = concat([data.azurerm_subnet.jenkins_subnet.id], azurerm_virtual_network.vnet.subnet.*.id)
  sa_subnets               = [data.azurerm_subnet.jenkins_subnet.id]

  common_tags = var.common_tags
}

module "final_storage_account" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                      = var.env
  storage_account_name     = replace("${var.product}finalsa${var.env}", "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = var.sa_account_tier
  account_replication_type = var.sa_replication_type
//  sa_subnets               = concat([data.azurerm_subnet.jenkins_subnet.id], slice(azurerm_virtual_network.vnet.subnet.*.id, 0, 1))
  sa_subnets               = [data.azurerm_subnet.jenkins_subnet.id]
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

output "ams_storage_account_name" {
  value = module.ams_storage_account.storageaccount_name
}

output "final_storage_account_name" {
  value = module.final_storage_account.storageaccount_name
}

output "ams_storage_account_primary_key" {
  sensitive = true
  value     = module.ams_storage_account.storageaccount_primary_access_key
}

output "final_storage_account_primary_key" {
  sensitive = true
  value     = module.final_storage_account.storageaccount_primary_access_key
}
