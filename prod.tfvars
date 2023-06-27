# sa_account_tier             = "Premium"
# sa_replication_type         = "GRS"
vnet_address_space         = "10.101.3.0/24"
video_edit_vm_snet_address = "10.101.3.0/26"
privatendpt_snet_address   = "10.101.3.64/26"
bastion_snet_address       = "10.101.3.128/26"
data_gateway_snet_address  = "10.101.3.192/26"
num_vid_edit_vms           = 1

mgmt_net_name             = "ss-ptl-vnet"
mgmt_net_rg_name          = "ss-ptl-network-rg"
mgmt_subscription_id      = "6c4d2513-a873-41b4-afdd-b05a33206631"
managed_oid               = "2008e85a-5f57-4a54-870e-abbacd6b4d09" # 2008e85a-5f57-4a54-870e-abbacd6b4d09
dts_pre_oid               = "b1fd4154-355f-4683-a795-d09cdb814d16"
dts_cft_developers_oid    = "d5c01893-b8bc-40ce-926c-d6faf53e0af5"
power_app_user_oid        = "2757c27a-aa98-4cdf-9aaa-90cf47d0656c"
dts_pre_app_admin         = "d055ba21-5814-4278-8752-aaffa7eaac62"
dts_pre_project_admin     = "56a29187-3d5f-4262-99d6-c635776e0eac"
pre_mi_principal_id       = "d03f73e6-40ed-40a2-a0ec-059286505905"
pre_mi_tenant_id          = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
dts_pre_appreg_oid        = "4f732c4d-d113-4a09-928d-6c035a26629b"
dts_pre_ent_appreg_oid    = "bec31833-3791-4d2a-80cc-871f5582f128"
dts_pre_backup_appreg_oid = "8cb76e1e-ef5a-41a7-9cb4-9513a48535dc"
PeeringFromHubName        = "pre-recorded-evidence-prod"
pg_databases = [
  {
    name : "pre-pdb-prod"
  }
]

retention_duration         = "P100D"
restore_policy_days        = "100"
immutability_period_backup = "2557"

tenant_id                = "ebe20728"
dg_vm_private_ip         = ["10.101.3.222", "10.101.3.223"]
powerbi_dg_vm_private_ip = ["10.101.3.224", "10.101.3.225"]
edit_vm_private_ip       = ["10.101.3.6", "10.101.3.7"]
pre_ent_appreg_app_id    = "a4e4402d-25a8-40aa-ba12-ad040350086e"


edit_vm_data_disks = [{
  datadisk1 = {
    name                 = "edit-vm01-data-prod"
    location             = "uksouth"
    resource_group_name  = "pre-prod"
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
      name                 = "edit-vm02-data-prod"
      location             = "uksouth"
      resource_group_name  = "pre-prod"
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
    name                 = "data-gateway-vm01-data-prod"
    location             = "uksouth"
    resource_group_name  = "pre-prod"
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
      name                 = "data-gateway-vm02-data-prod"
      location             = "uksouth"
      resource_group_name  = "pre-prod"
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
    name                 = "powerbi-dg1-data-prod"
    location             = "uksouth"
    resource_group_name  = "pre-prod"
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
      name                 = "powerbi-dg2-data-prod"
      location             = "uksouth"
      resource_group_name  = "pre-prod"
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