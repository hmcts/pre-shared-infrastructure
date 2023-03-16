

module "video_test" {
  #    source  =  "git@github.com:hmcts/pre-module-terraform-function-app.git?ref=master"
  #   source = "./modules"
  source              = "git@github.com:hmcts/pre-shared-infrastructure//modules?ref=preview"
  os_type             = "Windows"
  product             = var.product
  create_service_plan = true

  resource_group_name = data.azurerm_resource_group.rg.name
  name                = "pre-video-dev"
  location            = var.location
  worker_count        = 1
  common_tags         = var.common_tags
  app_settings = {
    "ACCOUNTKEY" = ""
    "ALGO"       = "['RS256']"
    #"APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.example.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = ""
    "AZURE_CLIENT_ID"                       = data.azurerm_client_config.current.client_id
    "AZURE_MEDIA_SERVICES_ACCOUNT_NAME"     = "preams${var.env}"
    "AZURE_STORAGE_ACCOUNT_NAME"            = "prefinalsa${var.env}"
    "AZURE_TENANT_ID"                       = data.azurerm_client_config.current.tenant_id
    "AzureWebJobsStorage"                   = ""
    "FUNCTIONS_EXTENSION_VERSION"           = ""
    "FUNCTIONS_WORKER_RUNTIME"              = ""
    "AppSecret"                             = ""
    "ApplicationId"                         = ""

    # "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = ""
    # "WEBSITE_CONTENTSHARE"     = ""
    # "WEBSITE_RUN_FROM_PACKAGE" = ""
  }

  storage_account_name = module.ingestsa_storage_account.storageaccount_name
  storage_account_key  = module.ingestsa_storage_account.storageaccount_primary_access_key
}

resource "azurerm_function_app_function" "api" {
  name            = "API"
  function_app_id = module.ams_function_app.function_app_id

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

resource "azurerm_function_app_function" "DownloadFile" {
  name            = "DownloadFile"
  function_app_id = module.ams_function_app.function_app_id

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

resource "azurerm_function_app_function" "EditingOrchestrator" {
  name            = "EditingOrchestrator"
  function_app_id = module.ams_function_app.function_app_id

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


resource "azurerm_function_app_function" "EditVideo" {
  name            = "EditVideo"
  function_app_id = module.ams_function_app.function_app_id

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

resource "azurerm_function_app_function" "HttpTriggerAMS" {
  name            = "HttpTriggerAMS"
  function_app_id = module.ams_function_app.function_app_id

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

resource "azurerm_function_app_function" "HttpTriggerAMS2" {
  name            = "HttpTriggerAMS2"
  function_app_id = module.ams_function_app.function_app_id

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

resource "azurerm_function_app_function" "UploadFile" {
  name            = "UploadFile"
  function_app_id = module.ams_function_app.function_app_id

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
