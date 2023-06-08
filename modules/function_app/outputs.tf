output "function_app_id" {
  value = lower(var.os_type) == "windows" ? azurerm_windows_function_app.this[0].id : azurerm_linux_function_app.this[0].id
}

output "function_app_name" {
  value = lower(var.os_type) == "windows" ? azurerm_windows_function_app.this[0].name : azurerm_linux_function_app.this[0].name
}

output "function_app_default_hostname" {
  value = lower(var.os_type) == "windows" ? azurerm_windows_function_app.this[0].default_hostname : azurerm_linux_function_app.this[0].default_hostname
}