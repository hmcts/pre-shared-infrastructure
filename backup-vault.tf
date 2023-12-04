module "backup_vault" {
  count              = var.env == "prod" || var.env == "test" ? 1 : 0
  source             = "git@github.com:hmcts/pre-shared-infrastructure.git//modules/backup_vault?ref=remove_vaults" #"./modules//backup_vault"
  rg_name            = data.azurerm_resource_group.rg.name
  location           = var.location
  env                = var.env
  product            = var.product
  retention_duration = var.retention_duration
  storageaccount_ids = [
    module.finalsa_storage_account.storageaccount_id,
    module.ingestsa_storage_account.storageaccount_id,
    module.sa_storage_account.storageaccount_id
  ]
  service_principal = var.dts_pre_backup_appreg_oid
  immutability_period_backup = var.immutability_period_backup
  sa_subnets = data.azurerm_subnet.jenkins_subnet.id
  common_tags = var.common_tags
}

resource "azurerm_management_lock" "storage_backup_lock" {
  for_each = toset([for acc in module.backup_vault : acc.storageaccount_id])

  name       = "storage-backup-${each.key}"
  scope      = each.key
  lock_level = "CanNotDelete"
  notes      = "Prevent deletion of storage account ${each.key}"
}