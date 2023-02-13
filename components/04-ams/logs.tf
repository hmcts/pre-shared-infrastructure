module "log_analytics_workspace" {
  source      = "git::https://github.com/hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
  environment = var.env
}

resource "azurerm_monitor_diagnostic_setting" "ams_1" {
  name                       = azurerm_media_services_account.ams.name
  target_resource_id         = azurerm_media_services_account.ams.id
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  log {
    category = "MediaAccount"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
  log {
    category = "KeyDeliveryRequests"
    enabled  = true
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
}