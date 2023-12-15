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
  revision       = "5"
  product_id     = module.ams_product[0].product_id
  path           = "pre-api"
  service_url    = var.apim_service_url
  swagger_url    = "https://raw.githubusercontent.com/hmcts/cnp-api-docs/master/docs/specs/pre-api.json"
  content_format = "openapi+json-link"
  protocols      = ["http", "https"]
}

module "cnp-module-api-mgmt-api-policy" {
    api_mgmt_name = "sds-api-mgmt-${var.env}"
    api_mgmt_rg = "ss-${var.env}-network-rg"
    api_name = "pre-api"
    api_policy_xml_content = <<XML
<policies>
  <inbound>
    <cors>
        <allowed-origins>
            <origin>https://flow.microsoft.com</origin>
        </allowed-origins>
        <allowed-methods>
            <method>*</method>
        </allowed-methods>
        <allowed-headers>
            <header>*</header>
        </allowed-headers>
    </cors>
  </inbound>
</policies>
XML
}