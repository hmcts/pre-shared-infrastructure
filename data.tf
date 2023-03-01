data "azurerm_log_analytics_workspace" "loganalytics" {
  provider            = azurerm.oms
  name                = module.log_analytics_workspace.name
  resource_group_name = module.log_analytics_workspace.resource_group_name
}


data "azurerm_user_assigned_identity" "managed-identity" {
  name                = "${var.product}-stg-mi"
  resource_group_name = "managed-identities-stg-rg"
  depends_on          = [module.key-vault]
}

data "azuread_groups" "groups" {
  display_names = ["DTS-PRE-VideoEditing-SecurityGroup-${var.env}"]
}

data "azuread_groups" "pre-groups" {
  display_names = ["DTS Pre-recorded Evidence"]
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
