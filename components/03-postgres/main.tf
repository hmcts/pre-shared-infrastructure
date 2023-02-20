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
  source = "git::https://github.com/zc-hmcts/terraform-module-postgresql-flexible.git?ref=spaces"
  env    = var.env

  product       = var.prefix
  component     = var.prefix
  business_area = var.project

  common_tags     = module.tags.common_tags
  name            = var.database_name
  pgsql_databases = var.pg_databases

  pgsql_version         = "14"
  backup_retention_days = 35

  location             = var.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  pgsql_admin_username = var.pgsql_admin_username
  pgsql_sku            = var.pgsql_sku
  pgsql_storage_mb     = var.pgsql_storage_mb

  admin_user_object_id = "11a86dfb-2183-4f42-ac53-9952bd31d0fb" # data.azurerm_client_config.current.object_id # "7ef3b6ce-3974-41ab-8512-c3ef4bb8ae01" #data.azurerm_client_config.current.object_id #"7ef3b6ce-3974-41ab-8512-c3ef4bb8ae01" #var.dts_pre_ent_appreg_oid #"dad693c4-36ad-468f-94e9-76faa4bc844b" #"9168b884-7ccd-4e71-860f-7f63455818e1" #"f6991ff8-d675-4f54-b2ba-99af86a8e01c" #"53790b85-0d6d-4146-af63-398ddfa61cac" #"d8c74776-764e-4b2a-8f8b-acacec87b9b7" # dcd_sp_ado_mgmt_operations_v2 # data.azurerm_client_config.current.object_id #"ca6d5085-485a-417d-8480-c3cefa29df31"
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

# connect data gateway vnet to private dns zone (this will contain the A name for postgres)	
# resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dg" {
#   provider              = azurerm.private_dns
#   name                  = format("%s-%s-virtual-network-link", var.prefix, var.env)
#   resource_group_name   = var.DNSResGroup
#   private_dns_zone_name = var.PrivateDNSZone
#   virtual_network_id    = data.azurerm_virtual_network.vnet.id
# }

# module "log_analytics_workspace" {
#   source      = "git::https://github.com/hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
#   environment = var.env
# }
