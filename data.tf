data "azurerm_subscription" "current" {}


data "azurerm_client_config" "current" {}

data "azuread_application" "appreg" {
  display_name = "dts_pre_${var.env}"
}
data "azurerm_log_analytics_workspace" "loganalytics" {
  provider            = azurerm.oms
  name                = module.log_analytics_workspace.name
  resource_group_name = module.log_analytics_workspace.resource_group_name
}

data "azurerm_user_assigned_identity" "managed-identity" {
  name                = "${var.product}-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"
}

data "azuread_groups" "groups" {
  display_names = ["DTS-PRE-VideoEditing-SecurityGroup-${var.env}"]
}

data "azurerm_subnet" "jenkins_subnet" {
  provider             = azurerm.mgmt
  name                 = "iaas"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}


# adding this to allow postgres pipeline agent located on ss-ptlsbox-vnet to access keyvault
data "azurerm_subnet" "pipelineagent_subnet" {
  provider             = azurerm.mgmt
  name                 = "aks-00"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}