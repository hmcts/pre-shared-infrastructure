module "datafactory" {
  count  = var.num_adf # We only need it in prod
  source = "git@github.com:hmcts/terraform-module-azure-datafactory.git?ref=main"

  env         = var.env
  product     = "pre"
  component   = "vodafone"
  location    = var.location
  common_tags = var.common_tags

  user_assigned_identity_ids = [
    data.azurerm_user_assigned_identity.managed_identity.id
  ]

  existing_resource_group_name = data.azurerm_resource_group.rg.name

  linked_blob_storage = {
    "prevoda" = {
      connection_string    = module.vodasa_storage_account.storageaccount_primary_connection_string
      use_managed_identity = true
    }
  }
}

resource "azurerm_role_assignment" "adf_jason_contrib" {
  count                = var.num_adf # We only need it in prod
  scope                = module.datafactory[0].id
  role_definition_name = "Data Factory Contributor"
  principal_id         = "d0c32eaa-f190-4b8e-9884-adefce62b143" # Jason
}

resource "azurerm_role_assignment" "adf_jason_voda_sa_contrib" {
  count                = var.num_adf # We only need it in prod
  scope                = module.vodasa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = "c12b6257-1c4b-47a7-bb78-cc6edb9df68f" # Jason
}

resource "azurerm_role_assignment" "adf_damon_contrib" {
  count                = var.num_adf # We only need it in prod
  scope                = module.datafactory[0].id
  role_definition_name = "Data Factory Contributor"
  principal_id         = "c12b6257-1c4b-47a7-bb78-cc6edb9df68f" # Damon
}

resource "azurerm_role_assignment" "adf_damon_voda_sa_contrib" {
  count                = var.num_adf # We only need it in prod
  scope                = module.vodasa_storage_account.storageaccount_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = "c12b6257-1c4b-47a7-bb78-cc6edb9df68f" # Damon
}