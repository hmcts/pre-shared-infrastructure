locals {
  app_name      = "pre-api"
  env_to_deploy = var.env != "prod" ? 1 : 0
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
  name           = "pre-api"
  api_mgmt_rg    = "ss-${var.env}-network-rg"
  api_mgmt_name  = "sds-api-mgmt-${var.env}"
  display_name   = "Pre Recorded Evidence API"
  revision       = "3"
  product_id     = module.ams_product[0].product_id
  path           = "pre-api"
  service_url    = "http://pre-api-${var.env}.service.core-compute-${var.env}.internal"
  swagger_url    = "https://raw.githubusercontent.com/hmcts/cnp-api-docs/master/docs/specs/pre-api.json"
  content_format = "openapi+json-link"
}