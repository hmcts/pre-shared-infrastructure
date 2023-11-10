resource "azurerm_monitor_metric_alert" "vm_alert_cpu_utilization" {
  count               = var.env == "sbox" ? 1 : 0
  name                = "vm_cpu_utilization_80"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.data_store_db_v14.instance_id]
  description         = "Whenever the cpu utilization is greater than 80"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }
  action {
    action_group_id = azurerm_monitor_action_group.pre-support.id
  }
}

resource "azurerm_monitor_metric_alert" "vm_alert_availability" {
  count               = var.env == "sbox" ? 1 : 0
  name                = "vm_availability"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = module.edit_vm.vm_name
  description         = "Whenever the vm is unavailabile"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "availability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1
  }
  action {
    action_group_id = azurerm_monitor_action_group.pre-support.id
  }
}

resource "azurerm_monitor_metric_alert" "vm_alert_memory" {
  count               = var.env == "sbox" ? 1 : 0
  name                = "vm_memory_percent_95"
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
