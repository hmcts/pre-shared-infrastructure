locals {
  backup_service_name = format("%s-%s", var.product, var.env)
}

resource "azurerm_private_endpoint" "backup_service_pe" {

  name                = "${local.backup_service_name}-backup-pe"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = data.azurerm_subnet.endpoint_subnet.id

  private_service_connection {
    name                           = local.backup_service_name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_data_protection_backup_vault.pre_backup_vault.id
    subresource_names              = ["AzureBackup"]
  }

  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = ["/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.uks.backup.windowsazure.com"]
  }

  tags = var.common_tags
}