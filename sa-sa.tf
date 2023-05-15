module "sa_storage_account" {
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = "${var.product}sa${var.env}"
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
  enable_change_feed              = true

  # private_endpoint_subnet_id = azurerm_subnet.endpoint_subnet.id

  common_tags = var.common_tags
}

resource "azurerm_key_vault_secret" "sa_storage_account_connection_string" {
  name         = "sa-storage-account-connection-string"
  value        = module.sa_storage_account.storageaccount_primary_connection_string
  key_vault_id = module.key-vault.key_vault_id
}

# Used in storage account backups to get key and list containers
resource "azurerm_role_assignment" "powerapp_appreg_sa_cont" {
  scope                = module.sa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}