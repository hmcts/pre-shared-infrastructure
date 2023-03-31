# data "azurerm_key_vault_secret" "sa_key" {
#   name         = "ams-sa-key"
#   key_vault_id = data.azurerm_key_vault.keyvault.id
# }

data "azurerm_key_vault_secret" "symmetrickey" {
  name         = "symmetrickey"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "client_secret" {
  name         = "client-secret"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

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
    "ALGO"                              = "['RS256']"
    "AZURE_CLIENT_ID"                   = "${var.pre_ent_appreg_app_id}"
    "AZURE_MEDIA_SERVICES_ACCOUNT_NAME" = "preams${var.env}"
    "AZURE_TENANT_ID"                   = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
    "SYMMETRICKEY"                      = "${data.azurerm_key_vault_secret.symmetrickey}"
    "ISSUER"                            = "https://sts.windows.net/531ff96d-0ae9-462a-8d2d-bec7c0b42082/"
    "JWKSURI"                           = "https://login.microsoftonline.com/common/discovery/keys"
    "AUDIENCE"                          = "api://${var.pre_ent_appreg_app_id}"
    "SCOPE"                             = "api://${var.pre_ent_appreg_app_id}/.default"
    "CONTENTPOLICYKEYNAME"              = "PolicyWithClearKeyOptionAndJwtTokenRestriction"
    "STREAMINGPOLICYNAME"               = "PreStreamingPolicy"
    "TOKENENDPOINT"                     = "https://login.microsoftonline.com/531ff96d-0ae9-462a-8d2d-bec7c0b42082/oauth2/token"
    "AZURE_RESOURCE_GROUP"              = "pre-${var.env}"
    "AZURE_SUBSCRIPTION_ID"             = "${data.azurerm_subscriptions.current.id}"
    # "AZURE_STORAGE_ACCOUNT_KEY"         = ""
    "AZURE_CLIENT_SECRET" = "${data.azurerm_key_vault_secret.client_secret}"
  }
}

# module "zc_function_app" {
#   source              = "git@github.com:hmcts/pre-shared-infrastructure.git//modules/function_app?ref=preview"
#   os_type             = "Windows"
#   product             = var.product
#   create_service_plan = true

#   resource_group_name = data.azurerm_resource_group.rg.name
#   name                = "zc-function-app"
#   location            = var.location
#   common_tags         = var.common_tags
#   env                 = var.env

#   # app_insights_key = azurerm_application_insights.appinsight.instrumentation_key
#   app_settings = {}
# }

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