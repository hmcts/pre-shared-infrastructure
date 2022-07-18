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
  name                        = "AnalyseVideo"
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

resource "null_resource" "amsid" {
  # triggers = {
  #   always_run = timestamp()
  # }

  depends_on = [azurerm_media_services_account.ams]
 provisioner "local-exec" {
   command = <<EOF
    az ams account identity assign --name azurerm_media_services_account.ams.name -g azurerm_resource_group.rg.name --user-assigned data.azurerm_user_assigned_identity.managed-identity.principal_id
		az ams account storage set-authentication --account-name azurerm_media_services_account.ams.name -g azurerm_resource_group.rg.name --user-assigned data.azurerm_user_assigned_identity.managed-identity.principal_id --storage-auth ManagedIdentity --storage-account-id module.ingestsa_storage_account.storageaccount_id
    az ams account storage set-authentication --account-name azurerm_media_services_account.ams.name -g azurerm_resource_group.rg.name --user-assigned data.azurerm_user_assigned_identity.managed-identity.principal_id --storage-auth ManagedIdentity --storage-account-id module.finalsa_storage_account.storageaccount_id
   EOF
 }

}