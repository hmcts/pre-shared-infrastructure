module "data_store_db_v14" {
  providers = {
    azurerm.postgres_network = azurerm.postgres_network
  }

  source = "git@github.com:hmcts/terraform-module-postgresql-flexible.git?ref=master"
  env    = var.env

  product       = var.product
  component     = var.product
  business_area = var.project

  common_tags = var.common_tags
  name        = var.database_name
  pgsql_databases = [
    {
      name : "pre-pdb-${var.env}"
    },
    {
      name : "api"
    }
  ]

  pgsql_version         = "14"
  backup_retention_days = 35

  location             = var.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  pgsql_admin_username = var.pgsql_admin_username
  pgsql_storage_mb     = var.pgsql_storage_mb

  admin_user_object_id = var.jenkins_AAD_objectId

}

# @todo remove once we have switched PowerApps to use the API
resource "azurerm_key_vault_secret" "POSTGRES_HOST" {
  name         = "postgresdb-host"
  value        = module.data_store_db_v14.fqdn
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

# @todo remove once we have switched PowerApps to use the API
resource "azurerm_key_vault_secret" "POSTGRES_USER" {
  name         = "postgresdb-username"
  value        = var.pgsql_admin_username
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

#https://github.com/hmcts/terraform-module-postgresql-flexible/blob/master/outputs.tf
# @todo remove once we have switched PowerApps to use the API
resource "azurerm_key_vault_secret" "POSTGRES_PASS" {
  name         = "postgresdb-password"
  value        = module.data_store_db_v14.password
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

# Needed by the Common Pipeline db migration step
resource "azurerm_key_vault_secret" "POSTGRES_HOST" {
  name         = "api-POSTGRES-HOST"
  value        = module.data_store_db_v14.fqdn
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

# Not returned by the module outputs but needed for the pipeline migration step so hardcoding
resource "azurerm_key_vault_secret" "POSTGRES_PORT" {
  name         = "api-POSTGRES-PORT"
  value        = "5432"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

# Not returned by the module outputs but needed for the pipeline migration step so hardcoding
resource "azurerm_key_vault_secret" "POSTGRES_DATABASE" {
  name         = "api-POSTGRES-DATABASE"
  value        = "api"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "POSTGRES_USER" {
  name         = "api-POSTGRES-USER"
  value        = var.pgsql_admin_username
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

#https://github.com/hmcts/terraform-module-postgresql-flexible/blob/master/outputs.tf
resource "azurerm_key_vault_secret" "POSTGRES_PASS" {
  name         = "api-POSTGRES-PASS"
  value        = module.data_store_db_v14.password
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_monitor_metric_alert" "postgres_alert_active_connections" {
  count               = var.env == "prod" ? 1 : 0
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
  window_size = "P1D"
  frequency   = "PT1H"
  action {
    action_group_id = azurerm_monitor_action_group.pre-support[count.index].id
  }
}

resource "azurerm_monitor_metric_alert" "postgres_alert_failed_connections" {
  count               = var.env == "prod" ? 1 : 0
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
  window_size = "P1D"
  frequency   = "PT1H"
  action {
    action_group_id = azurerm_monitor_action_group.pre-support[count.index].id
  }
}

resource "azurerm_monitor_metric_alert" "postgres_alert_cpu" {
  count               = var.env == "prod" ? 1 : 0
  name                = "postgres_cpu_percent_95"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.data_store_db_v14.instance_id]
  description         = "Whenever the cpu utilization is greater than 95"
  frequency           = "PT1H"
  window_size         = "P1D"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 95
  }
  action {
    action_group_id = azurerm_monitor_action_group.pre-support[count.index].id
  }
}

resource "azurerm_monitor_metric_alert" "postgres_alert_memory" {
  count               = var.env == "prod" ? 1 : 0
  name                = "postgres_memory_percent_95"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.data_store_db_v14.instance_id]
  description         = "Whenever the memory utilization is greater than 95"
  frequency           = "PT1H"
  window_size         = "P1D"

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "memory_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 95
  }
  action {
    action_group_id = azurerm_monitor_action_group.pre-support[count.index].id
  }
}

resource "azurerm_monitor_metric_alert" "postgres_alert_storage_utilization" {
  count               = var.env == "prod" ? 1 : 0
  name                = "postgres_storage_utilization_90"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [module.data_store_db_v14.instance_id]
  description         = "Whenever the storage utilization is greater than 90"
  frequency           = "PT1H"
  window_size         = "P1D"
  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "storage_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }
  action {
    action_group_id = azurerm_monitor_action_group.pre-support[count.index].id
  }
}