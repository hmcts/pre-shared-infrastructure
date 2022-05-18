 resource "azurerm_media_services_account" "ams" {
  name                          = "${var.product}ams${var.env}"
  location                      = "UKwest"
  resource_group_name           = azurerm_resource_group.rg.name
  
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
  # identity {
  #     principal_id = azurerm_media_services_account.ams.identity[0].principal_id #var.pre_mi_principal_id
  #     tenant_id    = azurerm_media_services_account.ams.identity[0].tenant_id
  #     type         = "ManagedIdentity" 
  # }
  # storage_authentication_type   = "ManagedIdentity"
  storage_authentication_type   = "System"
  tags         = var.common_tags
  
}

# #Storage Blob Data Contributor Role Assignment for Managed Identity
# resource "azurerm_role_assignment" "pre_BlobContributor_mi" {
#   scope                            = azurerm_resource_group.rg.id
#   role_definition_name             = "Storage Blob Data Contributor"
#   principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id #var.pre_mi_principal_id
#   skip_service_principal_aad_check = true
# }

#Reader Role Assignment for Managed Identity
# resource "azurerm_role_assignment" "pre_reader_mi" {
#   scope                            = azurerm_resource_group.rg.id
#   role_definition_name             = "Reader"
#   principal_id                     = data.azurerm_user_assigned_identity.managed-identity.principal_id # var.pre_mi_principal_id 
#   skip_service_principal_aad_check = true
# }

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