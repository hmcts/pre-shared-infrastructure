resource "azurerm_media_services_account" "ams" {
  name                = "${var.product}ams${var.env}"
  location            = var.location #"UKwest"
  resource_group_name = azurerm_resource_group.rg.name

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

resource "null_resource" "amsid" {
  triggers = {
    always_run = "${timestamp()}"
  }
  depends_on = [azurerm_media_services_account.ams]
}
resource "azurerm_private_endpoint" "ams_endpoint" {
  name                = "ams-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.endpoint_subnet.id
  private_service_connection {
    name                           = "ams-endpoint"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_media_services_account.ams.id
    subresource_names              = ["streamingendpoint"]
  }
  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = ["/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  }
  tags = var.common_tags

}

resource "azapi_update_resource" "ams_auth" {
  depends_on  = [null_resource.amsid]
  type        = "Microsoft.Media/mediaservices@2021-11-01"
  resource_id = azurerm_media_services_account.ams.id

  body = jsonencode({
    properties = {
      storageAuthentication = "ManagedIdentity"
      storageAccounts = [
        {
          id   = module.ingestsa_storage_account.storageaccount_id
          type = "Primary",
          identity = {
            userAssignedIdentity      = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/managed-identities-${var.env}-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pre-${var.env}-mi"
            useSystemAssignedIdentity = "false"
          }
        },

        {
          id   = module.finalsa_storage_account.storageaccount_id
          type = "Secondary",
          identity = {
            userAssignedIdentity      = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourcegroups/managed-identities-${var.env}-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pre-${var.env}-mi"
            useSystemAssignedIdentity = "false"
          }
        }
      ]
    }
  })

}

resource "azurerm_public_ip" "ams_pip" {
  name                = "${var.product}-amspip-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

resource "azurerm_private_link_service" "this" {
  name = "${var.product}-ams"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.ams_public.frontend_ip_configuration.0.id]

  nat_ip_configuration {
    name      = "primary"
    subnet_id = azurerm_subnet.endpoint_subnet.id
    primary   = true
  }
  tags = var.common_tags
}

resource "azurerm_lb" "ams_public" {
  name = "${var.product}-ams-public"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku = "Standard"

  frontend_ip_configuration {
    name                 = "ams"
    public_ip_address_id = azurerm_public_ip.ams_pip.id
  }
  tags = var.common_tags
}