resource "azurerm_media_services_account" "ams" {
  name                = "${var.product}ams${var.env}"
  location            = var.location #"UKwest"
  resource_group_name = azurerm_resource_group.rg.name

  identity {
    type = "SystemAssigned"
  }



  storage_account {
    id         = module.ingestsa_storage_account.storageaccount_id
    is_primary = true
  }

  storage_account {
    id         = module.finalsa_storage_account.storageaccount_id
    is_primary = false
  }

  tags = var.common_tags

}
resource "azurerm_media_transform" "analysevideo" {
  name                        = "AnalyseVideo"
  resource_group_name         = azurerm_resource_group.rg.name
  media_services_account_name = azurerm_media_services_account.ams.name

  description = "Analyse Video"

  output {
    relative_priority = "Normal"
    on_error_action   = "ContinueJob"
    builtin_preset {
      preset_name = "H264SingleBitrate1080p"
    }
  }
}


resource "azurerm_media_transform" "EncodeToMP" {
  name                        = "EncodeToMP4"
  resource_group_name         = azurerm_resource_group.rg.name
  media_services_account_name = azurerm_media_services_account.ams.name


  description = "Encode To MP4"

  output {
    relative_priority = "Normal"
    on_error_action   = "ContinueJob"
    builtin_preset {
      preset_name = "H264SingleBitrate1080p"
    }
  }
}

resource "null_resource" "amsid" {
  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [azurerm_media_services_account.ams]


}


resource "azapi_update_resource" "ams_auth" {
  depends_on  = [null_resource.amsid]
  type        = "Microsoft.Media/mediaservices@2021-11-01"
  resource_id = azurerm_media_services_account.ams.id

  body = jsonencode({
    properties = {
      storageAuthentication = "ManagedIdentity"
      storageAccounts = [
        {
          id   = module.ingestsa_storage_account.storageaccount_id
          type = "Primary",
          identity = {
            userAssignedIdentity      = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/managed-identities-stg-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pre-stg-mi"
            useSystemAssignedIdentity = "false"
          }
        },

        {
          id   = module.finalsa_storage_account.storageaccount_id
          type = "Secondary",
          identity = {
            userAssignedIdentity      = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/managed-identities-stg-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pre-stg-mi"
            useSystemAssignedIdentity = "false"
          }
        }
      ]
    }
  })
}
