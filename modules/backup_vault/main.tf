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

resource "azurerm_data_protection_backup_policy_blob_storage" "this" {
  name               = "${var.product}-backup-policy-${var.env}"
  vault_id           = azurerm_data_protection_backup_vault.this.id
  retention_duration = var.retention_duration
}

resource "azurerm_data_protection_backup_instance_blob_storage" "this" {
  for_each = { for idx, sa_id in var.storageaccount_ids : idx => {
    storage_account_id   = sa_id
    storage_account_name = local.storageaccount_names[idx]
    }
  }
  name               = "${var.product}-${local.transformed_name[each.key]}-backup-${var.env}" #eg "pre-ingestsa-backup-sbox"
  vault_id           = azurerm_data_protection_backup_vault.this.id
  location           = var.location
  storage_account_id = each.value.storage_account_id
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.this.id

  depends_on = [azurerm_role_assignment.backup_contributor]
}

locals {
  storageaccount_names = [for id in var.storageaccount_ids : basename(id)]
  transformed_name     = [for name in local.storageaccount_names : replace(replace(name, "/^.../", ""), var.env, "")]
}