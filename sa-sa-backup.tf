module "sa_storage_account_backup" {
  count                           = var.env == "prod" || var.env == "test" ? 1 : 0
  source                          = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                             = var.env
  storage_account_name            = "${var.product}sabackup${var.env}"
  resource_group_name             = module.backup_vault[0].resource_group_name
  location                        = var.location_backup
  account_kind                    = "StorageV2"
  account_tier                    = var.sa_account_tier
  account_replication_type        = "LRS"
  sa_subnets                      = concat([data.azurerm_subnet.jenkins_subnet.id])
  allow_nested_items_to_be_public = false
  default_action                  = "Allow"
  enable_data_protection          = false

  common_tags = var.common_tags
}