resource "azurerm_media_services_account" "ams" {
  name                = "${var.product}ams${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  identity {
    type         = "SystemAssigned, UserAssigned"
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

resource "azurerm_private_endpoint" "ams_private_endpoint" {
  name                = "ams-private-endpoint"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = azurerm_subnet.endpoint_subnet.id
  private_service_connection {
    name                           = "ams-private-link-connection"
    private_connection_resource_id = azurerm_media_services_account.ams.id
    is_manual_connection           = false
    subresource_names = [
      "keydelivery",
      "liveevent",
      "streamingendpoint",
    ]
  }
  private_dns_zone_group {
    name                 = "media-endpoint-dnszonegroup"
    private_dns_zone_ids = ["/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.media.azure.net"]
  }
  tags = var.common_tags
}
