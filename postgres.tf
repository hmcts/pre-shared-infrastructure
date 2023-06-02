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
    }
  ]

  pgsql_version         = "14"
  backup_retention_days = 35

  location             = var.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  pgsql_admin_username = var.pgsql_admin_username
  pgsql_sku            = var.pgsql_sku
  pgsql_storage_mb     = var.pgsql_storage_mb

  admin_user_object_id = var.jenkins_AAD_objectId

}

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
resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dg" {
  provider              = azurerm.private_dns
  name                  = format("%s-%s-virtual-network-link", var.product, var.env)
  resource_group_name   = var.dns_resource_group
  private_dns_zone_name = var.private_dns_zone
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}
