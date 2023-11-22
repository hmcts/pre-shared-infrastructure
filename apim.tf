locals {
  app_name      = "pre-ams-integration"
  function_name = "CheckBlobExists"
  env_to_deploy = var.env == "sbox" ? 1 : 0
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

#WIP used toffee for test purposes
module "ams_api" {
  count          = local.env_to_deploy
  source         = "git@github.com:hmcts/cnp-module-api-mgmt-api?ref=master"
  name           = "toffee-recipes-api"
  api_mgmt_rg    = "ss-${var.env}-network-rg"
  api_mgmt_name  = "sds-api-mgmt-${var.env}"
  display_name   = "toffee-recipes"
  revision       = "1"
  product_id     = module.ams_product[0].product_id
  path           = "toffee-recipes-api"
  service_url    = "http://toffee-recipe-backend-${var.env}.service.core-compute-${var.env}.internal"
  swagger_url    = "https://raw.githubusercontent.com/hmcts/cnp-api-docs/master/docs/specs/sds-toffee-recipes-service.json"
  content_format = "openapi+json-link"
}
