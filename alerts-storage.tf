resource "azurerm_monitor_metric_alert" "storage_final_alert_capacity" {
  count               = var.env == "prod" || var.env == "sbox" ? 1 : 0
  name                = "used_capacity"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.finalsa_storage_account.storageaccount_id]
  description         = "When the used storage capacity is over 4TiB"
  frequency           = "PT1H"
  window_size         = "P1D"

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "UsedCapacity"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 4294967296 # 4 TiB in bytes (1 TiB = 2^40 bytes)
  }
  action {
    action_group_id = azurerm_monitor_action_group.pre-support[count.index].id
  }
}

resource "azurerm_monitor_metric_alert" "storage_ingest_alert_capacity" {
  count               = var.env == "prod" || var.env == "sbox" ? 1 : 0
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
    threshold        = 4294967296 # 4 TiB in bytes (1 TiB = 2^40 bytes)
  }
  action {
    action_group_id = azurerm_monitor_action_group.pre-support[count.index].id
  }
}