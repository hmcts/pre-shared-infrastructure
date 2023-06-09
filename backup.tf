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

resource "azurerm_data_protection_backup_policy_blob_storage" "pre_backup_policy_storage" {
  name               = "${var.product}-backup-policy-${var.env}"
  vault_id           = azurerm_data_protection_backup_vault.pre_backup_vault.id
  retention_duration = var.retention_duration

  depends_on = [azurerm_media_services_account.ams]
}

