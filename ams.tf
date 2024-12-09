locals {
  // if stg env, grant dev-mi access to AMS
  managed_identities = var.env == "stg" ? [data.azurerm_user_assigned_identity.pre_dev_mi.id, data.azurerm_user_assigned_identity.managed_identity.id] : [data.azurerm_user_assigned_identity.managed_identity.id]
}

resource "azurerm_media_services_account" "ams" {
  name                = "${var.product}ams${var.env}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  identity {
    type         = "UserAssigned"
    identity_ids = local.managed_identities
  }

  storage_account {
    id         = module.ingestsa_storage_account.storageaccount_id
    is_primary = true

    managed_identity {
      use_system_assigned_identity = false
      user_assigned_identity_id    = data.azurerm_user_assigned_identity.managed_identity.id
    }
  }

  storage_account {
    id         = module.finalsa_storage_account.storageaccount_id
    is_primary = false

    managed_identity {
      use_system_assigned_identity = false
      user_assigned_identity_id    = data.azurerm_user_assigned_identity.managed_identity.id
    }
  }

  tags = var.common_tags

}

// if test env, grant dev-mi access to the SAs
resource "azurerm_role_assignment" "pre_dev_mi_appreg_ingest_contrib" {
  count                = var.env == "test" ? 1 : 0
  scope                = module.ingestsa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = data.azurerm_user_assigned_identity.pre_dev_mi.principal_id
}

// if test env, grant dev-mi access to the SAs
resource "azurerm_role_assignment" "pre_dev_mi_appreg_final_contrib" {
  count                = var.env == "test" ? 1 : 0
  scope                = module.finalsa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = data.azurerm_user_assigned_identity.pre_dev_mi.principal_id
}

// if test env, grant stg-mi access to the SAs
resource "azurerm_role_assignment" "pre_stg_mi_appreg_ingest_contrib" {
  count                = var.env == "test" ? 1 : 0
  scope                = module.ingestsa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = data.azurerm_user_assigned_identity.pre_stg_mi.principal_id
}

// if test env, grant stg-mi access to the SAs
resource "azurerm_role_assignment" "pre_stg_mi_appreg_final_contrib" {
  count                = var.env == "test" ? 1 : 0
  scope                = module.finalsa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = data.azurerm_user_assigned_identity.pre_stg_mi.principal_id
}

resource "azurerm_private_dns_zone_virtual_network_link" "ams_zone_link" {
  count                 = var.env != "test" ? 1 : 0
  provider              = azurerm.private_dns
  name                  = format("%s-%s-virtual-network-link", var.product, var.env)
  resource_group_name   = var.dns_resource_group
  private_dns_zone_name = "privatelink.media.azure.net"
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}
