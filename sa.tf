provider "azurerm" {
  alias                      = "mgmt"
  subscription_id            = var.mgmt_subscription_id
  skip_provider_registration = true
  features {}
}

locals {
  mgmt_network_name    = var.mgmt_net_name
  mgmt_network_rg_name = var.mgmt_net_rg_name
}

data "azurerm_subnet" "jenkins_subnet" {
  provider             = azurerm.mgmt
  name                 = "iaas"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

# adding this to allow postgres pipeline agent located on ss-ptlsbox-vnet to access keyvault
data "azurerm_subnet" "pipelineagent_subnet" {
  provider             = azurerm.mgmt
  name                 = "aks-00"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

###################################################
#                 STORAGES               #
###################################################
module "sa_storage_account" {
  source                          = "git::https://github.com/hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = replace("${var.product}sa${var.env}", "-", "")
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = var.sa_replication_type
  sa_subnets                      = concat([data.azurerm_subnet.jenkins_subnet.id], [azurerm_subnet.endpoint_subnet.id], [azurerm_subnet.datagateway_subnet.id], [azurerm_subnet.videoeditvm_subnet.id])
  allow_nested_items_to_be_public = false
  ip_rules                        = var.ip_rules
  default_action                  = "Deny"
  enable_data_protection          = true

  tags = module.tags.common_tags

  depends_on = [module.key-vault]
}

module "finalsa_storage_account" {
  source                          = "git::https://github.com/hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = replace("${var.product}finalsa${var.env}", "-", "")
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location #"UKWest" #As recommended by MS
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = var.sa_replication_type
  sa_subnets                      = concat([data.azurerm_subnet.jenkins_subnet.id], [azurerm_subnet.endpoint_subnet.id], [azurerm_subnet.datagateway_subnet.id], [azurerm_subnet.videoeditvm_subnet.id])
  allow_nested_items_to_be_public = false
  ip_rules                        = var.ip_rules
  default_action                  = "Deny"
  enable_data_protection          = true

  cors_rules = var.cors_rules

  tags       = module.tags.common_tags
  depends_on = [module.key-vault]
}

module "ingestsa_storage_account" {
  source                          = "git::https://github.com/hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = replace("${var.product}ingestsa${var.env}", "-", "")
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location #"UKWest" #As recommended by MS azurerm_resource_group.rg.location
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = var.sa_replication_type
  sa_subnets                      = concat([data.azurerm_subnet.jenkins_subnet.id], [azurerm_subnet.endpoint_subnet.id], [azurerm_subnet.datagateway_subnet.id], [azurerm_subnet.videoeditvm_subnet.id])
  allow_nested_items_to_be_public = false
  ip_rules                        = var.ip_rules
  default_action                  = "Deny"
  enable_data_protection          = true

  depends_on = [module.key-vault]
  tags       = module.tags.common_tags


}

###################################################
#                PRIVATE ENDPOINTS FOR STORAGES   
###################################################
resource "azurerm_private_endpoint" "sa" {
  name                = "${var.product}sa-pe-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.endpoint_subnet.id

  private_service_connection {
    name                           = "${var.product}sa-psc-${var.env}"
    is_manual_connection           = false
    private_connection_resource_id = module.sa_storage_account.storageaccount_id
    subresource_names              = ["blob"]
  }
  tags = module.tags.common_tags
}

# ###################################################
# #                PRIVATE ENDPOINTS FOR STORAGES   
# ###################################################
resource "azurerm_private_endpoint" "finalsa" {
  name                = "${var.product}finalsa-pe-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.endpoint_subnet.id

  private_service_connection {
    name                           = "${var.product}finalsa-psc-${var.env}"
    is_manual_connection           = false
    private_connection_resource_id = module.finalsa_storage_account.storageaccount_id
    subresource_names              = ["blob"]
  }
  tags = module.tags.common_tags
}

###################################################
#                PRIVATE ENDPOINTS FOR STORAGES    
###################################################
resource "azurerm_private_endpoint" "ingestsa" {
  name                = "${var.product}stream-pe-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.endpoint_subnet.id

  private_service_connection {
    name                           = "${var.product}stream-psc-${var.env}"
    is_manual_connection           = false
    private_connection_resource_id = module.ingestsa_storage_account.storageaccount_id
    subresource_names              = ["blob"]
  }
  tags = module.tags.common_tags
}

# Store the connection string for the SAs in KV
resource "azurerm_key_vault_secret" "sa_storage_account_connection_string" {
  name         = "sa-storage-account-connection-string"
  value        = module.sa_storage_account.storageaccount_primary_connection_string
  key_vault_id = module.key-vault.key_vault_id
}
resource "azurerm_key_vault_secret" "finalsa_storage_account_connection_string" {
  name         = "finalsa-storage-account-connection-string"
  value        = module.finalsa_storage_account.storageaccount_primary_connection_string
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_key_vault_secret" "ingestsa_storage_account_connection_string" {
  name         = "ingestsa-storage-account-connection-string"
  value        = module.ingestsa_storage_account.storageaccount_primary_connection_string
  key_vault_id = module.key-vault.key_vault_id
}