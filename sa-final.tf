module "finalsa_storage_account" {
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=restore_policy"
  env                             = var.env
  storage_account_name            = "${var.product}finalsa${var.env}"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = var.location
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = var.sa_replication_type
  allow_nested_items_to_be_public = false
  default_action                  = "Allow"
  enable_data_protection          = true
  cors_rules                      = var.cors_rules
  managed_identity_object_id      = data.azurerm_user_assigned_identity.managed_identity.principal_id
  enable_change_feed              = true
  immutable_enabled               = true
  immutability_period             = 100
  private_endpoint_subnet_id      = data.azurerm_subnet.endpoint_subnet.id
  role_assignments = [
    "Storage Blob Data Contributor"
  ]

  common_tags = var.common_tags
}

resource "azurerm_key_vault_secret" "finalsa_storage_account_connection_string" {
  name         = "finalsa-storage-account-connection-string"
  value        = module.finalsa_storage_account.storageaccount_primary_connection_string
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

# For container cleanup operations
resource "azurerm_role_assignment" "powerapp_appreg_final_contrib" {
  scope                = module.finalsa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}

resource "azurerm_monitor_diagnostic_setting" "storageblobfinalsa" {
  name                       = module.finalsa_storage_account.storageaccount_name
  target_resource_id         = "${module.finalsa_storage_account.storageaccount_id}/blobServices/default"
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  log {
    category = "StorageRead"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 14
    }
  }

  log {
    category = "StorageWrite"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 14
    }
  }

  log {
    category = "StorageDelete"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 14
    }
  }

  metric {
    category = "Transaction"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}
