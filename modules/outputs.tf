output "function_app_id" {
  value = lower(var.os_type) == "windows" ?   azurerm_windows_function_app.this.id : azurerm_linux_function_app.this.id
}

output "function_app_default_hostname" {
  value = lower(var.os_type) == "windows" ?  azurerm_windows_function_app.this.default_hostname : azurerm_linux_function_app.this.default_hostname
}