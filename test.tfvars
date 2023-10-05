#network
env                        = "test"
vnet_address_space         = "10.70.21.0/24"
video_edit_vm_snet_address = "10.70.21.0/26"
privatendpt_snet_address   = "10.70.21.64/26"
bastion_snet_address       = "10.70.21.128/26"
data_gateway_snet_address  = "10.70.21.192/26"
num_vid_edit_vms           = 2
mgmt_net_name              = "ss-ptl-vnet"
mgmt_net_rg_name           = "ss-ptl-network-rg"
mgmt_subscription_id       = "6c4d2513-a873-41b4-afdd-b05a33206631"
PeeringFromHubName         = "pre-recorded-evidence-test"

#identities
dts_pre_project_admin     = "56a29187-3d5f-4262-99d6-c635776e0eac"
pre_app_admin             = "dbe1ceab-c6a0-4155-8f9c-060dbbbd5c2a"
pre_mi_principal_id       = "d03f73e6-40ed-40a2-a0ec-059286505905"
pre_mi_tenant_id          = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
dts_pre_appreg_oid        = "913743c8-60eb-4cca-a15c-2033db5118cd"
dts_pre_ent_appreg_oid    = "fd9eddbb-3ec9-4fda-81fc-d518d4718a70"
pre_ent_appreg_app_id     = "66930c25-cbaa-4b9b-81ab-bea600666acb"
dts_pre_backup_appreg_oid = "7716f08a-c384-4113-bf26-05a04a1f909b"

#backups
retention_duration         = "P7D"
immutability_period_backup = "7"
restore_policy_days        = "1"

#vms
tenant_id                = "yrk32651"
dg_vm_private_ip         = ["10.70.21.198", "10.70.21.199"]
powerbi_dg_vm_private_ip = ["10.70.21.221", "10.70.21.222"]
edit_vm_private_ip       = ["10.70.21.6", "10.70.21.7"]

edit_vm_data_disks = [{
  datadisk1 = {
    name                 = "edit-vm01-data-test"
    location             = "uksouth"
    resource_group_name  = "pre-test"
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
      name                 = "edit-vm02-data-test"
      location             = "uksouth"
      resource_group_name  = "pre-test"
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
    name                 = "data-gateway-vm01-data-test"
    location             = "uksouth"
    resource_group_name  = "pre-test"
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
      name                 = "data-gateway-vm02-data-test"
      location             = "uksouth"
      resource_group_name  = "pre-test"
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
    name                     = "powerbi-dg1-data-test"
    location                 = "uksouth"
    resource_group_name      = "pre-test"
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
      name                     = "powerbi-dg2-data-test"
      location                 = "uksouth"
      resource_group_name      = "pre-test"
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
