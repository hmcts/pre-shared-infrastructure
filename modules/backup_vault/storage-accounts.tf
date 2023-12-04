module "storage_account_backup" {
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = "${local.storageaccount_names}backup${var.env}"
  resource_group_name             = azurerm_resource_group.this.name
  location                        = var.location_backup
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = "LRS"
  sa_subnets                      = var.sa_subnets
  allow_nested_items_to_be_public = false
  default_action                  = "Allow"
  enable_data_protection          = false #cannot be true as restore policy conflicts with immutability
  immutable_enabled               = true
  immutability_period             = var.immutability_period_backup

  common_tags = var.common_tags
}

# Give the appreg (managed application in local directory) OID Storage Blob Data Contributor role on both the storage account and backup storage account
resource "azurerm_role_assignment" "powerapp_appreg" {
  scope                = module.storage_account_backup.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.service_principal
}

resource "azurerm_role_assignment" "powerapp_appreg_backup" {
  scope                = module.storage_account_backup.storageaccount_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.service_principal
}

resource "azurerm_role_assignment" "powerapp_appreg_contrib" {
  scope                = module.storage_account_backup.storageaccount_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.service_principal
}