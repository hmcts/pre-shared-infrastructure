
# create recovery services backup vault
resource "azurerm_recovery_services_vault" "pre_backup" {
  name                = "${var.product}-backupvault-${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  tags                = var.common_tags
}

# backup policy on vault
resource "azurerm_backup_policy_vm" "pre_backup_policy" {
  name                = "${var.product}-backuppolicy-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.pre_backup.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "03:00"
  }

  retention_daily {
    count = var.retention_daily
  }

  retention_weekly {
    count    = var.retention_weekly
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = var.retention_monthly
    weekdays = ["Sunday"]
    weeks    = ["Last"]
  }

  retention_yearly {
    count    = var.retention_yearly
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
}

# backup finalsa storage account
resource "azurerm_backup_container_storage_account" "finalsa_container" {
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.pre_backup.name
  storage_account_id  = module.finalsa_storage_account.storageaccount_id
}

# backup sa storage account
resource "azurerm_backup_container_storage_account" "sa_container" {
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.pre_backup.name
  storage_account_id  = module.sa_storage_account.storageaccount_id
}

# backup ingestsa storage account
resource "azurerm_backup_container_storage_account" "ingestsa_container" {
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.pre_backup.name
  storage_account_id  = module.ingestsa_storage_account.storageaccount_id
}
