 resource "azurerm_media_services_account" "ams" {
  name                          = "${var.product}ams${var.env}"
  location                      = "UKwest"
  resource_group_name           = azurerm_resource_group.rg.name
  
  # identity {
  #   type = "SystemAssigned"
  # } 


  storage_account {
    id         = module.ingestsa_storage_account.storageaccount_id 
    is_primary = true
  }

  storage_account {
    id         = module.finalsa_storage_account.storageaccount_id 
    is_primary = false
 }
 
  # storage_authentication_type   = "ManagedIdentity"
  # storage_authentication_type   = "System"
  # lifecycle {
  #   ignore_changes= [storage_authentication_type,identity]
  # }
  tags         = var.common_tags
  
}
resource "azurerm_media_transform" "analysevideo" {
  name                        = "AnalyseVideos"
  resource_group_name         = azurerm_resource_group.rg.name
  media_services_account_name = azurerm_media_services_account.ams.name
  description                 = "Analyse Video"
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

  description                 = "Encode To MP4"
  output {
    relative_priority = "Normal"
    on_error_action   = "ContinueJob"
    builtin_preset {
      preset_name = "H264SingleBitrate1080p"
    }
  }
}

# # #Storage Blob Data Contributor Role Assignment for Managed Identity

# resource "azurerm_role_assignment" "pre_amsblobdatacontributor_mi" {
#   scope                            = azurerm_resource_group.rg.id
#   role_definition_name             = "Storage Blob Data Contributor"
#   principal_id                     = azurerm_media_services_account.ams.identity[0].principal_id #var.pre_mi_principal_id
#   skip_service_principal_aad_check = true
#   depends_on = [
#     azurerm_media_services_account.ams
#   ]
# }

# #Reader Role Assignment for Managed Identity
# resource "azurerm_role_assignment" "pre_amsreader_mi" {
#   scope                            = azurerm_resource_group.rg.id
#   role_definition_name             = "Reader"
#   principal_id                     = azurerm_media_services_account.ams.identity[0].principal_id # var.pre_mi_principal_id 
#   skip_service_principal_aad_check = true
  
#   depends_on = [
#     azurerm_media_services_account.ams
#   ]
# }

# resource "null_resource" "amsmi" {
#     provisioner "local-exec" { 
#         command = ".'${path.module}\\pre.ps1' -amsname azurerm_media_services_account.ams.name -rg azurerm_resource_group.rg.name -mi data.azurerm_user_assigned_identity.managed-identity.principal_id  "
#         interpreter = ["PowerShell", "-Command"]
#     }
# }

resource "null_resource" "azcli_exec2" {
  provisioner "local-exec" {
    command = " az ams account identity assign -n azurerm_media_services_account.ams.name -g azurerm_resource_group.rg.name --user-assigned data.azurerm_user_assigned_identity.managed-identity.principal_id  "
  }
}

# && az ams account storage set-authentication -n azurerm_media_services_account.ams.name -g azurerm_resource_group.rg.name --user-assigned data.azurerm_user_assigned_identity.managed-identity.principal_id --storage-auth ManagedIdentity