data "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.id
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

output "bastion_subnet_id" {
  value = data.azurerm_subnet.bastion_subnet.id
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-bastionpip-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.id
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = module.tags.common_tags
}

resource "azurerm_bastion_host" "bastion" {
  name                   = "${var.prefix}-bastion-${var.env}"
  resource_group_name    = data.azurerm_resource_group.rg.id
  location               = var.location
  copy_paste_enabled     = true
  file_copy_enabled      = true
  sku                    = "Standard"
  ip_connect_enabled     = true
  scale_units            = 2
  shareable_link_enabled = true
  tunneling_enabled      = true

  ip_configuration {
    name                 = "bastionpublic"
    subnet_id            = data.azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
  tags = module.tags.common_tags

}

###
## Encryption@Host
####### not sure what this is all about

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