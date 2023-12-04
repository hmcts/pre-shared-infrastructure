output "resource_group_name" {
  value       = azurerm_resource_group.this.name
  description = "The backup resource group Resource ID."
}

output "resource_group_id" {
  value       = azurerm_resource_group.this.id
  description = "The backup resource group name."
}

output "storageaccount_id" {
  value       = module.storage_account_backup.storageaccount_id
  description = "The backup storage account id."
}