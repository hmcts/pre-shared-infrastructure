module "ingestsa_storage_account" {
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
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
  restore_policy_days             = var.restore_policy_days
  enable_change_feed              = true
  managed_identity_object_id      = data.azurerm_user_assigned_identity.managed_identity.principal_id
  private_endpoint_subnet_id      = data.azurerm_subnet.endpoint_subnet.id
  role_assignments = [
    "Storage Blob Data Contributor"
  ]

  common_tags = var.common_tags
}

resource "azurerm_key_vault_secret" "ingestsa_storage_account_connection_string" {
  name            = "ingestsa-storage-account-connection-string"
  value           = module.ingestsa_storage_account.storageaccount_primary_connection_string
  key_vault_id    = data.azurerm_key_vault.keyvault.id
  expiration_date = timeadd(timestamp(), "8760h")

  lifecycle {
    ignore_changes = [
      expiration_date
    ]
  }
}

resource "azurerm_role_assignment" "powerapp_appreg_ingest_contrib" {
  scope                = module.ingestsa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.dts_pre_backup_appreg_oid
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
  }
  metric {
    category = "Capacity"
    enabled  = false
  }
}

resource "azurerm_monitor_metric_alert" "storage_ingest_alert_capacity" {
  count               = var.env == "prod" ? 1 : 0
  name                = "used_capacity"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.ingestsa_storage_account.storageaccount_id]
  description         = "When the used storage capacity is over 4TiB"
  frequency           = "PT1H"
  window_size         = "P1D"

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