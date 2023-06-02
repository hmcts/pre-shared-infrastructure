module "sa_storage_account" {
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=restore_policy"
  env                             = var.env
  storage_account_name            = "${var.product}sa${var.env}"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = var.sa_replication_type
  allow_nested_items_to_be_public = false
  default_action                  = "Deny"
  enable_data_protection          = true
  managed_identity_object_id      = data.azurerm_user_assigned_identity.managed_identity.principal_id
  # private_endpoint_subnet_id      = data.azurerm_subnet.endpoint_subnet.id

  role_assignments = [
    "Storage Blob Data Contributor"
  ]

  common_tags = var.common_tags
}

# Store the connection string for the SAs in KV
resource "azurerm_key_vault_secret" "sa_storage_account_connection_string" {
  name         = "sa-storage-account-connection-string"
  value        = module.sa_storage_account.storageaccount_primary_connection_string
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

# module "sa_backup" {
#   count  = var.env == "dev" || var.env == "prod" ? 1 : 0
#   source = "git@github.com:hmcts/pre-shared-infrastructure.git//modules/backup_vault?ref=preview"

#   env                  = var.env
#   product              = var.product
#   resource_group_name  = data.azurerm_resource_group.rg.name
#   storage_account_name = module.sa_storage_account.storageaccount_name
#   location             = var.location
#   storage_account_id   = module.sa_storage_account.storageaccount_id
#   tags                 = var.common_tags
#   retention_duration   = var.retention_duration
# }

resource "azurerm_data_protection_backup_vault" "this" {
  name                = "${var.product}-backup-vault-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  datastore_type      = "VaultStore"
  redundancy          = "GeoRedundant"
  tags                = var.common_tags
  identity {
    type = "SystemAssigned"
  }
}

# data "azurerm_data_protection_backup_vault" "this" {
#   name                = "${var.product}-backup-vault-${var.env}"
#   resource_group_name = data.azurerm_resource_group.rg.name
# }

resource "azurerm_role_assignment" "sa_backup_contributor" {
  scope                = module.sa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = azurerm_data_protection_backup_vault.this.identity.0.principal_id #data.azurerm_data_protection_backup_vault.this.principal_id #data.azurerm_data_protection_backup_vault.this.identity.0.principal_id

}

resource "azurerm_data_protection_backup_policy_blob_storage" "this" {
  name               = "${var.product}-backup-policy-${var.env}"
  vault_id           = azurerm_data_protection_backup_vault.this.id
  retention_duration = var.retention_duration
}

# resource "azurerm_data_protection_backup_instance_blob_storage" "this" {
#   name               = "${module.sa_storage_account.storageaccount_id}backup"
#   vault_id           = azurerm_data_protection_backup_vault.this.id
#   location           = var.location
#   storage_account_id = module.sa_storage_account.storageaccount_id
#   backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.this.id

#   depends_on = [azurerm_role_assignment.sa_backup_contributor]
# }

resource "azurerm_monitor_diagnostic_setting" "storageblobsa" {
  name                       = module.sa_storage_account.storageaccount_name
  target_resource_id         = "${module.sa_storage_account.storageaccount_id}/blobServices/default"
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  log {
    category = "StorageRead"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "StorageWrite"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "StorageDelete"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "Transaction"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }
}