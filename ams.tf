resource "azurerm_media_services_account" "ams" {
  name                = "${var.product}ams${var.env}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.managed_identity.id]
  }

  storage_account {
    id         = module.ingestsa_storage_account.storageaccount_id
    is_primary = true

    managed_identity {
      use_system_assigned_identity = false
      user_assigned_identity_id    = data.azurerm_user_assigned_identity.managed_identity.id
    }
  }

  storage_account {
    id         = module.finalsa_storage_account.storageaccount_id
    is_primary = false

    managed_identity {
      use_system_assigned_identity = false
      user_assigned_identity_id    = data.azurerm_user_assigned_identity.managed_identity.id
    }
  }

  tags = var.common_tags

}

resource "azurerm_media_transform" "analysevideo" {
  name                        = "AnalyseVideo"
  resource_group_name         = data.azurerm_resource_group.rg.name
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
  resource_group_name         = data.azurerm_resource_group.rg.name
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

  enabled_log {
    category = "MediaAccount"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
  enabled_log {
    category = "KeyDeliveryRequests"
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
  name                        = "PolicyWithClearKeyOptionAndJwtTokenRestriction"
  resource_group_name         = data.azurerm_resource_group.rg.name
  media_services_account_name = azurerm_media_services_account.ams.name
  description                 = "PRE Content Key Policy"
  policy_option {
    name                            = "ClearKeyOption"
    clear_key_configuration_enabled = true
    token_restriction {
      token_type                  = "Jwt"
      audience                    = "api://${var.pre_ent_appreg_app_id}"
      issuer                      = "https://sts.windows.net/531ff96d-0ae9-462a-8d2d-bec7c0b42082/"
      primary_symmetric_token_key = data.azurerm_key_vault_secret.symmetrickey.value
    }
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "ams_zone_link" {
  provider              = azurerm.private_dns
  name                  = format("%s-%s-virtual-network-link", var.product, var.env)
  resource_group_name   = var.dns_resource_group
  private_dns_zone_name = "privatelink.media.azure.net"
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "ams_streamingendpoint_private_endpoint" {
  name                = "ams-streamingendpoint-pe-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = data.azurerm_subnet.endpoint_subnet.id
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

resource "azurerm_eventgrid_topic" "ams_eventgrid_topic" {
  name                = "exampleTopic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  tags = var.common_tags
}

resource "azurerm_eventgrid_event_subscription" "ams_eventgrid_subscription" {
  name  = "pre-timestamp-mgmt-${var.env}-TransformJobTimestampEvent"
  scope = azurerm_media_services_account.ams.id

  azure_function_endpoint {
    function_id                       = "${data.azurerm_linux_function_app.ams_function_app.id}/functions/GenerateVtt"
    max_events_per_batch              = 1
    preferred_batch_size_in_kilobytes = 64
  }

  included_event_types = [
    "Microsoft.Media.JobOutputStateChange"
  ]

  advanced_filter {
    string_contains {
      key    = "subject"
      values = ["EncodetoMP4"]
    }
  }
}

resource "azurerm_eventgrid_event_subscription" "ams_eventgrid_subscription" {
  name  = "pre-timestamp-mgmt-${var.env}-PRE-EventHealthMonitoring"
  scope = azurerm_media_services_account.ams.id

  azure_function_endpoint {
    function_id                       = "${data.azurerm_linux_function_app.ams_function_app.id}/functions/GenerateVtt"
    max_events_per_batch              = 1
    preferred_batch_size_in_kilobytes = 64
  }

  included_event_types = [
    "Microsoft.Media.LiveEventEncoderConnected",
    "Microsoft.Media.LiveEventIncomingStreamReceived",
    "Microsoft.Media.LiveEventEncoderDisconnected"
  ]

  advanced_filter {
    string_contains {
      key    = "subject"
      values = ["EncodetoMP4"]
    }
  }
}

resource "azurerm_media_services_account_filter" "ams_filter" {
  media_services_account_name = azurerm_media_services_account.ams.name
  name                        = "amsFilter"
  resource_group_name         = data.azurerm_resource_group.rg.name
}
