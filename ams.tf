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
    az login --identity
    az account set -s DTS-SHAREDSERVICES-${var.env}
    az ams account identity assign --name ${azurerm_media_services_account.ams.name} -g ${azurerm_resource_group.rg.name} --user-assigned "/subscriptions/DTS-SHAREDSERVICES-${var.env}/resourcegroups/managed-identities-${var.env}-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pre-${var.env}-mi"
    az ams account storage set-authentication --account-name ${azurerm_media_services_account.ams.name} -g ${azurerm_resource_group.rg.name} --user-assigned "/subscriptions/DTS-SHAREDSERVICES-${var.env}/resourcegroups/managed-identities-${var.env}-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pre-${var.env}-mi" --storage-auth ManagedIdentity --storage-account-id "/subscriptions/dts-sharedservices-${var.env}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.Storage/storageAccounts/preingestsa${var.env}" 
	  EOF
 }

}