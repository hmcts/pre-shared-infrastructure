resource "azurerm_data_protection_backup_vault" "this" {
  name                = "${var.product}-backup-vault-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_data_protection_backup_vault" "this" {
  name                = "${var.product}-backup-vault-${var.env}"
  resource_group_name = "var.resource_group_name"

  depends_on = [azurerm_data_protection_backup_vault.this]
}

resource "azurerm_data_protection_backup_policy_blob_storage" "this" {
  name               = "${var.product}-backup-policy-${var.env}"
  vault_id           = data.azurerm_data_protection_backup_vault.this.id
  retention_duration = var.retention_duration
}

resource "azurerm_role_assignment" "sa_backup_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = data.azurerm_data_protection_backup_vault.this.identity[0].principal_id

  depends_on = [azurerm_data_protection_backup_vault.this]
}

resource "azurerm_data_protection_backup_instance_blob_storage" "this" {
  name               = "${var.storage_account_id}-backup-${var.env}"
  vault_id           = data.azurerm_data_protection_backup_vault.this.id
  location           = var.location
  storage_account_id = var.storage_account_id
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.this.id

  depends_on = [azurerm_role_assignment.sa_backup_contributor]
}