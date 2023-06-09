module "sa_storage_account_backup" {
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = "${var.product}sabackup${var.env}"
  resource_group_name             = azurerm_resource_group.rg_backup.name
  location                        = var.location_backup
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = "LRS"
  sa_subnets                      = concat([data.azurerm_subnet.jenkins_subnet.id])
  allow_nested_items_to_be_public = false
  default_action                  = "Allow"
  enable_data_protection          = false

  common_tags = var.common_tags
}

resource "azurerm_management_lock" "storage-backup-sa" {
  name       = "storage-backup"
  scope      = module.sa_storage_account_backup.storageaccount_id
  lock_level = "CanNotDelete"
  notes      = "prevent users from deleting storage accounts"
  depends_on = [azurerm_media_services_account.ams]
}

# Give the appreg (managed application in local directory) OID Storage Blob Data Contributor role on both the storage account and backup storage account
resource "azurerm_role_assignment" "powerapp_appreg_sa" {
  scope                = module.sa_storage_account.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}

resource "azurerm_role_assignment" "powerapp_appreg_sabackup" {
  scope                = module.sa_storage_account_backup.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}

# To get key and create container in backup sa storage account
resource "azurerm_role_assignment" "powerapp_appreg_sa2" {
  scope                = module.sa_storage_account_backup.storageaccount_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}

resource "azurerm_role_assignment" "backup_role_sa" {
  scope                = module.sa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = azurerm_data_protection_backup_vault.pre_backup_vault.identity[0].principal_id
}

resource "azurerm_data_protection_backup_instance_blob_storage" "sabackup" {
  name               = "${var.product}-sa-backup-${var.env}"
  vault_id           = azurerm_data_protection_backup_vault.pre_backup_vault.id
  location           = var.location
  storage_account_id = module.sa_storage_account.storageaccount_id
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.pre_backup_policy_storage.id

  depends_on = [azurerm_role_assignment.backup_role_sa, module.sa_storage_account]
}
