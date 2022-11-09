
# Get the key vault
data "azurerm_key_vault" "keyvault" {
  name                = var.env == "prod" ? "${var.product}-hmctskv-${var.env}" : "${var.product}-${var.env}" #module.key-vault.key_vault_name
  resource_group_name = azurerm_resource_group.rg.name
}

////////////////////////////////
// Populate Vault with DB info (the password is output from the module, the username is a standard var)
////////////////////////////////

#take this from input as no output for this value
resource "azurerm_key_vault_secret" "POSTGRES-USER" {
  name         = "${var.component}-POSTGRES-USER"
  value        = var.pgsql_admin_username
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

#https://github.com/hmcts/terraform-module-postgresql-flexible/blob/master/outputs.tf
resource "azurerm_key_vault_secret" "POSTGRES-PASS" {
  name         = "${var.component}-POSTGRES-PASS"
  value        = module.data-store-db-v14.password
  key_vault_id = data.azurerm_key_vault.keyvault.id
}




////////////////////////////////
// DB version 14.4              //
////////////////////////////////

module "data-store-db-v14" {
  source = "git@github.com:hmcts/terraform-module-postgresql-flexible?ref=master"
  env    = var.env

  product   = var.product
  component = var.component
  project   = var.project

  common_tags     = var.common_tags
  name            = "${var.database_name}-${var.env}"
  pgsql_databases = var.pg_databases

  pgsql_delegated_subnet_id = data.azurerm_subnet.ss_subnet_pre_postgresql.id
  pgsql_version             = "14.4"
  backup_retention_days     = 35

  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  pgsql_admin_username = var.pgsql_admin_username
  pgsql_sku            = var.pgsql_sku
  pgsql_storage_mb     = var.pgsql_storage_mb
  zone                 = var.zone

  #subscription       = var.subscription this gets interpolated
  # high availability built in. var.zone sets the primary

}

// Resource Group (for using the platops networks below)
data "azurerm_resource_group" "ss_resource_group" {
  name = format("ss-%s-network-rg", var.env)
}

// Virtual Network (platops shared service)
data "azurerm_virtual_network" "ss_vnet" {
  name                = format("ss-%s-vnet", var.env)
  resource_group_name = data.azurerm_resource_group.ss_resource_group.name
}

data "azurerm_subnet" "ss_subnet_pre_postgresql" {
  name                 = "postgresql"
  virtual_network_name = data.azurerm_virtual_network.ss_vnet.name
  resource_group_name  = data.azurerm_resource_group.ss_resource_group.name
}

// Private endpoint for postgres in platops resource group
resource "azurerm_private_endpoint" "endpoint" {
  name                = format("%s-%s-private-endpoint", var.product, var.env)
  location            = var.location
  resource_group_name = data.azurerm_resource_group.ss_resource_group.name
  subnet_id           = data.azurerm_subnet.ss_subnet_pre_postgresql.id
}
