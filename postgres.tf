
# Get the key vault (removing as this has been declared elsewhere)
#data "azurerm_key_vault" "keyvault" {
#  name                = var.env == "prod" ? "${var.product}-hmctskv-${var.env}" : "${var.product}-${var.env}" #module.key-vault.key_vault_name
#  resource_group_name = azurerm_resource_group.rg.name
#}

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
  source = "git@github.com:hmcts/terraform-module-postgresql-flexible.git?ref=master"
  env    = var.env

  product   = var.product
  component = var.component
  project   = var.project

  common_tags     = var.common_tags
  name            = var.database_name #-${var.env}" removed as it looks like env gets added in root module
  pgsql_databases = var.pg_databases

  pgsql_delegated_subnet_id = data.azurerm_subnet.ss_subnet_pre_postgresql.id
  pgsql_version             = "14"
  backup_retention_days     = 35

  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  pgsql_admin_username = var.pgsql_admin_username
  pgsql_sku            = var.pgsql_sku
  pgsql_storage_mb     = var.pgsql_storage_mb
  #zone                 = var.zone #removed as getting error so can't be a valid param

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

#remove section below, cannot use private endpoints with postgres flexi server, replace with routing and peering
// Private endpoint for postgres in platops resource group
#resource "azurerm_private_endpoint" "endpoint" {
#  name                = format("%s-%s-private-endpoint", var.product, var.env)
#  location            = var.location
#  resource_group_name = data.azurerm_resource_group.ss_resource_group.name
#  subnet_id           = data.azurerm_subnet.ss_subnet_pre_postgresql.id

#  private_service_connection {
#    name                           = format("%s-%s-privateserviceconnection", var.product, var.env)
#    private_connection_resource_id = module.data-store-db-v14.instance_id #output from https://github.com/hmcts/terraform-module-postgresql-flexible/blob/master/outputs.tf
#    is_manual_connection           = false
#    subresource_names              = ["postgresqlServer"]
#  }
#  tags = var.common_tags
#}

#resource "azurerm_private_dns_a_record" "dns_a" {
#  provider            = azurerm.DNS
#  name                = format("%s-%s-postgres-privlink", var.product, var.env)
#  zone_name           = var.PrivateDNSZone
#  resource_group_name = var.DNSResGroup
#  ttl                 = 10
#  records             = [azurerm_private_endpoint.endpoint.private_service_connection.0.private_ip_address]
#}

# route table to route traffic to postgres subnet
resource "azurerm_route_table" "postgres" {
  name                          = format("%s-%s-route-table", var.product, var.env)
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false

  route {
    name           = "route1"
    address_prefix = data.azurerm_subnet.ss_subnet_pre_postgresql.address_prefixes
    next_hop_type  = "VnetLocal"
  }

  tags = var.common_tags
}

# Link route table with data gateway subnet
resource "azurerm_subnet_route_table_association" "dg_subnet" {
  subnet_id      = azurerm_subnet.datagateway_subnet.id
  route_table_id = azurerm_route_table.postgres.id
}

# vnet peering data gateway and postgres
resource "azurerm_virtual_network_peering" "dg_postgres" {
  name                      = format("%s-%s-peer-dg-to-postgres", var.product, var.env)
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.ss_vnet.id
}

# connect data gateway vnet to private dns zone (this will contain the A name for postgres)
resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dg" {
  name                  = format("%s-%s-virtual-network-link", var.product, var.env)
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = var.PrivateDNSZone
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

# Get IP from FQDN of postgres flexi server
data "dns_a_record_set" "postgres" {
  host = module.data-store-db-v14.fqdn
}

#output "postgres_addrs" {
#  value = join(",", data.dns_a_record_set.postgres.addrs)
#  depends_on          = [module.data-store-db-v14]
#}

# Add the A record for postgres
resource "azurerm_private_dns_a_record" "dns_a" {
  provider            = azurerm.DNS
  name                = format("%s-%s", var.database_name, var.env)
  zone_name           = var.PrivateDNSZone
  resource_group_name = var.DNSResGroup
  ttl                 = 10
  records             = data.dns_a_record_set.postgres.addrs
  #depends_on          = [module.data-store-db-v14]
}
