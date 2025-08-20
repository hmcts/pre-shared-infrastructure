import {
  for_each = var.env == "stg" ? toset(["import"]) : toset([])
  to       = module.data_store_db_v14.azurerm_postgresql_flexible_server_database.pg_databases["pre-pdb-stg"]
  id       = "/subscriptions/74dacd4f-a248-45bb-a2f0-af700dc4cf68/resourceGroups/pre-stg/providers/Microsoft.DBforPostgreSQL/flexibleServers/pre-db-stg/databases/pre-pdb-stg"
}

import {
  to = module.data_store_db_v14.azurerm_postgresql_flexible_server_database.pg_databases["api"]
  id = "/subscriptions/74dacd4f-a248-45bb-a2f0-af700dc4cf68/resourceGroups/pre-stg/providers/Microsoft.DBforPostgreSQL/flexibleServers/pre-db-stg/databases/api"
}

import {
  to = module.data_store_db_v14.azurerm_postgresql_flexible_server_active_directory_administrator.pgsql_adadmin
  id = "/subscriptions/74dacd4f-a248-45bb-a2f0-af700dc4cf68/resourceGroups/pre-stg/providers/Microsoft.DBforPostgreSQL/flexibleServers/pre-db-stg/administrators/e7ea2042-4ced-45dd-8ae3-e051c6551789"
}

import {
  to = module.data_store_db_v14.azurerm_postgresql_flexible_server_active_directory_administrator.pgsql_principal_admin[0]
  id = "/subscriptions/74dacd4f-a248-45bb-a2f0-af700dc4cf68/resourceGroups/pre-stg/providers/Microsoft.DBforPostgreSQL/flexibleServers/pre-db-stg/administrators/7ef3b6ce-3974-41ab-8512-c3ef4bb8ae01"
}
