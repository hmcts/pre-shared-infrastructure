module "backup_vault" {
  count              = var.env == "sbox" ? 1 : 0
  source             = "git@github.com:hmcts/pre-shared-infrastructure.git//modules/backup_vault?ref=remove_vaults" #"./modules/backup_vault"
  rg_name            = data.azurerm_resource_group.rg.name
  location           = var.location
  env                = var.env
  product            = var.product
  retention_duration = var.retention_duration #"P100D"
  storageaccount_ids = [
    module.finalsa_storage_account.storageaccount_id,
    module.ingestsa_storage_account.storageaccount_id,
    module.sa_storage_account.storageaccount_id
  ]
}