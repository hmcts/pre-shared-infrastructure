locals {
  resource_group_name = "${var.prefix}-${var.env}"
}
module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.env
  product     = var.prefix
  builtFrom   = var.builtFrom
}

module "data_store_db_v14" {
  source = "git::https://github.com/hmcts/terraform-module-postgresql-flexible.git?ref=master"
  env    = var.env

  product       = var.prefix
  component     = var.product
  business_area = var.project

  common_tags     = module.tags.common_tags
  name            = var.database_name #-${var.env}" removed as it looks like env gets added in root module
  pgsql_databases = var.pg_databases

  pgsql_version         = "14"
  backup_retention_days = 35

  location             = var.location
  resource_group_name  = data.azurerm_resource_group.rg.id
  pgsql_admin_username = var.pgsql_admin_username
  pgsql_sku            = var.pgsql_sku
  pgsql_storage_mb     = var.pgsql_storage_mb

  admin_user_object_id = data.azurerm_client_config.current.object_id

}

data "azurerm_key_vault" "keyvault" {
  name                = var.env == "prod" ? "${var.prefix}-hmctskv-${var.env}" : "${var.prefix}-${var.env}" #module.key-vault.key_vault_name
  resource_group_name = data.azurerm_resource_group.rg.id
}

#using own var for this
resource "azurerm_key_vault_secret" "POSTGRES_USER" {
  name         = "postgresdb-username"
  value        = var.pgsql_admin_username
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

#https://github.com/hmcts/terraform-module-postgresql-flexible/blob/master/outputs.tf
resource "azurerm_key_vault_secret" "POSTGRES_PASS" {
  name         = "postgresdb-password"
  value        = module.data_store_db_v14.password
  key_vault_id = data.azurerm_key_vault.keyvault.id
}
