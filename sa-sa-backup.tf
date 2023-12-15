module "sa_storage_account_backup" {
  count                           = var.env == "prod" || var.env == "test" || var.env == "sbox" ? 1 : 0
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = "${var.product}sabackup${var.env}"
  resource_group_name             = module.backup_vault[0].resource_group_name
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
  count      = var.env == "prod" ? 1 : 0
  name       = "storage-backup"
  scope      = module.sa_storage_account_backup[0].storageaccount_id
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
  count                = var.env == "prod" || var.env == "test" ? 1 : 0
  scope                = module.sa_storage_account_backup[0].storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}

# To get key and create container in backup sa storage account
resource "azurerm_role_assignment" "powerapp_appreg_sa2" {
  count                = var.env == "prod" || var.env == "test" ? 1 : 0
  scope                = module.sa_storage_account_backup[0].storageaccount_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}

# Used in storage account backups to get key and list containers
resource "azurerm_role_assignment" "powerapp_appreg_sa_cont" {
  scope                = module.sa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}