vnet_address_space         = "10.101.0.0/24"
video_edit_vm_snet_address = "10.101.0.0/26"
privatendpt_snet_address   = "10.101.0.64/26"
bastion_snet_address       = "10.101.0.128/26"
data_gateway_snet_address  = "10.101.0.192/26"
num_vid_edit_vms           = 1
mgmt_net_name              = "ss-ptl-vnet"
mgmt_net_rg_name           = "ss-ptl-network-rg"
mgmt_subscription_id       = "6c4d2513-a873-41b4-afdd-b05a33206631"
power_app_user_oid         = "2757c27a-aa98-4cdf-9aaa-90cf47d0656c"
# managed_oid                = "2008e85a-5f57-4a54-870e-abbacd6b4d09"
dts_pre_oid           = "b1fd4154-355f-4683-a795-d09cdb814d16"
dts_pre_project_admin = "56a29187-3d5f-4262-99d6-c635776e0eac"
# dts_pre_app_admin         = "d055ba21-5814-4278-8752-aaffa7eaac62"
pre_mi_tenant_id          = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
dts_pre_appreg_oid        = "1043d250-96eb-4cc3-af11-3215cfbf028f"
dts_pre_ent_appreg_oid    = "0f7b27ab-60b6-4682-8491-8e4eb5498dad"
dts_pre_backup_appreg_oid = "8cb76e1e-ef5a-41a7-9cb4-9513a48535dc"

retention_duration         = "P1D"
restore_policy_days        = "1"
immutability_period_backup = "1"

tenant_id                = "yrk32651"
dg_vm_private_ip         = ["10.101.0.222", "10.101.0.223"]
powerbi_dg_vm_private_ip = ["10.101.0.224", "10.101.0.225"]
edit_vm_private_ip       = ["10.101.0.6", "10.101.0.7"]
pre_ent_appreg_app_id    = "2f4bf1fd-543c-4332-bc26-7a524f52d375"

# VM Bootstrap module
cnp_vault_sub = "1c4f0704-a29e-403d-b719-b90c34ef14c9"

edit_vm_data_disks = [{
  datadisk1 = {
    name                 = "edit-vm01-data-stg"
    location             = "uksouth"
    resource_group_name  = "pre-stg"
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
      name                 = "edit-vm02-data-stg"
      location             = "uksouth"
      resource_group_name  = "pre-stg"
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
    name                 = "data-gateway-vm01-data-stg"
    location             = "uksouth"
    resource_group_name  = "pre-stg"
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
      name                 = "data-gateway-vm02-data-stg"
      location             = "uksouth"
      resource_group_name  = "pre-stg"
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
    name                 = "powerbi-dg1-data-stg"
    location             = "uksouth"
    resource_group_name  = "pre-stg"
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
      name                 = "powerbi-dg2-data-stg"
      location             = "uksouth"
      resource_group_name  = "pre-stg"
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
