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


resource "azurerm_monitor_diagnostic_setting" "ams_1" {
  name                       = azurerm_media_services_account.ams.name
  target_resource_id         = azurerm_media_services_account.ams.id
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  log {
    category = "MediaAccount"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
  log {
    category = "KeyDeliveryRequests"
    enabled  = true
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
}

resource "azurerm_media_content_key_policy" "ams_default_policy" {
  name                        = "pre-ams-integration-default-content-policy"
  resource_group_name         = azurerm_resource_group.rg.name
  media_services_account_name = azurerm_media_services_account.ams.name
  description                 = "PRE Content Key Policy"
  policy_option {
    name                            = "PolicyWithClearKeyOptionAndJwtTokenRestriction"
    clear_key_configuration_enabled = true
    token_restriction {
      token_type = "Jwt"
    }
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "ams_zone_link" {
  provider              = azurerm.private_dns
  name                  = format("%s-%s-virtual-network-link", var.product, var.env)
  resource_group_name   = var.dns_resource_group
  private_dns_zone_name = "privatelink.media.azure.net"
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "ams_streamingendpoint_private_endpoint" {
  name                = "ams-streamingendpoint-pe-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = azurerm_subnet.endpoint_subnet.id
  private_service_connection {
    name                           = "ams-private-link-connection"
    private_connection_resource_id = azurerm_media_services_account.ams.id
    is_manual_connection           = false
    subresource_names              = ["streamingendpoint"]
  }
  private_dns_zone_group {
    name                 = "ams-endpoint-dnszonegroup"
    private_dns_zone_ids = ["/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.media.azure.net"]
  }
  tags = var.common_tags
}
