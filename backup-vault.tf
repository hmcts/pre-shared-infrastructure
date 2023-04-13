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