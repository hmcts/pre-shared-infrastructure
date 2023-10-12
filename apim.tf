locals {
  app_name = "pre-api"
  # function_name = "CheckBlobExists"
  env_to_deploy = var.env == "sbox" ? 1 : 0
}

data "azurerm_key_vault_secret" "ams_function_key" {
  count        = local.env_to_deploy
  name         = "ams-function-key"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

module "pre_product" {
  count                 = local.env_to_deploy
  source                = "git@github.com:hmcts/cnp-module-api-mgmt-product?ref=master"
  api_mgmt_name         = "sds-api-mgmt-${var.env}"
  api_mgmt_rg           = "ss-${var.env}-network-rg"
  approval_required     = false
  name                  = local.app_name
  published             = true
  subscription_required = false
}

module "pre_api" {
  count          = local.env_to_deploy
  source         = "git@github.com:hmcts/cnp-module-api-mgmt-api?ref=master"
  name           = local.app_name
  api_mgmt_rg    = "ss-${var.env}-network-rg"
  api_mgmt_name  = "sds-api-mgmt-${var.env}"
  display_name   = local.app_name
  revision       = "1"
  product_id     = module.ams_product[0].product_id
  path           = local.app_name
  service_url    = "http://pre-api-{{ .Values.global.environment }}}.service.core-compute-${var.env}.internal"
  swagger_url    = "https://raw.githubusercontent.com/hmcts/cnp-api-docs/master/docs/specs/pre-api.json"
  content_format = "openapi+json-link"
}
