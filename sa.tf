provider "azurerm" {
  alias                      = "mgmt"
  subscription_id            = var.mgmt_subscription_id
  skip_provider_registration = true
  features {}
}

provider "azurerm" {
  alias                      = "sbox_mgmt"
  subscription_id            = var.mgmt_subscription_id
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
# data "azurerm_subnet" "jenkins_subnet" {
#   provider             = azurerm.mgmt
#   name                 = "iaas"
#   virtual_network_name = local.mgmt_network_name
#   resource_group_name  = local.mgmt_network_rg_name
# }

# data "azurerm_subnet" "sbox_jenkins_subnet" {
#   provider             = azurerm.sbox_mgmt
#   name                 = "iaas"
#   virtual_network_name = local.sbox_mgmt_network_name
#   resource_group_name  = local.sbox_mgmt_network_rg_name
# }

###################################################
#                 STORAGES               #
###################################################
module "ams_storage_account" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                      = var.env
  storage_account_name     = replace("${var.product}ams${var.env}", "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = var.sa_account_tier
  account_replication_type = var.sa_replication_type
  sa_subnets               = concat([data.azurerm_subnet.jenkins_subnet.id],[azurerm_subnet.endpoint_subnet.id],[azurerm_subnet.datagateway_subnet.id],[azurerm_subnet.videoeditvm_subnet.id])
  # sa_subnets = [data.azurerm_subnet.jenkins_subnet.id, var.video_edit_vm_snet_address,var.privatendpt_snet_address], [azurerm_subnet.datagateway_subnet.id],[azurerm_subnet.videoeditvm_subnet.id]
  ip_rules                 = []
  allow_blob_public_access = false
  default_action           = "Deny"
  # depends_on = [azurerm_virtual_network.vnet.subnet.*.id[3]]
  # containers = [{
  #   name        = "ams"
  #   access_type = "private"
  # }]
  common_tags = var.common_tags
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
  # sa_subnets               = concat([data.azurerm_subnet.jenkins_subnet.id], slice(azurerm_virtual_network.vnet.subnet.))
  sa_subnets               = concat([data.azurerm_subnet.jenkins_subnet.id],[azurerm_subnet.endpoint_subnet.id], [azurerm_subnet.datagateway_subnet.id],[azurerm_subnet.videoeditvm_subnet.id])
  ip_rules                 = []
  allow_blob_public_access = false
  default_action           = "Deny"
  containers = [{
    name        = "final"
    access_type = "private"
  }]

  # depends_on = [azurerm_virtual_network.vnet.subnet.*.id[3]]
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
  # sa_subnets               = concat([data.azurerm_subnet.jenkins_subnet.id], slice(azurerm_virtual_network.vnet.subnet.*.id, 0, 1))
  sa_subnets               = concat([data.azurerm_subnet.jenkins_subnet.id],[azurerm_subnet.endpoint_subnet.id], [azurerm_subnet.datagateway_subnet.id],[azurerm_subnet.videoeditvm_subnet.id])
  ip_rules                 = []
  allow_blob_public_access = false
  default_action           = "Deny"
  containers = [{
    name        = "streaming"
    access_type = "private"
  }]

  # depends_on = [azurerm_virtual_network.vnet.name]
  common_tags = var.common_tags
}

###################################################
#                PRIVATE ENDPOINTS FOR STORAGES   
###################################################
resource "azurerm_private_endpoint" "ams" {
  name                     = "${var.product}ams-pe-${var.env}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  subnet_id                = azurerm_subnet.endpoint_subnet.id

  private_service_connection {
    name                           = "${var.product}ams-psc-${var.env}"
    is_manual_connection           = false
    private_connection_resource_id = module.ams_storage_account.storageaccount_id
    subresource_names              = ["blob"]
  }
  tags = var.common_tags
}


# ###################################################
# #                PRIVATE ENDPOINTS FOR STORAGES   
# ###################################################
resource "azurerm_private_endpoint" "final" {
  name                     = "${var.product}final-pe-${var.env}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  subnet_id                = azurerm_subnet.endpoint_subnet.id

  private_service_connection {
    name                           = "${var.product}final-psc-${var.env}"
    is_manual_connection           = false
    private_connection_resource_id = module.final_storage_account.storageaccount_id
    subresource_names              = ["blob"]
  }
 tags = var.common_tags
}

###################################################
#                PRIVATE ENDPOINTS FOR STORAGES    
###################################################
resource "azurerm_private_endpoint" "streaming" {
  name                     = "${var.product}stream-pe-${var.env}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  subnet_id                = azurerm_subnet.endpoint_subnet.id

  private_service_connection {
    name                           = "${var.product}stream-psc-${var.env}"
    is_manual_connection           = false
    private_connection_resource_id = module.streaming_storage_account.storageaccount_id
    subresource_names              = ["blob"]
  }
 tags = var.common_tags
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

output "ams_storage_account_name" {
  value = module.ams_storage_account.storageaccount_name
}

output "final_storage_account_name" {
  value = module.final_storage_account.storageaccount_name
}

output "final_storage_account_id" {
  value = module.final_storage_account.storageaccount_id
}
output "streaming_storage_account_name" {
  value = module.streaming_storage_account.storageaccount_name
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