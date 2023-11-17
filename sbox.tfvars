#network
env                        = "sbox"
vnet_address_space         = "10.48.1.0/24"
video_edit_vm_snet_address = "10.48.1.0/28"
privatendpt_snet_address   = "10.48.1.64/26"
bastion_snet_address       = "10.48.1.128/26"
data_gateway_snet_address  = "10.48.1.192/26"
mgmt_net_name              = "ss-ptlsbox-vnet"
mgmt_net_rg_name           = "ss-ptlsbox-network-rg"
mgmt_subscription_id       = "64b1c6d6-1481-44ad-b620-d8fe26a2c768"

#identities
pre_mi_tenant_id          = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
dts_pre_ent_appreg_oid    = "c7ee0cd6-a440-49e9-8eb8-d050a49a5962"
pre_ent_appreg_app_id     = "07587e3c-603e-401f-98d1-ff26206e93f8"
dts_pre_backup_appreg_oid = "7716f08a-c384-4113-bf26-05a04a1f909b"

#backups
retention_duration         = "P1D"
immutability_period_backup = "1"
restore_policy_days        = "1"

#vms
powerbi_dg_vm_private_ip = ["10.48.1.225", "10.48.1.226"]
dg_vm_private_ip         = ["10.48.1.222", "10.48.1.223"]
edit_vm_private_ip       = ["10.48.1.7", "10.48.1.8"]
tenant_id                = "yrk32651"
num_vid_edit_vms         = 1
edit_vm_data_disks = [{
  datadisk1 = {
    name                 = "edit-vm01-data-sbox"
    location             = "uksouth"
    resource_group_name  = "pre-sbox"
    storage_account_type = "StandardSSD_LRS"
    disk_create_option   = "Empty"
    disk_size_gb         = "1000"
    disk_tier            = null
    disk_zone            = "1"
    source_resource_id   = null
    storage_account_id   = null
    hyper_v_generation   = null
    os_type              = null


    disk_lun                 = "10"
    attachment_create_option = "Attach"
    disk_caching             = "ReadWrite"

  }
  },
  {
    datadisk1 = {
      name                 = "edit-vm02-data-sbox"
      location             = "uksouth"
      resource_group_name  = "pre-sbox"
      storage_account_type = "StandardSSD_LRS"
      disk_create_option   = "Empty"
      disk_size_gb         = "1000"
      disk_tier            = null
      disk_zone            = "2"
      source_resource_id   = null
      storage_account_id   = null
      hyper_v_generation   = null
      os_type              = null


      disk_lun                 = "10"
      attachment_create_option = "Attach"
      disk_caching             = "ReadWrite"

    }
}]


dg_vm_data_disks = [{
  datadisk1 = {
    name                 = "data-gateway-vm01-data-sbox"
    location             = "uksouth"
    resource_group_name  = "pre-sbox"
    storage_account_type = "StandardSSD_LRS"
    disk_create_option   = "Empty"
    disk_size_gb         = "1000"
    disk_tier            = null
    disk_zone            = "1"
    source_resource_id   = null
    storage_account_id   = null
    hyper_v_generation   = null
    os_type              = null


    disk_lun                 = "10"
    attachment_create_option = "Attach"
    disk_caching             = "ReadWrite"

  }
  },
  {
    datadisk1 = {
      name                 = "data-gateway-vm02-data-sbox"
      location             = "uksouth"
      resource_group_name  = "pre-sbox"
      storage_account_type = "StandardSSD_LRS"
      disk_create_option   = "Empty"
      disk_size_gb         = "1000"
      disk_tier            = null
      disk_zone            = "2"
      source_resource_id   = null
      storage_account_id   = null
      hyper_v_generation   = null
      os_type              = null


      disk_lun                 = "10"
      attachment_create_option = "Attach"
      disk_caching             = "ReadWrite"

    }
}]
powerbi_dg_vm_data_disks = [{
  datadisk1 = {
    name                     = "powerbi-dg1-data-sbox"
    location                 = "uksouth"
    resource_group_name      = "pre-sbox"
    storage_account_type     = "StandardSSD_LRS"
    disk_create_option       = "Empty"
    disk_size_gb             = "1000"
    disk_tier                = null
    disk_zone                = "1"
    source_resource_id       = null
    storage_account_id       = null
    hyper_v_generation       = null
    os_type                  = null
    disk_lun                 = "10"
    attachment_create_option = "Attach"
    disk_caching             = "ReadWrite"
  }
  },
  {
    datadisk1 = {
      name                     = "powerbi-dg2-data-sbox"
      location                 = "uksouth"
      resource_group_name      = "pre-sbox"
      storage_account_type     = "StandardSSD_LRS"
      disk_create_option       = "Empty"
      disk_size_gb             = "1000"
      disk_tier                = null
      disk_zone                = "2"
      source_resource_id       = null
      storage_account_id       = null
      hyper_v_generation       = null
      os_type                  = null
      disk_lun                 = "10"
      attachment_create_option = "Attach"
      disk_caching             = "ReadWrite"
    }
}]

# Dynatrace
cnp_vault_sub = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
