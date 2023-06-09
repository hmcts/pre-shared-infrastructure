module "ingestsa_storage_account_backup" {
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = "${var.product}ingestsabackup${var.env}"
  resource_group_name             = azurerm_resource_group.rg_backup.name
  location                        = var.location_backup
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = "LRS"
  sa_subnets                      = concat([data.azurerm_subnet.jenkins_subnet.id])
  allow_nested_items_to_be_public = false
  default_action                  = "Allow"
  enable_data_protection          = false
  immutable_enabled               = true
  immutability_period             = var.immutability_period_backup

  common_tags = var.common_tags
}

resource "azurerm_management_lock" "storage-backup-ingest" {
  name       = "storage-backup"
  scope      = module.ingestsa_storage_account_backup.storageaccount_id
  lock_level = "CanNotDelete"
  notes      = "prevent users from deleting storage accounts"
  depends_on = [azurerm_media_services_account.ams]
}

# Give the appreg (managed application in local directory) OID Storage Blob Data Contributor role on both the storage account and backup storage account
resource "azurerm_role_assignment" "powerapp_appreg_ingest" {
  scope                = module.ingestsa_storage_account.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}

resource "azurerm_role_assignment" "powerapp_appreg_ingestfinal" {
  scope                = module.ingestsa_storage_account_backup.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}

resource "azurerm_role_assignment" "backup_role_ingestsa" {
  scope                = module.ingestsa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = azurerm_data_protection_backup_vault.pre_backup_vault.identity[0].principal_id
}

resource "azurerm_data_protection_backup_instance_blob_storage" "ingestsabackup" {
  name               = "${var.product}-ingestsa-backup-${var.env}"
  vault_id           = azurerm_data_protection_backup_vault.pre_backup_vault.id
  location           = var.location
  storage_account_id = module.ingestsa_storage_account.storageaccount_id
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.pre_backup_policy_storage.id

  depends_on = [azurerm_role_assignment.backup_role_ingestsa, module.ingestsa_storage_account]
}