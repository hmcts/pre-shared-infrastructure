module "finalsa_storage_account" {
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=4.x"
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
  immutable_enabled               = var.env == "dev" ? true : false
  immutability_period             = 100
  restore_policy_days             = var.env == "dev" ? null : var.restore_policy_days
  cors_rules                      = var.cors_rules
  managed_identity_object_id      = data.azurerm_user_assigned_identity.managed_identity.principal_id
  enable_change_feed              = true
  private_endpoint_subnet_id      = data.azurerm_subnet.endpoint_subnet.id
  public_network_access_enabled   = false
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

resource "azurerm_key_vault_secret" "finalsa_storage_account_primary_access_key" {
  name         = "finalsa-storage-account-primary-access-key"
  value        = module.finalsa_storage_account.storageaccount_primary_access_key
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

# For container cleanup operations
resource "azurerm_role_assignment" "powerapp_appreg_final_contrib" {
  scope                = module.finalsa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
}

# For SC team members
resource "azurerm_role_assignment" "sc_team_members_final_readers" {
  count                = var.env == "prod" ? 1 : 0
  scope                = module.finalsa_storage_account.storageaccount_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = data.azuread_group.prod_reader_group.object_id
}

resource "azurerm_monitor_diagnostic_setting" "storageblobfinalsa" {
  name                       = module.finalsa_storage_account.storageaccount_name
  target_resource_id         = "${module.finalsa_storage_account.storageaccount_id}/blobServices/default"
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
  }
  metric {
    category = "Capacity"
    enabled  = false
  }
}

resource "azurerm_monitor_metric_alert" "storage_final_alert_capacity" {
  count               = var.env == "prod" ? 1 : 0
  name                = "used_capacity"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.finalsa_storage_account.storageaccount_id]
  description         = "When the used storage capacity is over 4TiB"
  frequency           = "PT1H"
  window_size         = "P1D"

  tags = var.common_tags

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "UsedCapacity"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 4398046511104 # 4 TiB in bytes (1 TiB = 2^40 bytes)
  }
  action {
    action_group_id = azurerm_monitor_action_group.pre-support[count.index].id
  }
}
