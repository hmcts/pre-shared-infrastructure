module "timestamp_function_app" {
  source              = "git@github.com:hmcts/pre-shared-infrastructure.git//modules/function_app?ref=preview"
  os_type             = "Windows"
  product             = var.product
  create_service_plan = true

  resource_group_name = data.azurerm_resource_group.rg.name
  name                = "pre-timestamp-mgmt"
  location            = var.location
  common_tags         = var.common_tags
  env                 = var.env

  # app_insights_key = azurerm_application_insights.appinsight.instrumentation_key
  app_settings = {}
}
