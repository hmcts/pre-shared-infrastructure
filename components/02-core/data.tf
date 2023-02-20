data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "loganalytics" {
  provider            = azurerm.oms
  name                = module.log_analytics_workspace.name
  resource_group_name = module.log_analytics_workspace.resource_group_name
}

data "azurerm_user_assigned_identity" "managed-identity" {
  name                = "${var.prefix}-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"

  depends_on = [module.key-vault]
}

# data "azuread_groups" "groups" {
#   display_names = ["DTS-PRE-VideoEditing-SecurityGroup-${var.env}"]
# }

# data "azuread_groups" "pre-groups" {
#   display_names = ["DTS Pre-recorded Evidence"]
# }

# data "azurerm_key_vault" "keyvault" {
#   name                = var.env == "prod" ? "${var.prefix}-hmctskv-${var.env}" : "${var.prefix}-${var.env}" #module.key-vault.key_vault_name
#   resource_group_name = data.azurerm_resource_group.rg.name
# }

# # Dynatrace
# data "azurerm_key_vault_secret" "dynatrace-token" {
#   name         = "dynatrace-token"
#   key_vault_id = module.key-vault.key_vault_id
# }

# data "azurerm_key_vault_secret" "dynatrace-tenant-id" {
#   name         = "dynatrace-tenant-id"
#   key_vault_id = module.key-vault.key_vault_id
# }


data "azurerm_resource_group" "rg" {
  name = local.resource_group_name
}

output "id" {
  value = data.azurerm_resource_group.rg.id
}

data "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.vnet.id
}

data "azurerm_subnet" "endpoint_subnet" {
  name                 = "${var.prefix}-privatendpt-snet-${var.env}"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

data "azurerm_subnet" "videoedit_subnet" {
  name                 = "${var.prefix}-videoedit-snet-${var.env}"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

data "azurerm_subnet" "datagateway_subnet" {
  name                 = "${var.prefix}-datagateway-snet-${var.env}"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}
