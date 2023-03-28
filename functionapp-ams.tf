
module "ams_function_app" {
  source              = "git@github.com:hmcts/pre-shared-infrastructure.git//modules/function_app?ref=preview"
  os_type             = "Linux"
  product             = var.product
  create_service_plan = true

  resource_group_name = data.azurerm_resource_group.rg.name
  name                = "pre-ams-integration"
  location            = var.location
  common_tags         = var.common_tags
  env                 = var.env

  # app_insights_key = azurerm_application_insights.appinsight.instrumentation_key
  app_settings = {
    # "ACCOUNTKEY" = ""
    # "ALGO"       = "['RS256']"
    #"APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.example.instrumentation_key
    # "APPLICATIONINSIGHTS_CONNECTION_STRING" = ""
    # "AZURE_CLIENT_ID"                       = "7394ca1a-31de-4433-beca-2ca1a2043d5c"
    # "AZURE_MEDIA_SERVICES_ACCOUNT_NAME"     = "preams${var.env}"
    # "AZURE_STORAGE_ACCOUNT_NAME"            = "prefinalsa${var.env}"
    ApplicationInsightsAgent_EXTENSION_VERSION = "~2"
    "AZURE_TENANT_ID"                          = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
    "AzureWebJobsStorage"                      = "${module.sa_storage_account.storageaccount_primary_connection_string}"
    # "DRMSYMMETRICKEY"                       = ""
    "FUNCTIONS_EXTENSION_VERSION" = "~4"
    "FUNCTIONS_WORKER_RUNTIME"    = "node"
    # "ISSUER"                                = "https://sts.windows.net/531ff96d-0ae9-462a-8d2d-bec7c0b42082/"
    # "JWKSURI"                               = "https://login.microsoftonline.com/common/discovery/keys"
    # "SCOPE"                                 = "api://7394ca1a-31de-4433-beca-2ca1a2043d5c/.default"
    # "TOKENENDPOINT"                         = "https://login.microsoftonline.com/531ff96d-0ae9-462a-8d2d-bec7c0b42082/oauth2/v2.0/token"
    # "TOKENSIGNINGKEY"                       = ""
    # "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = "${module.finalsa_storage_account.storageaccount_primary_connection_string}"
    # "WEBSITE_CONTENTSHARE"     = ""
    # "WEBSITE_RUN_FROM_PACKAGE" = ""
  }

  storage_account_name = module.sa_storage_account.storageaccount_name
  storage_account_key  = module.sa_storage_account.storageaccount_primary_access_key
}

resource "azurerm_storage_account" "zc_storage" {
  name                            = "zcstoragedev"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  tags                            = var.common_tags
  allow_nested_items_to_be_public = false
}

module "zc_function_app" {
  source              = "git@github.com:hmcts/pre-shared-infrastructure.git//modules/function_app?ref=preview"
  os_type             = "Windows"
  product             = var.product
  create_service_plan = true

  resource_group_name = data.azurerm_resource_group.rg.name
  name                = "zc-function-app"
  location            = var.location
  common_tags         = var.common_tags
  env                 = var.env

  # app_insights_key = azurerm_application_insights.appinsight.instrumentation_key
  app_settings = {}

  storage_account_name = azurerm_storage_account.zc_storage.storageaccount_name
  storage_account_key  = azurerm_storage_account.zc_storage.storageaccount_primary_access_key
}

# resource "azurerm_function_app_function" "content_key_policy" {
#   name            = "CreateContentKeyPolicy"
#   function_app_id = module.ams_function_app.function_app_id
#   #   language        = "Javascript"

#   #   file {
#   #     name    = "run.js"
#   #     content = file("exampledata/run.js")
#   #   }


#   #   test_data = jsonencode({
#   #     "name" = "Azure"
#   #   })
#   config_json = jsonencode({
#     "bindings" = [
#       {
#         "authLevel" = "function"
#         "direction" = "in"
#         "methods" = [
#           "get",
#           "post",
#         ]
#         "name" = "req"
#         "type" = "httpTrigger"
#       },
#       {
#         "direction" = "out"
#         "name"      = "$return"
#         "type"      = "http"
#       },
#     ]
#   })
# }

# resource "azurerm_function_app_function" "sas_url" {
#   name            = "getSasUrl"
#   function_app_id = module.ams_function_app.function_app_id
#   #   language        = "Javascript"

#   #   file {
#   #     name    = "run.js"
#   #     content = file("exampledata/run.js")
#   #   }


#   #   test_data = jsonencode({
#   #     "name" = "Azure"
#   #   })
#   config_json = jsonencode({
#     "bindings" = [
#       {
#         "authLevel" = "function"
#         "direction" = "in"
#         "methods" = [
#           "get",
#           "post",
#         ]
#         "name" = "req"
#         "type" = "httpTrigger"
#       },
#       {
#         "direction" = "out"
#         "name"      = "$return"
#         "type"      = "http"
#       },
#     ]
#   })
# }

