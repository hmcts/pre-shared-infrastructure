module "ingestsa_storage_account_backup" {
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = "${var.product}ingestsa${var.env}backup"
  resource_group_name             = azurerm_resource_group.rg_backup.name
  location                        = var.location_backup
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = "LRS"
  sa_subnets                      = concat([data.azurerm_subnet.jenkins_subnet.id])
  allow_nested_items_to_be_public = false
  default_action                  = "Allow"

  immutable_enabled   = true
  immutability_period = var.immutability_period_backup

  role_assignments = [
    "Storage Blob Data Contributor"
  ]

  common_tags = var.common_tags
  depends_on  = [module.key-vault]
}

# Add in once tested
#resource "azurerm_management_lock" "storage-backup" {
#  name       = "storage-backup"
#  scope      = module.ingestsa_storage_account_backup.storageaccount_id
#  lock_level = "CanNotDelete"
#  notes      = "prevent users from deleting storage accounts"
#}

# Give the appreg (managed application in local directory) OID Storage Blob Data Contributor role on both the storage account and backup storage account
resource "azurerm_role_assignment" "powerapp_appreg" {
  scope                = module.ingestsa_storage_account.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}

resource "azurerm_role_assignment" "powerapp_appreg" {
  scope                = module.ingestsa_storage_account_backup.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}

