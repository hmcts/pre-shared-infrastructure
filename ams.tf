 resource "azurerm_media_services_account" "ams" {
  name                          = "${var.product}ams${var.env}"
  location                      = "UKwest"
  resource_group_name           = azurerm_resource_group.rg.name
  storage_authentication_type   = "ManagedIdentity"
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
  tags         = var.common_tags
}

resource "azurerm_media_transform" "analysevideo" {
  name                        = "AnalyseVideo"
  resource_group_name         = azurerm_resource_group.rg.name
  media_services_account_name = azurerm_media_services_account.ams.name
  description                 = "AnalyseVideo"
  output {
    relative_priority = "Normal"
    on_error_action   = "ContinueJob"
    builtin_preset {
      preset_name = "H264SingleBitrate1080p"
    }
  }
}

resource "azurerm_media_transform" "EncodeToMP4" {
  name                        = "EncodeToMP4"
  resource_group_name         = azurerm_resource_group.rg.name
  media_services_account_name = azurerm_media_services_account.ams.name
  description                 = "EncodeToMP4"
  output {
    relative_priority = "Normal"
    on_error_action   = "ContinueJob"
    builtin_preset {
      preset_name = "H264SingleBitrate1080p"
    }
  }
}

#Role Assignment
# resource "azurerm_role_assignment" "demo" {
#   scope                            = azurerm_media_services_account.demo.id
#   role_definition_name             = "Contributor"
#   principal_id                     = azurerm_function_app.demo.identity[0].principal_id
#   skip_service_principal_aad_check = true

# #  resource "azurerm_media_services_account" "ams" {
# #   name                = "${var.product}ams${var.env}"
# #   location            = azurerm_resource_group.rg.location
# #   resource_group_name = azurerm_resource_group.rg.name

# #   storage_account {
# #     id         = module.ingestsa_storage_account.storageaccount_id 
# #     is_primary = true
# #   }

# #   storage_account {
# #     id         = module.finalsa_storage_account.storageaccount_id 
# #     is_primary = false
# #   }
# #   tags             = var.common_tags
# # }

# # resource "azurerm_media_transform" "analysevideo" {
# #   name                        = "AnalyseVideo"
# #   resource_group_name         = azurerm_resource_group.rg.name
# #   media_services_account_name = azurerm_media_services_account.ams.name
# #   description                 = "AnalyseVideo"
# #   output {
# #     relative_priority = "Normal"
# #     on_error_action   = "ContinueJob"
# #     builtin_preset {
# #       preset_name = "H264SingleBitrate1080p"
# #     }
# #   }
# # }

# # resource "azurerm_media_transform" "EncodeToMP4" {
# #   name                        = "EncodeToMP4"
# #   resource_group_name         = azurerm_resource_group.rg.name
# #   media_services_account_name = azurerm_media_services_account.ams.name
# #   description                 = "EncodeToMP4"
# #   output {
# #     relative_priority = "Normal"
# #     on_error_action   = "ContinueJob"
# #     builtin_preset {
# #       preset_name = "H264SingleBitrate1080p"
# #     }
# #   }
# # }

