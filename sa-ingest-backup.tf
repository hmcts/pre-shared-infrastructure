module "ingestsa_storage_account_backup" {
  count                           = var.env == "prod" ? 1 : 0
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=fix/defender-azapi"
  env                             = var.env
  storage_account_name            = "${var.product}ingestsabackup${var.env}"
  resource_group_name             = module.backup_vault[0].resource_group_name
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
  count      = var.env == "prod" ? 1 : 0
  name       = "storage-backup"
  scope      = module.ingestsa_storage_account_backup[0].storageaccount_id
  lock_level = "CanNotDelete"
  notes      = "prevent users from deleting storage accounts"
}

# Give the appreg (managed application in local directory) OID Storage Blob Data Contributor role on both the storage account and backup storage account
resource "azurerm_role_assignment" "powerapp_appreg_ingest" {
  scope                = module.ingestsa_storage_account.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}

resource "azurerm_role_assignment" "powerapp_appreg_ingestfinal" {
  count                = var.env == "prod" ? 1 : 0
  scope                = module.ingestsa_storage_account_backup[0].storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}
