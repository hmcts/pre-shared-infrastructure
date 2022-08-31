locals {
#   key_vault_name = "module.key-vault.key_vault_name"
  sa_list        = toset(["sa_storage_account.storage_account_name", "finalsa_storage_account.storage_account_name", "ingestsa_storage_account"])
}

# resource "azurerm_automation_account" "hmi_automation" {
#   name                = var.name
#   location            = var.location
#   resource_group_name = var.resource_group
#   sku_name            = var.automation_account_sku_name

#   identity {
#     type = "SystemAssigned"
#   }

#   tags = var.common_tags
# }

data "azurerm_storage_account" "sa" {
  for_each            = local.sa_list
  name                = each.value
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "aa_to_sa" {
  for_each             = { for i in local.sa_list : i => data.azurerm_storage_account.sa[i].id }
  scope                = each.value
  role_definition_name = "Contributor"
  principal_id         = azurerm_automation_account.pre-aa.identity.0.principal_id
}

module "automation_runbook_sas_token_renewal" {
#   for_each             = var.sas_tokens
  source               = "git::https://github.com/hmcts/cnp-module-automation-runbook-sas-token-renewal?ref=master"

  name                 = "rotate-sas-tokens-${each.value.storage_account}"
  resource_group_name  = azurerm_resource_group.rg.name
 
  environment          = var.env

  storage_account_name = each.value.storage_account
#   container_name       = each.value.container
#   blob_name            = each.value.blob

  key_vault_name       = module.key-vault.key_vault_name
  secret_name          = "${var.product}-${each.value.storage_account}-sas"

  expiry_date          = timeadd(timestamp(), "24h") #each.value.expiry_date

  automation_account_name = azurerm_automation_account.pre-aa.identity.name

  tags = var.common_tags

}