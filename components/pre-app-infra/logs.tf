data "azurerm_log_analytics_workspace" "loganalytics" {
  provider            = azurerm.oms
  name                = module.log_analytics_workspace.name
  resource_group_name = module.log_analytics_workspace.resource_group_name
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
resource "azurerm_monitor_diagnostic_setting" "vnet" {

  name                       = azurerm_virtual_network.vnet.name
  target_resource_id         = azurerm_virtual_network.vnet.id
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  log {
    category = "VMProtectionAlerts"

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

resource "azurerm_monitor_diagnostic_setting" "storageblobfinalsa" {
  name                       = module.finalsa_storage_account.storageaccount_name
  target_resource_id         = "${module.finalsa_storage_account.storageaccount_id}/blobServices/default"
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


resource "azurerm_monitor_diagnostic_setting" "storageblobingestsa" {
  name                       = module.ingestsa_storage_account.storageaccount_name
  target_resource_id         = "${module.ingestsa_storage_account.storageaccount_id}/blobServices/default"
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

module "log_analytics_workspace" {
  source      = "git::https://github.com/hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
  environment = var.env
}
