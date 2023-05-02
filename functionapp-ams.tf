# data "azurerm_key_vault_secret" "sa_key" {
#   name         = "ams-sa-key"
#   key_vault_id = data.azurerm_key_vault.keyvault.id
# }

# data "azurerm_key_vault_secret" "symmetrickey" {
#   name         = "symmetrickey"
#   key_vault_id = data.azurerm_key_vault.keyvault.id
# }

# data "azurerm_key_vault_secret" "client_secret" {
#   name         = "client-secret"
#   key_vault_id = data.azurerm_key_vault.keyvault.id
# }

data "azurerm_subscription" "current" {}

module "ams_function_app" {
  source              = "git@github.com:hmcts/pre-shared-infrastructure.git//modules/function_app?ref=preview"
  os_type             = "Linux"
  product             = var.product
  create_service_plan = true

  resource_group_name = azurerm_resource_group.rg.name
  name                = "pre-ams-integration"
  location            = var.location
  common_tags         = var.common_tags
  env                 = var.env

  # app_insights_key = azurerm_application_insights.appinsight.instrumentation_key
  app_settings = {
    "ALGO"                              = "['RS256']"
    "AZURE_CLIENT_ID"                   = "${var.pre_ent_appreg_app_id}"
    "AZURE_MEDIA_SERVICES_ACCOUNT_NAME" = "preams${var.env}"
    "AZURE_TENANT_ID"                   = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
    # "SYMMETRICKEY"                      = "${data.azurerm_key_vault_secret.symmetrickey.value}"
    "ISSUER"                = "https://sts.windows.net/531ff96d-0ae9-462a-8d2d-bec7c0b42082/"
    "JWKSURI"               = "https://login.microsoftonline.com/common/discovery/keys"
    "AUDIENCE"              = "api://${var.pre_ent_appreg_app_id}"
    "SCOPE"                 = "api://${var.pre_ent_appreg_app_id}/.default"
    "CONTENTPOLICYKEYNAME"  = "PolicyWithClearKeyOptionAndJwtTokenRestriction"
    "STREAMINGPOLICYNAME"   = "PreStreamingPolicy"
    "TOKENENDPOINT"         = "https://login.microsoftonline.com/531ff96d-0ae9-462a-8d2d-bec7c0b42082/oauth2/token"
    "AZURE_RESOURCE_GROUP"  = "pre-${var.env}"
    "AZURE_SUBSCRIPTION_ID" = "${data.azurerm_subscription.current.subscription_id}"
    # "AZURE_STORAGE_ACCOUNT_KEY"         = "${data.azurerm_key_vault_secret.sa_key.value}"
    # "AZURE_CLIENT_SECRET"               = "${data.azurerm_key_vault_secret.client_secret.value}"
  }
}