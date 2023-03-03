module "finalsa_storage_account" {
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=private-endpoint"
  env                             = var.env
  storage_account_name            = replace("${var.product}finalsa${var.env}", "-", "")
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location #"UKWest" #As recommended by MS
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = var.sa_replication_type
  sa_subnets                      = concat([data.azurerm_subnet.jenkins_subnet.id], [azurerm_subnet.endpoint_subnet.id], [azurerm_subnet.datagateway_subnet.id], [azurerm_subnet.videoeditvm_subnet.id])
  allow_nested_items_to_be_public = false
  ip_rules                        = var.ip_rules
  default_action                  = "Deny"
  enable_data_protection          = true
  cors_rules                      = var.cors_rules
  managed_identity_object_id      = data.azurerm_user_assigned_identity.managed-identity.principal_id
  private_endpoint_enabled        = true
  role_assignments = [
    "Storage Blob Data Contributor"
  ]


  common_tags = var.common_tags
  depends_on  = [module.key-vault]
}

# resource "azurerm_private_endpoint" "finalsa" {
#   name                = "${var.product}finalsa-pe-${var.env}"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   subnet_id           = azurerm_subnet.endpoint_subnet.id

#   private_service_connection {
#     name                           = "${var.product}finalsa-psc-${var.env}"
#     is_manual_connection           = false
#     private_connection_resource_id = module.finalsa_storage_account.storageaccount_id
#     subresource_names              = ["blob"]
#   }
#   tags = var.common_tags
# }

resource "azurerm_key_vault_secret" "finalsa_storage_account_connection_string" {
  name         = "finalsa-storage-account-connection-string"
  value        = module.finalsa_storage_account.storageaccount_primary_connection_string
  key_vault_id = module.key-vault.key_vault_id
}


resource "azurerm_monitor_diagnostic_setting" "storageblobfinalsa" {
  name                       = module.finalsa_storage_account.storageaccount_name
  target_resource_id         = "${module.finalsa_storage_account.storageaccount_id}/blobServices/default"
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  log {
    category = "StorageRead"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "StorageWrite"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "StorageDelete"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "Transaction"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }
}
