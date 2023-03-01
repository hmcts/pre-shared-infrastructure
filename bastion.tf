##------------------------------------------------------###################
##BASTION
##------------------------------------------------------###################
resource "azurerm_public_ip" "pip" {
  name                = "${var.product}-bastionpip-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

##------------------------------------------------------###################
##BASTION
##------------------------------------------------------###################
resource "azurerm_bastion_host" "bastion" {
  name                   = "${var.product}-bastion-${var.env}"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  copy_paste_enabled     = true
  file_copy_enabled      = true
  sku                    = "Standard"
  ip_connect_enabled     = true
  scale_units            = 2
  shareable_link_enabled = true
  tunneling_enabled      = true

  ip_configuration {
    name                 = "bastionpublic"
    subnet_id            = azurerm_subnet.AzureBastionSubnet_subnet.id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
  tags = var.common_tags

}

###
## Encryption@Host
#######

resource "null_resource" "Encryption" {

  provisioner "local-exec" {
    command = <<EOF
    az login --identity
    az account set -s dts-sharedservices-${var.env}
    echo "Enable Encryption at Host"
    az feature register --namespace Microsoft.Compute --name EncryptionAtHost
	  EOF
  }
}

resource "azurerm_monitor_diagnostic_setting" "bastion" {
  name                       = azurerm_bastion_host.bastion.name
  target_resource_id         = azurerm_bastion_host.bastion.id
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  log {
    category = "BastionAuditLogs"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "bastionpip" {
  name                       = azurerm_public_ip.pip.name
  target_resource_id         = azurerm_public_ip.pip.id
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  log {
    category = "DDoSProtectionNotifications"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
  log {
    category = "DDoSMitigationFlowLogs"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
  log {
    category = "DDoSMitigationReports"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
}