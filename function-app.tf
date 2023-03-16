
module "ams_function_app" {
  source  = "./modules/function_app"
  os_type = "Linux"
  product = var.product

  resource_group_name = data.azurerm_resource_group.rg.name
  name                = "pre-ams-integration"
  location            = var.location

  app_settings = {
    "ACCOUNTKEY" = ""
    "ALGO"            = "['RS256']"
    #"APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.example.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = ""
    "AZURE_CLIENT_ID" = data.azurerm_client_config.current.client_id
    "AZURE_MEDIA_SERVICES_ACCOUNT_NAME" = "preams${var.env}"
    "AZURE_STORAGE_ACCOUNT_NAME"        = "prefinalsa${var.env}"
    "AZURE_TENANT_ID"                   = data.azurerm_client_config.current.tenant_id
    "AzureWebJobsStorage" = ""
    "DRMSYMMETRICKEY" = ""
    "FUNCTIONS_EXTENSION_VERSION" = ""
    "FUNCTIONS_WORKER_RUNTIME" = ""
    "ISSUER" = ""
    "JWKSURI" = ""
    "SCOPE" = ""
    "TOKENENDPOINT" = ""
    "TOKENSIGNINGKEY" = ""
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = ""
    "WEBSITE_CONTENTSHARE" = ""
    "WEBSITE_RUN_FROM_PACKAGE" = ""
  }

  storage_account_name = module.ingestsa_storage_account.storageaccount_name
  storage_account_key  = module.ingestsa_storage_account.storageaccount_primary_access_key
}

resource "azurerm_function_app_function" "content_key_policy" {
  name            = "CreateContentKeyPolicy"
  function_app_id = module.ams_function_app.function_app_id
  language        = "Javascript"
#   test_data = jsonencode({
#     "name" = "Azure"
#   })
  config_json = jsonencode({
    "bindings" = [
      {
        "authLevel" = "function"
        "direction" = "in"
        "methods" = [
          "get",
          "post",
        ]
        "name" = "req"
        "type" = "httpTrigger"
      },
      {
        "direction" = "out"
        "name"      = "$return"
        "type"      = "http"
      },
    ]
  })
}

resource "azurerm_function_app_function" "get_sas_url" {
  name            = "getSasUrl"
  function_app_id = module.ams_function_app.function_app_id
  language        = "Javascript"
#   test_data = jsonencode({
#     "name" = "Azure"
#   })
  config_json = jsonencode({
    "bindings" = [
      {
        "authLevel" = "function"
        "direction" = "in"
        "methods" = [
          "get",
          "post",
        ]
        "name" = "req"
        "type" = "httpTrigger"
      },
      {
        "direction" = "out"
        "name"      = "$return"
        "type"      = "http"
      },
    ]
  })
}

resource "azurerm_function_app_function" "get_streaming_url" {
  name            = "GetStreamingUrl"
  function_app_id = module.ams_function_app.function_app_id
  language        = "Javascript"
#   test_data = jsonencode({
#     "name" = "Azure"
#   })
  config_json = jsonencode({
    "bindings" = [
      {
        "authLevel" = "function"
        "direction" = "in"
        "methods" = [
          "get",
          "post",
        ]
        "name" = "req"
        "type" = "httpTrigger"
      },
      {
        "direction" = "out"
        "name"      = "$return"
        "type"      = "http"
      },
    ]
  })
}
