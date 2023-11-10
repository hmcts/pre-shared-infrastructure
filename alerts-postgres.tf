resource "azurerm_monitor_metric_alert" "postgres_alert_active_connections" {
  count               = var.env == "sbox" ? 1 : 0
  name                = "postgres_active_connections_greater_than_80_percent"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.data_store_db_v14.instance_id]
  description         = "Whenever the maximum active connections is greater than 80%"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "active_connections"
    aggregation      = "Average"
    operator         = "GreaterThanOrEqual"
    threshold        = 200
  }
  window_size = "PT30M"
  frequency   = "PT5M"
  action {
    action_group_id = azurerm_monitor_action_group.pre-support.id
  }
}

resource "azurerm_monitor_metric_alert" "postgres_alert_failed_connections" {
  count               = var.env == "sbox" ? 1 : 0
  name                = "postgres_failed_connections_greater_than_10"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.data_store_db_v14.instance_id]
  description         = "Whenever the maximum failed connections is greater than 10"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "connections_failed"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 10
  }
  window_size = "PT30M"
  frequency   = "PT5M"
  action {
    action_group_id = azurerm_monitor_action_group.pre-support.id
  }
}

resource "azurerm_monitor_metric_alert" "postgres_alert_cpu" {
  count               = var.env == "sbox" ? 1 : 0
  name                = "postgres_cpu_percent_95"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.data_store_db_v14.instance_id]
  description         = "Whenever the cpu utilization is greater than 95"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 95
  }
  window_size = "PT30M"
  frequency   = "PT5M"
  action {
    action_group_id = azurerm_monitor_action_group.pre-support.id
  }
}

resource "azurerm_monitor_metric_alert" "postgres_alert_memory" {
  count               = var.env == "sbox" ? 1 : 0
  name                = "postgres_memory_percent_95"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.data_store_db_v14.instance_id]
  description         = "Whenever the memory utilization is greater than 95"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "memory_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 95
  }
  window_size = "PT30M"
  frequency   = "PT5M"
  action {
    action_group_id = azurerm_monitor_action_group.pre-support.id
  }
}

resource "azurerm_monitor_metric_alert" "postgres_alert_io_utilization" {
  count               = var.env == "sbox" ? 1 : 0
  name                = "postgres_io_utilization_90"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.data_store_db_v14.instance_id]
  description         = "Whenever the io utilization is greater than 90"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "io_consumption_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 95
  }
  window_size = "PT1H"
  frequency   = "PT5M"
  action {
    action_group_id = azurerm_monitor_action_group.pre-support.id
  }
}

resource "azurerm_monitor_metric_alert" "postgres_alert_storage_utilization" {
  count               = var.env == "sbox" ? 1 : 0
  name                = "postgres_storage_utilization_90"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.data_store_db_v14.instance_id]
  description         = "Whenever the storage utilization is greater than 90"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "storage_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }
  action {
    action_group_id = azurerm_monitor_action_group.pre-support.id
  }
}