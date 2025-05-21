module "sa_storage_account" {
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=4.x"
  env                             = var.env
  storage_account_name            = "${var.product}sa${var.env}"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = var.sa_replication_type
  allow_nested_items_to_be_public = true
  default_action                  = "Allow"
  enable_data_protection          = true
  restore_policy_days             = var.restore_policy_days
  enable_change_feed              = true
  managed_identity_object_id      = data.azurerm_user_assigned_identity.managed_identity.principal_id
  sa_subnets                      = concat([data.azurerm_subnet.jenkins_subnet.id], [data.azurerm_subnet.endpoint_subnet.id], [data.azurerm_subnet.videoedit_subnet.id])
  containers                      = local.containers
  cors_rules = [{
    allowed_headers    = ["*"]
    allowed_methods    = ["GET", "OPTIONS"]
    allowed_origins    = ["https://hmcts${var.env}extid.b2clogin.com"]
    exposed_headers    = ["*"]
    max_age_in_seconds = 200
  }]

  role_assignments = [
    "Storage Blob Data Contributor"
  ]

  common_tags = var.common_tags
}

# Store the connection string for the SAs in KV
resource "azurerm_key_vault_secret" "sa_storage_account_connection_string" {
  name         = "sa-storage-account-connection-string"
  value        = module.sa_storage_account.storageaccount_primary_connection_string
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_monitor_diagnostic_setting" "storageblobsa" {
  name                       = module.sa_storage_account.storageaccount_name
  target_resource_id         = "${module.sa_storage_account.storageaccount_id}/blobServices/default"
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id
  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
  }
  metric {
    category = "Capacity"
    enabled  = false
  }
}

resource "azurerm_storage_blob" "b2c_config" {
  for_each               = local.b2c_content_files
  name                   = "${each.value.relative_path}/${each.value.name}"
  content_type           = each.value.content_type
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source_content         = each.value.content

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_config_assets" {
  for_each               = local.b2c_asset_files
  name                   = "${each.value.relative_path}/${each.value.name}"
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = each.value.path
  content_type           = each.value.content_type
  content_md5            = each.value.content_md5

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_config_maps" {
  for_each               = local.b2c_map_files
  name                   = "${each.value.relative_path}/${each.value.name}"
  content_type           = each.value.content_type
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source_content         = each.value.content

  depends_on = [module.sa_storage_account]
}

resource "azurerm_storage_blob" "b2c_html_file" {
  for_each               = local.b2c_html_files
  name                   = each.value.name
  content_type           = each.value.content_type
  storage_account_name   = module.sa_storage_account.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"

  source_content = each.value.content

  depends_on = [module.sa_storage_account]
}
