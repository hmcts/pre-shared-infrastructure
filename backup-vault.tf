module "backup_vault" {
  count              = var.env == "prod" ? 1 : 0
  source             = "git@github.com:hmcts/pre-backup-vault.git/?ref=master"
  rg_name            = data.azurerm_resource_group.rg.name
  location           = var.location
  env                = var.env
  product            = var.product
  retention_duration = var.retention_duration
  common_tags        = var.common_tags
  storageaccount_ids = [
    module.finalsa_storage_account.storageaccount_id,
    module.ingestsa_storage_account.storageaccount_id,
    module.sa_storage_account.storageaccount_id
  ]
}
