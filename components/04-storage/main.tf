locals {
  resource_group_name = "${var.product}-${var.env}"
}
module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.env
  product     = var.prefix
  builtFrom   = var.builtFrom
}

module "sa_storage_account" {
  source                          = "git::https://github.com/hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = "${var.prefix}sa${var.env}"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = var.sa_replication_type
  sa_subnets                      = concat([data.azurerm_subnet.endpoint_subnet.id], [data.azurerm_subnet.datagateway_subnet.id], [data.azurerm_subnet.videoedit_subnet.id])
  allow_nested_items_to_be_public = false
  ip_rules                        = var.ip_rules
  default_action                  = "Deny"
  enable_data_protection          = true

  common_tags = module.tags.common_tags
}

module "finalsa_storage_account" {
  source                          = "git::https://github.com/hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = "${var.prefix}finalsa${var.env}"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = var.location #"UKWest" #As recommended by MS
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = var.sa_replication_type
  sa_subnets                      = concat([data.azurerm_subnet.endpoint_subnet.id], [data.azurerm_subnet.datagateway_subnet.id], [data.azurerm_subnet.videoedit_subnet.id])
  allow_nested_items_to_be_public = false
  ip_rules                        = var.ip_rules
  default_action                  = "Allow"
  enable_data_protection          = true
  cors_rules                      = var.cors_rules

  common_tags = module.tags.common_tags
}

module "ingestsa_storage_account" {
  source                          = "git::https://github.com/hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = "${var.prefix}ingestsa${var.env}"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = var.location #"UKWest" #As recommended by MS azurerm_resource_group.rg.location
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = var.sa_replication_type
  sa_subnets                      = concat([data.azurerm_subnet.endpoint_subnet.id], [data.azurerm_subnet.datagateway_subnet.id], [data.azurerm_subnet.videoedit_subnet.id])
  allow_nested_items_to_be_public = false
  ip_rules                        = var.ip_rules
  default_action                  = "Deny"
  enable_data_protection          = true

  common_tags = module.tags.common_tags
}


resource "azurerm_private_endpoint" "sa" {
  name                = "${var.prefix}sa-pe-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_id           = data.azurerm_subnet.endpoint_subnet.id

  private_service_connection {
    name                           = "${var.prefix}sa-psc-${var.env}"
    is_manual_connection           = false
    private_connection_resource_id = module.sa_storage_account.storageaccount_id
    subresource_names              = ["blob"]
  }
  tags = module.tags.common_tags
}

resource "azurerm_private_endpoint" "finalsa" {
  name                = "${var.prefix}finalsa-pe-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_id           = data.azurerm_subnet.endpoint_subnet.id

  private_service_connection {
    name                           = "${var.prefix}finalsa-psc-${var.env}"
    is_manual_connection           = false
    private_connection_resource_id = module.finalsa_storage_account.storageaccount_id
    subresource_names              = ["blob"]
  }
  tags = module.tags.common_tags
}

resource "azurerm_private_endpoint" "ingestsa" {
  name                = "${var.prefix}stream-pe-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_id           = data.azurerm_subnet.endpoint_subnet.id

  private_service_connection {
    name                           = "${var.prefix}stream-psc-${var.env}"
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
  key_vault_id = data.azurerm_key_vault.keyvault.id
}
resource "azurerm_key_vault_secret" "finalsa_storage_account_connection_string" {
  name         = "finalsa-storage-account-connection-string"
  value        = module.finalsa_storage_account.storageaccount_primary_connection_string
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "ingestsa_storage_account_connection_string" {
  name         = "ingestsa-storage-account-connection-string"
  value        = module.ingestsa_storage_account.storageaccount_primary_connection_string
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

#SA role assignments
resource "azurerm_role_assignment" "mi_storage_1" {
  scope                            = module.ingestsa_storage_account.storageaccount_id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "mi_storage_2" {
  scope                            = module.finalsa_storage_account.storageaccount_id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id
  skip_service_principal_aad_check = true
}