locals {
  // if stg env, grant dev-mi access to AMS
  managed_identities = var.env == "stg" ? [data.azurerm_user_assigned_identity.pre_dev_mi.id, data.azurerm_user_assigned_identity.managed_identity.id] : [data.azurerm_user_assigned_identity.managed_identity.id]
}

