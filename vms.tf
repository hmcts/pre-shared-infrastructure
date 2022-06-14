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
  name                = "${var.product}-bastion-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "bastionpublic"
    subnet_id                     = azurerm_subnet.AzureBastionSubnet_subnet.id
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
  tags = var.common_tags

}


provisioner "local-exec" {
    command = "env AZURE_CONFIG_DIR=/opt/jenkins/.azure-${var.subscription} Register-AzProviderFeature -FeatureName ${var.featureName} -ProviderNamespace ${var.ProviderNamespace }"
  }

# ###################################################
# #                EDIT VIRTUAL MACHINE                 #
# ###################################################

resource "azurerm_network_interface" "nic" {
  count               = var.num_vid_edit_vms
  name                = "${var.product}-videditnic${count.index}-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.videoeditvm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
   tags                = var.common_tags
}
resource "azurerm_windows_virtual_machine" "vm" {
  count                       = var.num_vid_edit_vms
  name                        = "${var.product}-videditvm${count.index}-${var.env}"
  computer_name               = "PREVIDED0${count.index}-${var.env}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  size                        = var.vid_edit_vm_spec
  admin_username              = "videdit${count.index}_${random_string.vm_username[count.index].result}"
  admin_password              = random_password.vm_password[count.index].result
  network_interface_ids       = [azurerm_network_interface.nic[count.index].id]
  encryption_at_host_enabled  = true

  # additional_capabilities {
  #  ultra_ssd_enabled   =  true
  # }
  
  os_disk {
    name                      = "${var.product}-videditvm${count.index}-osdisk-${var.env}"
    caching                   = "ReadWrite"
    storage_account_type      = "StandardSSD_LRS" #UltraSSD_LRS?
    disk_encryption_set_id    = azurerm_disk_encryption_set.pre-des.id
    # write_accelerator_enabled = true
  }

  
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h1-pro-g2"
    version   = "latest"
  }
  # identity {
  #   type = "SystemAssigned"
  #   }

  timezone                 = "GMT Standard Time"
  enable_automatic_updates = true
  provision_vm_agent       = true  
  tags                     = var.common_tags

  depends_on = [ module.key-vault, azurerm_disk_encryption_set.pre-des ]
}

resource "azurerm_managed_disk" "vmdatadisk" {
  count                   = var.num_vid_edit_vms
  name                    = "${var.product}-videditvm${count.index}-datadisk-${var.env}"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  storage_account_type    = "StandardSSD_LRS"
  create_option           = "Empty"
  disk_size_gb            = 1000
  disk_encryption_set_id  = azurerm_disk_encryption_set.pre-des.id
  tags                    = var.common_tags

     
}

resource "azurerm_virtual_machine_data_disk_attachment" "vmdatadisk" {
  count              = var.num_vid_edit_vms
  managed_disk_id    = azurerm_managed_disk.vmdatadisk.*.id[count.index]
  virtual_machine_id = azurerm_windows_virtual_machine.vm.*.id[count.index]
  lun                = "3"
  caching            = "ReadWrite"
}

# resource "azurerm_security_center_server_vulnerability_assessment_virtual_machine" "va" {
#   virtual_machine_id = azurerm_windows_virtual_machine.vm.*.id
# }

# resource "azurerm_security_center_server_vulnerability_assessment" "vulass" {
#   virtual_machine_id = azurerm_windows_virtual_machine.vm.id
# }