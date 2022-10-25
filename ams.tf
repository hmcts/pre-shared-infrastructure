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
  lifecycle {
    ignore_changes= [storage_authentication_type,identity]
  }
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

 resource "azurerm_media_services_account" "ams02" {
  name                          = "${var.product}ams02${var.env}"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  
  identity {
    #  principal_id 
    #  tenant_id 
    type = "SystemAssigned"
  } 


  storage_account {
    id         = module.ingestsa02_storage_account.storageaccount_id 
    is_primary = true
  }

  storage_account {
    id         = module.finalsa02_storage_account.storageaccount_id 
    is_primary = false
 }
 
  # storage_authentication_type   = "ManagedIdentity"
  # storage_authentication_type   = "System"
  # lifecycle {
  #   ignore_changes= [storage_authentication_type,identity]
  # }
  tags         = var.common_tags
  
}

# resource "azapi_update_resource" "ams" {
#   type        = "Microsoft.Media/mediaservices@2021-11-01"
#   resource_id = azurerm_media_services_account.ams02.id
 
#   body = jsonencode({
#     identity = {
#       "type" = "UserAssigned",
#       "userAssignedIdentities" = "/subscriptions/a8140a9e-f1b0-481f-a4de-09e2ee23f7ab/resourcegroups/managed-identities-sbox-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pre-sbox-mi"
#       #"/subscriptions/a8140a9e-f1b0-481f-a4de-09e2ee23f7ab/resourcegroups/managed-identities-${var.env}-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pre-${var.env}-mi"
      
      
#       # "data.azurerm_user_assigned_identity.managed-identity.name" 
#       #"eb4aa503-5ffa-49ef-a69d-221e90eaf236"
#       # "/subscriptions/DTS-SHAREDSERVICES-${var.env}/resourcegroups/managed-identities-${var.env}-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pre-${var.env}-mi"
#     # eb4aa503-5ffa-49ef-a69d-221e90eaf236
#     # principal_id                     = "module.key-vault.managed_identity_objectid"
#     }
#   })
# }


resource "azurerm_media_transform" "analysevideo02" {
  name                        = "AnalyseVideos"
  resource_group_name         = azurerm_resource_group.rg.name
  media_services_account_name = azurerm_media_services_account.ams02.name
  description                 = "Analyse Video"
  output {
    relative_priority = "Normal"
    on_error_action   = "ContinueJob"
    builtin_preset {
      preset_name = "H264SingleBitrate1080p"
    }
  }
}

resource "azurerm_media_transform" "EncodeToMP402" {
  name                        = "EncodeToMP4"
  resource_group_name         = azurerm_resource_group.rg.name
  media_services_account_name = azurerm_media_services_account.ams02.name

  description                 = "Encode To MP4"
  output {
    relative_priority = "Normal"
    on_error_action   = "ContinueJob"
    builtin_preset {
      preset_name = "H264SingleBitrate1080p"
    }
  }
}

resource "null_resource" "amsid" {
  # triggers = {
  #   always_run = timestamp()
  # }

  depends_on = [azurerm_media_services_account.ams02]
 provisioner "local-exec" {
   command = <<EOF
    az login --identity
    az account set -s dts-sharedservices-${var.env}
    echo "ams account identity assign"
    az ams account identity assign --name ${azurerm_media_services_account.ams.name} -g ${azurerm_resource_group.rg.name} --user-assigned "/subscriptions/${var.subscription}/resourcegroups/managed-identities-${var.env}-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pre-${var.env}-mi"
    az ams account identity assign --name ${azurerm_media_services_account.ams02.name} -g ${azurerm_resource_group.rg.name} --user-assigned "/subscriptions/${var.subscription}/resourcegroups/managed-identities-${var.env}-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pre-${var.env}-mi"
  
     EOF
   }
    # az ams account identity assign --name ${azurerm_media_services_account.ams02.name} -g ${azurerm_resource_group.rg.name} --user-assigned "/subscriptions/dts-sharedservices-${var.env}/resourcegroups/managed-identities-${var.env}-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pre-${var.env}-mi"
    # az ams account storage set-authentication --account-name ${azurerm_media_services_account.ams02.name} -g ${azurerm_resource_group.rg.name} --user-assigned "/subscriptions/dts-sharedservices-${var.env}/resourcegroups/managed-identities-${var.env}-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pre-${var.env}-mi" --storage-auth ManagedIdentity --storage-account-id "/subscriptions/dts-sharedservices-${var.env}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.Storage/storageAccounts/preingestsa${var.env}" 

}


resource "azapi_update_resource" "ams_auth" {
  depends_on =  [null_resource.amsid] #[azapi_update_resource.ams]
  type        = "Microsoft.Media/mediaservices@2021-06-01"
  resource_id = azurerm_media_services_account.ams02.id
 
  body = jsonencode({
    properties = {
      storageAuthentication = "ManagedIdentity"
      storageAccounts = [
        {
          id   = module.ingestsa02_storage_account.storageaccount_id 
           
          type = "Primary"
          identity = {
            userAssignedIdentity      = data.azurerm_user_assigned_identity.managed-identity.principal_id
            useSystemAssignedIdentity = "false"
          }

          id   = module.finalsa02_storage_account.storageaccount_id 
          type = "Secondary",
            identity = {
            userAssignedIdentity      = data.azurerm_user_assigned_identity.managed-identity.principal_id
            useSystemAssignedIdentity = "false"
          }
        }
      ]
    }
  })
}


# #Storage Blob Data Contributor Role Assignment for Managed Identity

# resource "azurerm_role_assignment" "pre_amsblobdatacontributor_mi" {
#   scope                            = azurerm_resource_group.rg.id
#   role_definition_name             = "Storage Blob Data Contributor"
#   principal_id                     = "module.key-vault.managed_identity_objectid" #azurerm_media_services_account.ams.identity[0].principal_id #var.pre_mi_principal_id
#   skip_service_principal_aad_check = true
#   depends_on = [
#     azurerm_media_services_account.ams
#   ]
# }

# #Reader Role Assignment for Managed Identity
# resource "azurerm_role_assignment" "pre_amsreader_mi" {
#   scope                            = azurerm_resource_group.rg.id
#   role_definition_name             = "Reader"
#   principal_id                     ="module.key-vault.managed_identity_objectid" # azurerm_media_services_account.ams.identity[0].principal_id # var.pre_mi_principal_id 
#   skip_service_principal_aad_check = true
  
#   depends_on = [
#     azurerm_media_services_account.ams
#   ]
# }

