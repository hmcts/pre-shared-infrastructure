resource "azurerm_resource_group" "this" {
  name     = "${var.product}-${var.env}-backup"
  location = var.location_backup
}

resource "azurerm_data_protection_backup_vault" "this" {
  name                = "${var.product}-backup-vault-${var.env}"
  resource_group_name = var.rg_name
  location            = var.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "backup_contributor" {
  for_each             = { for sa in var.storageaccount_ids : sa => sa }
  scope                = each.value
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = azurerm_data_protection_backup_vault.this.identity[0].principal_id
}

resource "azurerm_data_protection_backup_policy_blob_storage" "thise" {
  name               = "${var.product}-backup-policy-${var.env}"
  vault_id           = azurerm_data_protection_backup_vault.this.id
  retention_duration = var.retention_duration
}

resource "azurerm_data_protection_backup_instance_blob_storage" "this" {
  for_each           = { for sa in var.storageaccount_ids : sa => sa }
  name               = "${var.product}-${var.sa_name}-backup-${var.env}"
  vault_id           = azurerm_data_protection_backup_vault.this.id
  location           = var.location
  storage_account_id = each.value
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.thise.id

  depends_on = [azurerm_role_assignment.backup_contributor]
}