# resource "azurerm_function_app_function" "streaming_url" {
#   name            = "GetStreamingUrl"
#   function_app_id = module.ams_function_app.function_app_id
#   #   language        = "Javascript"

#   #   file {
#   #     name    = "run.js"
#   #     content = file("exampledata/run.js")
#   #   }


#   #   test_data = jsonencode({
#   #     "name" = "Azure"
#   #   })
#   config_json = jsonencode({
#     "bindings" = [
#       {
#         "authLevel" = "function"
#         "direction" = "in"
#         "methods" = [
#           "get",
#           "post",
#         ]
#         "name" = "req"
#         "type" = "httpTrigger"
#       },
#       {
#         "direction" = "out"
#         "name"      = "$return"
#         "type"      = "http"
#       },
#     ]
#   })
# }

# resource "azurerm_function_app_function" "token" {
#   name            = "getToken"
#   function_app_id = module.ams_function_app.function_app_id
#   #   language        = "Javascript"
#   #   test_data = jsonencode({
#   #     "name" = "Azure"
#   #   })

#   #   file {
#   #     name    = "run.js"
#   #     content = file("exampledata/run.js")
#   #   }


#   config_json = jsonencode({
#     "bindings" = [
#       {
#         "authLevel" = "function"
#         "direction" = "in"
#         "methods" = [
#           "get",
#           "post",
#         ]
#         "name" = "req"
#         "type" = "httpTrigger"
#       },
#       {
#         "direction" = "out"
#         "name"      = "$return"
#         "type"      = "http"
#       },
#     ]
#   })
# }

# resource "azurerm_function_app_function" "list_container_assets" {
#   name            = "listContainerAssets"
#   function_app_id = module.ams_function_app.function_app_id
#   #   language        = "Javascript"

#   #   file {
#   #     name    = "run.js"
#   #     content = file("exampledata/run.js")
#   #   }

#   #   test_data = jsonencode({
#   #     "name" = "Azure"
#   #   })
#   config_json = jsonencode({
#     "bindings" = [
#       {
#         "authLevel" = "function"
#         "direction" = "in"
#         "methods" = [
#           "get",
#           "post",
#         ]
#         "name" = "req"
#         "type" = "httpTrigger"
#       },
#       {
#         "direction" = "out"
#         "name"      = "$return"
#         "type"      = "http"
#       },
#     ]
#   })
# }

# resource "azurerm_function_app_function" "list_containers" {
#   name            = "listContainers"
#   function_app_id = module.ams_function_app.function_app_id
#   #   language        = "Javascript"

#   #   file {
#   #     name    = "run.js"
#   #     content = file("exampledata/run.js")
#   #   }

#   #   test_data = jsonencode({
#   #     "name" = "Azure"
#   #   })
#   config_json = jsonencode({
#     "bindings" = [
#       {
#         "authLevel" = "function"
#         "direction" = "in"
#         "methods" = [
#           "get",
#           "post",
#         ]
#         "name" = "req"
#         "type" = "httpTrigger"
#       },
#       {
#         "direction" = "out"
#         "name"      = "$return"
#         "type"      = "http"
#       },
#     ]
#   })
# }

# resource "azurerm_function_app_function" "play_ready_content" {
#   name            = "PlayReadyContent"
#   function_app_id = module.ams_function_app.function_app_id
#   #   language        = "Javascript"

#   #   file {
#   #     name    = "run.js"
#   #     content = file("exampledata/run.js")
#   #   }

#   #   test_data = jsonencode({
#   #     "name" = "Azure"
#   #   })
#   config_json = jsonencode({
#     "bindings" = [
#       {
#         "authLevel" = "function"
#         "direction" = "in"
#         "methods" = [
#           "get",
#           "post",
#         ]
#         "name" = "req"
#         "type" = "httpTrigger"
#       },
#       {
#         "direction" = "out"
#         "name"      = "$return"
#         "type"      = "http"
#       },
#     ]
#   })
# }

# resource "azurerm_function_app_function" "verify_token" {
#   name            = "verifyToken"
#   function_app_id = module.ams_function_app.function_app_id
#   #   language        = "Javascript"

#   #   file {
#   #     name    = "run.js"
#   #     content = file("exampledata/run.js")
#   #   }


#   #   test_data = jsonencode({
#   #     "name" = "Azure"
#   #   })
#   config_json = jsonencode({
#     "bindings" = [
#       {
#         "authLevel" = "function"
#         "direction" = "in"
#         "methods" = [
#           "get",
#           "post",
#         ]
#         "name" = "req"
#         "type" = "httpTrigger"
#       },
#       {
#         "direction" = "out"
#         "name"      = "$return"
#         "type"      = "http"
#       },
#     ]
#   })
# }