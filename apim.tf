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
  count                 = local.env_to_deploy
  source                = "git@github.com:hmcts/cnp-module-api-mgmt-api?ref=master"
  name                  = "pre-api"
  api_mgmt_rg           = "ss-${var.env}-network-rg"
  api_mgmt_name         = "sds-api-mgmt-${var.env}"
  display_name          = "Pre Recorded Evidence API"
  revision              = "15"
  product_id            = module.ams_product[0].product_id
  path                  = "pre-api"
  service_url           = var.apim_service_url
  swagger_url           = "https://raw.githubusercontent.com/hmcts/cnp-api-docs/master/docs/specs/pre-api.json"
  content_format        = "openapi+json-link"
  protocols             = ["http", "https"]
  subscription_required = false
}

module "apim_subscription_smoketest" {
  count            = local.env_to_deploy
  sub_display_name = "pre-api smoke test subscription"
  source           = "git@github.com:hmcts/cnp-module-api-mgmt-subscription?ref=master"
  api_mgmt_name    = "sds-api-mgmt-${var.env}"
  api_mgmt_rg      = "ss-${var.env}-network-rg"
  state            = "active"
  allow_tracing    = var.env == "stg" || var.env == "demo" ? true : false
}
resource "azurerm_key_vault_secret" "apim_subscription_smoketest_primary_key" {
  count        = local.env_to_deploy
  name         = "apim-sub-smoketest-primary-key"
  value        = module.apim_subscription_smoketest[0].subscription_primary_key
  key_vault_id = data.azurerm_key_vault.keyvault.id
}
resource "azurerm_key_vault_secret" "apim_subscription_smoketest_secondary_key" {
  count        = local.env_to_deploy
  name         = "apim-sub-smoketest-secondary-key"
  value        = module.apim_subscription_smoketest[0].subscription_secondary_key
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

module "apim_subscription_powerplatform" {
  count            = local.env_to_deploy
  sub_display_name = "PRE Power Platform subscription"
  source           = "git@github.com:hmcts/cnp-module-api-mgmt-subscription?ref=master"
  api_mgmt_name    = "sds-api-mgmt-${var.env}"
  api_mgmt_rg      = "ss-${var.env}-network-rg"
  state            = "active"
  allow_tracing    = var.env == "stg" || var.env == "demo" ? true : false
}
resource "azurerm_key_vault_secret" "apim_subscription_powerplatform_primary_key" {
  count        = local.env_to_deploy
  name         = "apim-sub-powerplatform-primary-key"
  value        = module.apim_subscription_powerplatform[0].subscription_primary_key
  key_vault_id = data.azurerm_key_vault.keyvault.id
}
resource "azurerm_key_vault_secret" "apim_subscription_powerplatform_secondary_key" {
  count        = local.env_to_deploy
  name         = "apim-sub-powerplatform-secondary-key"
  value        = module.apim_subscription_powerplatform[0].subscription_secondary_key
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

module "pre-api-mgmt-api-policy" {
  count         = local.env_to_deploy
  source        = "git@github.com:hmcts/cnp-module-api-mgmt-api-policy?ref=master"
  api_name      = module.ams_api[0].name
  api_mgmt_name = "sds-api-mgmt-${var.env}"
  api_mgmt_rg   = "ss-${var.env}-network-rg"

  api_policy_xml_content = <<XML
<policies>
    <inbound>
        <base />
        <set-backend-service base-url="${var.apim_service_url}" />
        <cors allow-credentials="false">
            <allowed-origins>
                <origin>*</origin>
            </allowed-origins>
            <allowed-methods>
                <method>*</method>
            </allowed-methods>
            <allowed-headers>
                <header>*</header>
            </allowed-headers>
        </cors>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

#to be removed
resource "azurerm_key_vault_secret" "subscription_smoketest_primary_key" {
  count        = local.env_to_deploy
  name         = "apim-sub-smoketest-primary-key"
  value        = module.apim_subscription_smoketest[0].subscription_primary_key
  key_vault_id = data.azurerm_key_vault.key_vault.id
}
resource "azurerm_key_vault_secret" "subscription_smoketest_secondary_key" {
  count        = local.env_to_deploy
  name         = "apim-sub-smoketest-secondary-key"
  value        = module.apim_subscription_smoketest[0].subscription_secondary_key
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "subscription_powerplatform_primary_key" {
  count        = local.env_to_deploy
  name         = "apim-sub-powerplatform-primary-key"
  value        = module.apim_subscription_powerplatform[0].subscription_primary_key
  key_vault_id = data.azurerm_key_vault.key_vault.id
}
resource "azurerm_key_vault_secret" "subscription_powerplatform_secondary_key" {
  count        = local.env_to_deploy
  name         = "apim-sub-powerplatform-secondary-key"
  value        = module.apim_subscription_powerplatform[0].subscription_secondary_key
  key_vault_id = data.azurerm_key_vault.key_vault.id
}