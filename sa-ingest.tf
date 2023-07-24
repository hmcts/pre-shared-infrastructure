module "ingestsa_storage_account" {
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=restore_policy"
  env                             = var.env
  storage_account_name            = "${var.product}ingestsa${var.env}"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = var.location
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = var.sa_replication_type
  allow_nested_items_to_be_public = false
  default_action                  = "Allow"
  enable_data_protection          = true
  managed_identity_object_id      = data.azurerm_user_assigned_identity.managed_identity.principal_id
  private_endpoint_subnet_id      = data.azurerm_subnet.endpoint_subnet.id
  role_assignments = [
    "Storage Blob Data Contributor"
  ]

  common_tags = var.common_tags
  depends_on  = [module.key-vault, module.vnet_peer_to_hub]
}

resource "azurerm_key_vault_secret" "ingestsa_storage_account_connection_string" {
  name         = "ingestsa-storage-account-connection-string"
  value        = module.ingestsa_storage_account.storageaccount_primary_connection_string
  key_vault_id = module.key-vault.key_vault_id
}

resource "azurerm_monitor_diagnostic_setting" "storageblobingestsa" {
  name                       = module.ingestsa_storage_account.storageaccount_name
  target_resource_id         = "${module.ingestsa_storage_account.storageaccount_id}/blobServices/default"
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  metric {
    category = "Capacity"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
}