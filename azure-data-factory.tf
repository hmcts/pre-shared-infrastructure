module "datafactory" {
  count  = var.num_adf # We only need it in prod
  source = "git@github.com:hmcts/terraform-module-azure-datafactory.git?ref=main"

  env         = var.env
  product     = "pre"
  component   = "vodafone"
  location    = var.location
  common_tags = var.common_tags

  existing_resource_group_name = data.azurerm_resource_group.rg.name

  linked_blob_storage = [{
    connection_string    = module.vodasa_storage_account.storageaccount_primary_connection_string
    use_managed_identity = false
  }]
}