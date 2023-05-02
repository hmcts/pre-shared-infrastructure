////////////////////////////////
// DB version 14.4              //
////////////////////////////////

module "data_store_db_v14" {
  providers = {
    azurerm.postgres_network = azurerm.postgres_network
  }

  source = "git@github.com:hmcts/terraform-module-postgresql-flexible.git?ref=master"
  env    = var.env

  product       = var.product
  component     = var.component
  business_area = var.project

  common_tags     = var.common_tags
  name            = var.database_name #-${var.env}" removed as it looks like env gets added in root module
  pgsql_databases = var.pg_databases

  pgsql_version         = "14"
  backup_retention_days = 35

  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  pgsql_admin_username = var.pgsql_admin_username
  pgsql_sku            = var.pgsql_sku
  pgsql_storage_mb     = var.pgsql_storage_mb

  admin_user_object_id = var.jenkins_AAD_objectId

}

provider "azurerm" {
  alias           = "private_dns"
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
  features {}

}

# connect data gateway vnet to private dns zone (this will contain the A name for postgres)
resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dg" {
  provider              = azurerm.private_dns
  name                  = format("%s-%s-virtual-network-link", var.product, var.env)
  resource_group_name   = var.DNSResGroup
  private_dns_zone_name = var.PrivateDNSZone
  virtual_network_id    = azurerm_virtual_network.vnet.id
}