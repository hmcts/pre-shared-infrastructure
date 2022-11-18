
////////////////////////////////
// DB version 14.4              //
////////////////////////////////

module "data_store_db_v14" {
  source = "git@github.com:hmcts/terraform-module-postgresql-flexible.git?ref=master"
  env    = var.env

  product   = var.product
  component = var.component
  project   = var.project

  common_tags     = var.common_tags
  name            = var.database_name #-${var.env}" removed as it looks like env gets added in root module
  pgsql_databases = var.pg_databases

  pgsql_version             = "14"
  backup_retention_days     = 35

  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  pgsql_admin_username = var.pgsql_admin_username
  pgsql_sku            = var.pgsql_sku
  pgsql_storage_mb     = var.pgsql_storage_mb

}

////////////////////////////////
// Populate Vault with DB info (the password is output from the module, the username is a standard var)
////////////////////////////////

#take this from input as no output for this value
resource "azurerm_key_vault_secret" "POSTGRES_USER" {
  name         = "${var.component}-POSTGRES_USER"
  value        = var.pgsql_admin_username
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

#https://github.com/hmcts/terraform-module-postgresql-flexible/blob/master/outputs.tf
resource "azurerm_key_vault_secret" "POSTGRES_PASS" {
  name         = "${var.component}-POSTGRES_PASS"
  value        = module.data_store_db_v14.password
  key_vault_id = data.azurerm_key_vault.keyvault.id
}
