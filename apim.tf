locals {
  app_name      = "pre-ams-integration"
  function_name = "CheckBlobExists"
  env_to_deploy = var.env == "sbox" ? 1 : 0
}

data "azurerm_key_vault_secret" "ams_function_key" {
  count        = local.env_to_deploy
  name         = "ams-function-key"
  key_vault_id = module.key-vault.key_vault_id
}
module "ams_product" {
  count                 = local.env_to_deploy
  source                = "git@github.com:hmcts/cnp-module-api-mgmt-product?ref=master"
  api_mgmt_name         = "sds-api-mgmt-${var.env}"
  api_mgmt_rg           = "ss-${var.env}-network-rg"
  approval_required     = false
  name                  = local.app_name
  published             = true
  subscription_required = false
}

module "ams_api" {
  count          = local.env_to_deploy
  source         = "git@github.com:hmcts/cnp-module-api-mgmt-api?ref=master"
  name           = "${local.app_name}-api"
  api_mgmt_rg    = "ss-${var.env}-network-rg"
  api_mgmt_name  = "sds-api-mgmt-${var.env}"
  display_name   = "PRE AMS Integration API"
  revision       = "1"
  product_id     = module.ams_product[0].product_id
  path           = "${local.app_name}-api"
  service_url    = null
  swagger_url    = "https://${local.app_name}-${var.env}.azurewebsites.net/api/${local.function_name}?code=${data.azurerm_key_vault_secret.ams_function_key[0].value}"
  content_format = "swagger-link-json"
}

# module "ams_policy" {
#   source        = "git@github.com:hmcts/cnp-module-api-mgmt-api-policy?ref=master"
#   api_mgmt_name = "sds-api-mgmt-${var.env}"
#   api_mgmt_rg   = "ss-${var.env}-network-rg"
#   api_name      = module.ams_api.name
#   # api_policy_xml_content = local.api_policy
# }
