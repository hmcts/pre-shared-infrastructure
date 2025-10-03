#network
vnet_address_space         = "10.40.12.0/26"
video_edit_vm_snet_address = "10.40.12.0/28"
privatendpt_snet_address   = "10.40.12.32/28"
bastion_snet_address       = "10.40.12.48/28"
mgmt_net_name              = "ss-ptl-vnet"
mgmt_net_rg_name           = "ss-ptl-network-rg"
mgmt_subscription_id       = "6c4d2513-a873-41b4-afdd-b05a33206631"

#identities
dts_pre_ent_appreg_oid    = "9168b884-7ccd-4e71-860f-7f63455818e1" # dts_pre_dev enterprise app/sp
pre_ent_appreg_app_id     = "7394ca1a-31de-4433-beca-2ca1a2043d5c"
dts_pre_backup_appreg_oid = "7716f08a-c384-4113-bf26-05a04a1f909b"

#backups
retention_duration         = "P1D"
immutability_period_backup = "1"
restore_policy_days        = "1"

#vms
num_vid_edit_vms   = 0
tenant_id          = "yrk32651"
edit_vm_private_ip = ["10.40.12.6", "10.40.12.7"]

edit_vm_data_disks = [{
  datadisk1 = {
    name                 = "edit-vm01-data-dev"
    location             = "uksouth"
    resource_group_name  = "pre-dev"
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
      name                 = "edit-vm02-data-dev"
      location             = "uksouth"
      resource_group_name  = "pre-dev"
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

# Dynatrace
cnp_vault_sub = "1c4f0704-a29e-403d-b719-b90c34ef14c9"

apim_service_url = "https://pre-api.dev.platform.hmcts.net"

pre_apim_b2c_app_object_id = "cf334c63-1719-4c8e-a959-fe017d1ad8be"