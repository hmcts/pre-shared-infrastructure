resource "azurerm_resource_group" "rg_backup" {
  name     = "${var.product}-${var.env}-backup"
  location = var.location_backup
  tags     = var.common_tags
}

resource "azurerm_data_protection_backup_vault" "pre_backup_vault" {
  name                = "${var.product}-backup-vault-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"
  tags                = var.common_tags
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "backup_role_finalsa" {
  scope                = module.finalsa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = azurerm_data_protection_backup_vault.pre_backup_vault.identity[0].principal_id
}

resource "azurerm_role_assignment" "backup_role_sa" {
  scope                = module.sa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = azurerm_data_protection_backup_vault.pre_backup_vault.identity[0].principal_id
}

resource "azurerm_role_assignment" "backup_role_ingestsa" {
  scope                = module.ingestsa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = azurerm_data_protection_backup_vault.pre_backup_vault.identity[0].principal_id
}

resource "azurerm_data_protection_backup_policy_blob_storage" "pre_backup_policy_storage" {
  name               = "${var.product}-backup-policy-${var.env}"
  vault_id           = azurerm_data_protection_backup_vault.pre_backup_vault.id
  retention_duration = var.retention_duration

  depends_on = [azurerm_media_services_account.ams]
}

resource "azurerm_data_protection_backup_instance_blob_storage" "finalsabackup" {
  name               = "${var.product}-finalsa-backup-${var.env}"
  vault_id           = azurerm_data_protection_backup_vault.pre_backup_vault.id
  location           = var.location
  storage_account_id = module.finalsa_storage_account.storageaccount_id
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.pre_backup_policy_storage.id

  depends_on = [azurerm_role_assignment.backup_role_finalsa, module.finalsa_storage_account]
}

resource "azurerm_data_protection_backup_instance_blob_storage" "sabackup" {
  name               = "${var.product}-sa-backup-${var.env}"
  vault_id           = azurerm_data_protection_backup_vault.pre_backup_vault.id
  location           = var.location
  storage_account_id = module.sa_storage_account.storageaccount_id
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.pre_backup_policy_storage.id

  depends_on = [azurerm_role_assignment.backup_role_sa, module.sa_storage_account]
}

resource "azurerm_data_protection_backup_instance_blob_storage" "ingestsabackup" {
  name               = "${var.product}-ingestsa-backup-${var.env}"
  vault_id           = azurerm_data_protection_backup_vault.pre_backup_vault.id
  location           = var.location
  storage_account_id = module.ingestsa_storage_account.storageaccount_id
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.pre_backup_policy_storage.id

  depends_on = [azurerm_role_assignment.backup_role_ingestsa, module.ingestsa_storage_account]
}

module "sabackup" {
  source             = "./modules/backup_vault"
  rg_name            = data.azurerm_resource_group.rg.name
  sa_name            = "final"
  location           = var.location
  env                = var.env
  product            = var.product
  retention_duration = "P100D"
  # storageaccount_id = module.finalsa_storage_account.storageaccount_id
  storageaccount_ids = [module.finalsa_storage_account.storageaccount_id]
  # location_backup =
}