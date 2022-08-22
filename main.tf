locals {
  prefix              = "${var.product}-${var.env}"
  resource_group_name = "${local.prefix}"
  key_vault_name      = "${var.product}-kv-${var.env}"
  env_long_name       = var.env == "sbox" ? "sandbox" : var.env == "stg" ? "staging" : var.env
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.common_tags
  
}

# resource "azurerm_resource_group" "rg" {
#   count = var.env == "sbox" ? 2 : 1
#   name     = var.env == "sbox" ? local.resource_group_name-00${count.index} : local.resource_group_name
#   location = var.location
#   tags     = var.common_tags
# }


# resource "azurerm_resource_group" "rg2" {
#   count = 2  
#   name     = "${var.product}-rg00-${count.index}-${var.env}"
#   location = var.location
#   tags     = var.common_tags
# }
#Role Assignment for Managed Identity
# resource "azurerm_role_assignment" "pre_managedidentity" {
#   scope                            = azurerm_resource_group.rg.id
#   role_definition_name             = "Storage Blob Data Contributor"
#   principal_id                     = var.pre_mi_principal_id
#   skip_service_principal_aad_check = true
# }
# Object ID: d055ba21-5814-4278-8752-aaffa7eaac62

    # "properties": {  "name": "pre-sbox-mi",
    #     "tenantId": "531ff96d-0ae9-462a-8d2d-bec7c0b42082",
    #     "principalId": "eb4aa503-5ffa-49ef-a69d-221e90eaf236",
    #     "clientId": "fbdb4489-f3dd-4762-a32c-8ccb680691c6"


