module "log_analytics_workspace" {
  source      = "git::https://github.com/hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
  environment = var.env
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