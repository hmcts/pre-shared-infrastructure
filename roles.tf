
data "azurerm_user_assigned_identity" "managed-identity" {
  name                = "${var.product}-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"
}

data "azuread_groups" "groups" {
  display_names = ["DTS-PRE-VideoEditing-SecurityGroup-${var.env}"]
}

data "azuread_groups" "pre-groups" {
  display_names = ["DTS Pre-recorded Evidence"]
}

# Give PowerApp Appreg contributor access to resource groups
resource "azurerm_role_assignment" "powerapp_appreg" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = var.dts_pre_ent_appreg_oid
}

# DTS-PRE-VideoEditing-SecurityGroup-
resource "azurerm_role_assignment" "vmuser_login" {
  for_each             = toset(data.azuread_groups.groups.object_ids)
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = each.value
}