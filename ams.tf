resource "azurerm_media_services_account" "ams" {
  name                = "${var.product}ams${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.managed-identity.id]
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

# resource "azurerm_media_services_account" "ams" {
#   name                = "${var.product}ams${var.env}"
#   location            = var.location #"UKwest"
#   resource_group_name = azurerm_resource_group.rg.name

#   identity {
#     type = "SystemAssigned"
#   }



#   storage_account {
#     id         = module.ingestsa_storage_account.storageaccount_id
#     is_primary = true
#   }

#   storage_account {
#     id         = module.finalsa_storage_account.storageaccount_id
#     is_primary = false
#   }

#   tags = var.common_tags

# }

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

