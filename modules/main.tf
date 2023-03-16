resource "azurerm_service_plan" "this" {
  name                = "${var.product}-asp-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type #"Windows"
  sku_name            = "Y1"
  worker_count        = var.worker_count
  # zone_balancing_enabled = true

  tags = var.common_tags
}

resource "azurerm_windows_function_app" "this" {
  count               = var.os_type == "windows" ? 1 : 0
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_key #azurerm_storage_account.this.primary_access_key
  service_plan_id            = azurerm_service_plan.this.id

  app_settings = var.app_settings
  https_only   = true

  tags = var.common_tags

  site_config {}
}

resource "azurerm_linux_function_app" "this" {
  count               = var.os_type == "linux" ? 1 : 0
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_key
  service_plan_id            = azurerm_service_plan.this.id

  app_settings = var.app_settings
  https_only   = true

  tags = var.common_tags

  site_config {}
}

# resource "azurerm_linux_function_app_slot" "this" {
#   name                 = "${var.name}-slot"
#   function_app_id      = azurerm_linux_function_app.this.id
#   storage_account_name = var.storage_account_name

#   site_config {}
# }

# resource "azurerm_windows_function_app_slot" "this" {
#   name                 = "${var.name}-slot"
#   function_app_id      = azurerm_windows_function_app.this.id
#   storage_account_name = var.storage_account_name

#   site_config {}
# }