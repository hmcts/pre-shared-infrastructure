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


###################################################
#            Editting VM NETWORK INTERFACE CARD               #
###################################################
resource "azurerm_network_interface" "edtvmnic" {
  count               = var.num_vid_edit_vms
  name                = "${var.product}-edtvmnic${count.index}-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  # enable_accelerated_networking  = true
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.videoeditvm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
   tags                = var.common_tags
}
resource "azurerm_managed_disk" "edtvmdatadisk" {
  count                = var.num_vid_edit_vms
  name                 = "${var.product}-videdit${count.index}-datadisk-${var.env}"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = 1000
  # zone                 = "2"
  disk_encryption_set_id  = azurerm_disk_encryption_set.pre-des.id
  tags                 = var.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "edtvm" {
  count              = var.num_vid_edit_vms
  managed_disk_id    = azurerm_managed_disk.edtvmdatadisk.*.id[count.index]
  virtual_machine_id = azurerm_windows_virtual_machine.edtvm.*.id[count.index]
  lun                = "3"
  caching            = "ReadWrite"
}

###################################################
#                EDIT VIRTUAL MACHINE                 #
###################################################
resource "azurerm_windows_virtual_machine" "edtvm" {
  count                 = var.num_vid_edit_vms
  # zone                = 2
  name                  = "${var.product}edtvm${count.index}-${var.env}"
  computer_name         = "PREEDTVM0${count.index}-${var.env}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.vid_edit_vm_spec
  admin_username        = "videdit${count.index}_${random_string.vm_username[count.index].result}"
  admin_password        = random_password.vm_password[count.index].result
  network_interface_ids = [azurerm_network_interface.edtvmnic[count.index].id]

  os_disk {
    name                 = "${var.product}-edtvm${count.index}-osdisk-${var.env}"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_encryption_set_id  = azurerm_disk_encryption_set.pre-des.id
  }
  identity {
    type = "SystemAssigned"
  }
  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  enable_automatic_updates = true
  provision_vm_agent       = true  
  timezone                 = "GMT Standard Time"
  tags                     = var.common_tags

  depends_on = [ module.key-vault]
}

##################################################
##           Editing NETWORK INTERFACE CARD               #
###################################################
resource "azurerm_network_interface" "nics" {
  count               = var.num_vid_edit_vms
  name                = "${var.product}-videditvmnics${count.index}-${var.env}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.videoeditvm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
   tags                = var.common_tags
}

###################################################
#                 Editing VIRTUAL MACHINE                 #
###################################################
resource "azurerm_windows_virtual_machine" "vm" {
  count                       = var.num_vid_edit_vms
  name                        = "${var.product}-videditvm${count.index}-${var.env}"
  computer_name               = "PREVIDED0${count.index}-${var.env}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  size                        = var.vid_edit_vm_spec
  admin_username              = "videdit${count.index}_${random_string.vm_username[count.index].result}"
  admin_password              = random_password.vm_password[count.index].result
  network_interface_ids       = [azurerm_network_interface.nics[count.index].id]
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



# ###################################################
# #            Datagateway NETWORK INTERFACE CARD               #
# ###################################################
# resource "azurerm_network_interface" "dtgwnic" {
#   count               = var.num_datagateway
#   name                = "${var.product}-dtgwnic${count.index}-${var.env}"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.datagateway_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
#    tags                = var.common_tags
# }
# resource "azurerm_managed_disk" "datadisk" {
#   count                = var.num_datagateway
#   name                 = "${var.product}-dtgtwy${count.index}-datadisk-${var.env}"
#   location             = azurerm_resource_group.rg.location
#   resource_group_name  = azurerm_resource_group.rg.name
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = 100
#   zone                 = "2"
#   disk_encryption_set_id  = azurerm_disk_encryption_set.pre-des.id
#   tags                 = var.common_tags
# }

# resource "azurerm_virtual_machine_data_disk_attachment" "dtgtwy" {
#   count              = var.num_datagateway
#   managed_disk_id    = azurerm_managed_disk.datadisk.*.id[count.index]
#   virtual_machine_id = azurerm_windows_virtual_machine.dtgtwyvm.*.id[count.index]
#   lun                = "3"
#   caching            = "ReadWrite"
# }

# ###################################################
# #                DATAGATEWAY VIRTUAL MACHINE                 #
# ###################################################
# resource "azurerm_windows_virtual_machine" "dtgtwyvm" {
#   count               = var.num_datagateway
#   zone                = 2
#   name                = "${var.product}dtgtwy${count.index}-${var.env}"
#   computer_name       = "PREDTGTW0${count.index}-${var.env}"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   size                = var.datagateway_spec
#   admin_username      = "Dtgtwy${count.index}_${random_string.dtgtwy_username[count.index].result}"
#   admin_password      = random_password.dtgtwy_password[count.index].result
#   network_interface_ids = [azurerm_network_interface.dtgwnic[count.index].id]

#   os_disk {
#     name                 = "${var.product}-dtgtwy${count.index}-osdisk-${var.env}"
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#     disk_encryption_set_id  = azurerm_disk_encryption_set.pre-des.id
#   }
#   identity {
#     type = "SystemAssigned"
#   }
  
#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2019-datacenter-gensecond"
#     version   = "latest"
#   }
#   enable_automatic_updates = true
#   provision_vm_agent       = true  
#   tags                     = var.common_tags

#   depends_on = [ module.key-vault]
# }


