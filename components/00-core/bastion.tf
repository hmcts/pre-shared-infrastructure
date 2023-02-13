resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-bastionpip-${var.env}"
  resource_group_name = local.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = module.tags.common_tags
}

resource "azurerm_bastion_host" "bastion" {
  name                   = "${var.prefix}-bastion-${var.env}"
  resource_group_name    = local.resource_group_name
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
    subnet_id            = local.subnet_id
    public_ip_address_id = local.public_ip_address_id
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