module "log_analytics_workspace" {
  source      = "git::https://github.com/hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
  environment = var.env
}

data "azurerm_log_analytics_workspace" "loganalytics" {
  provider            = azurerm.oms
  name                = module.log_analytics_workspace.name
  resource_group_name = module.log_analytics_workspace.resource_group_name
}

resource "azurerm_monitor_diagnostic_setting" "bastion" {
  name                       = azurerm_bastion_host.bastion.name
  target_resource_id         = azurerm_bastion_host.bastion.id
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  log {
    category = "BastionAuditLogs"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "bastionpip" {
  name                       = azurerm_public_ip.pip.name
  target_resource_id         = azurerm_public_ip.pip.id
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  log {
    category = "DDoSProtectionNotifications"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
  log {
    category = "DDoSMitigationFlowLogs"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
  log {
    category = "DDoSMitigationReports"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "nic" {
  count                      = var.num_vid_edit_vms
  name                       = azurerm_network_interface.nic[count.index].name
  target_resource_id         = azurerm_network_interface.nic[count.index].id
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
}
