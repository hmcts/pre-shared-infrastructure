data "azurerm_client_config" "current" {}

module "key-vault" {
  source                     = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  product                    = var.product
  env                        = var.env
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  object_id                  = var.jenkins_AAD_objectId
  resource_group_name        = azurerm_resource_group.rg.name
  product_group_name         = "DTS Pre-recorded Evidence"
  common_tags                = var.common_tags
  create_managed_identity    = true
}

// VM credentials


output "vaultName" {
  value = module.key-vault.key_vault_name
}
