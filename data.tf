data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "loganalytics" {
  provider            = azurerm.oms
  name                = module.log_analytics_workspace.name
  resource_group_name = module.log_analytics_workspace.resource_group_name
}

data "azurerm_key_vault" "keyvault" {
  name                = var.env == "prod" ? "${var.product}-hmctskv-${var.env}" : "${var.product}-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_user_assigned_identity" "managed_identity" {
  name                = "${var.product}-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"
}

data "azuread_group" "edit_group" {
  display_name = "DTS-PRE-VideoEditing-SecurityGroup-${var.env}"
}

data "azurerm_subnet" "jenkins_subnet" {
  provider             = azurerm.mgmt
  name                 = "iaas"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

# allow postgres pipeline agent located on ss-ptlsbox-vnet to access keyvault
data "azurerm_subnet" "pipelineagent_subnet" {
  provider             = azurerm.mgmt
  name                 = "aks-00"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_resource_group" "rg" {
  name = "${var.product}-${var.env}"
}

data "azurerm_virtual_network" "vnet" {
  name                = var.env == "dev" ? "${var.product}-vnet-${var.env}" : "${var.product}-vnet01-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
}
data "azurerm_subnet" "endpoint_subnet" {
  name                 = "${var.product}-privatendpt-snet-${var.env}"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

data "azurerm_subnet" "videoedit_subnet" {
  name                 = var.env == "dev" ? "${var.product}-videoedit-snet-${var.env}" : "${var.product}-videoeditvm-snet-${var.env}"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

data "azurerm_subnet" "datagateway_subnet" {
  name                 = "${var.product}-datagateway-snet-${var.env}"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

### Dynatrace
data "azurerm_key_vault_secret" "dynatrace-token" {
  name         = "dynatrace-token"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "dynatrace-tenant-id" {
  name         = "dynatrace-tenant-id"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

# data "azurerm_disk_encryption_set" "pre-des" {
#   name                = "pre-des"
#   resource_group_name = data.azurerm_resource_group.rg.name
# }

# data "azurerm_key_vault_secret" "edit_username" {
#   count        = var.num_vid_edit_vms
#   name         = "videditvm${count.index}-username"
#   key_vault_id = data.azurerm_key_vault.keyvault.id
# }
# data "azurerm_key_vault_secret" "edit_password" {
#   count        = var.num_vid_edit_vms
#   name         = "videditvm${count.index}-password"
#   key_vault_id = data.azurerm_key_vault.keyvault.id
# }

# data "azurerm_key_vault_secret" "dtgtwy_username" {
#   count        = var.num_datagateway
#   name         = "Dtgtwy${count.index}-username"
#   key_vault_id = data.azurerm_key_vault.keyvault.id
# }
# data "azurerm_key_vault_secret" "dtgtwy_password" {
#   count        = var.num_datagateway
#   name         = "Dtgtwy${count.index}-password"
#   key_vault_id = data.azurerm_key_vault.keyvault.id
# }

data "azurerm_subscription" "current" {}

data "azurerm_key_vault_secret" "symmetrickey" {
  name         = "symmetrickey"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}