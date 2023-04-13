module "finalsa_storage_account" {
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = "${var.product}finalsa${var.env}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = var.sa_replication_type
  sa_subnets                      = concat([data.azurerm_subnet.jenkins_subnet.id], [azurerm_subnet.endpoint_subnet.id], [azurerm_subnet.datagateway_subnet.id], [azurerm_subnet.videoeditvm_subnet.id])
  allow_nested_items_to_be_public = false
  ip_rules                        = var.ip_rules
  default_action                  = "Allow"
  enable_data_protection          = true
  cors_rules                      = var.cors_rules
  managed_identity_object_id      = data.azurerm_user_assigned_identity.managed-identity.principal_id
  enable_change_feed              = true
  immutable_enabled               = true
  immutability_period             = 100
  # private_endpoint_subnet_id      = azurerm_subnet.endpoint_subnet.id
  role_assignments = [
    "Storage Blob Data Contributor"
  ]

  common_tags = var.common_tags
  depends_on  = [module.key-vault]
}


module "finalsa_backup" {
  count  = var.env == "stg" || var.env == "prod"  || var.env == "sbox" ? 1 : 0
  source = "git@github.com:hmcts/pre-shared-infrastructure.git//modules/backup_vault?ref=preview"

  env                  = var.env
  product              = var.product
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_name = "${var.product}finalsa${var.env}"
  location             = var.location
  storage_account_id   = module.finalsa_storage_account.storageaccount_id
  tags                 = var.common_tags
  retention_duration   = var.retention_duration
}

resource "azurerm_key_vault_secret" "finalsa_storage_account_connection_string" {
  name         = "finalsa-storage-account-connection-string"
  value        = module.finalsa_storage_account.storageaccount_primary_connection_string
  key_vault_id = module.key-vault.key_vault_id
}

