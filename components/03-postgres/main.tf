locals {
  resource_group_name = "${var.prefix}-${var.env}"
}

module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.env
  product     = var.prefix
  builtFrom   = var.builtFrom
}

#role should be assigned already
# DTS-PRE-VideoEditing-SecurityGroup-
resource "azurerm_role_assignment" "vmuser_login" {
  for_each             = toset(data.azuread_groups.groups.object_ids)
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = each.value
}

module "data_store_db_v14" {
  source = "git::https://github.com/hmcts/terraform-module-postgresql-flexible.git?ref=db-collation"
  env    = var.env

  product       = var.prefix
  component     = var.prefix
  business_area = var.project

  common_tags = module.tags.common_tags
  name        = var.database_name
  pgsql_databases = [
    {
      name : "pre-pdb-${var.env}"
    }
  ]

  pgsql_version         = "14"
  backup_retention_days = 35

  location                      = var.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  pgsql_admin_username          = var.pgsql_admin_username
  pgsql_sku                     = var.pgsql_sku
  pgsql_storage_mb              = var.pgsql_storage_mb
  enable_read_only_group_access = false
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
