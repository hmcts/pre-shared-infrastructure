module "backup_vault" {
  count              = var.env == "prod" || var.env == "test"  ? 1 : 0
  source             = "git@github.com:hmcts/pre-shared-infrastructure.git//modules/backup_vault?ref=remove_vaults"
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
}