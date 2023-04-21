vnet_address_space         = "10.40.12.0/26"
video_edit_vm_snet_address = "10.40.12.0/28"
data_gateway_snet_address  = "10.40.12.16/28"
privatendpt_snet_address   = "10.40.12.32/28"
bastion_snet_address       = "10.40.12.48/28"
num_vid_edit_vms           = 1
mgmt_net_name              = "ss-ptl-vnet"
mgmt_net_rg_name           = "ss-ptl-network-rg"
env                        = "dev"
#dts_cft_developers_oid = "b2a1773c-a5ae-48b5-b5fa-95b0e05eee05" #giving cft-developers additional access to our vault for some reason
# dts_pre_project_admin      = "56a29187-3d5f-4262-99d6-c635776e0eac" #TO BE ADDED WHEN AVAILABLE
#pre_mi_principal_id        = "d03f73e6-40ed-40a2-a0ec-059286505905" #they're all declaring pre-demo-mi but doesn't look like it's being called anywhere
#pre_mi_tenant_id           = "531ff96d-0ae9-462a-8d2d-bec7c0b42082" #likely useless

pre_app_admin = "8d48024b-9a39-4777-94b0-0751f0cb3832"

# dts_pre_appreg_oid     = "b521e9e3-58e1-4c25-98b5-7f3157f68c16" # dts_pre_devapp reg
dts_pre_ent_appreg_oid = "9168b884-7ccd-4e71-860f-7f63455818e1" # dts_pre_dev enterprise app/sp
pre_ent_appreg_app_id  = "7394ca1a-31de-4433-beca-2ca1a2043d5c"
# PeeringFromHubName     = "pre-recorded-evidence-dev"
mgmt_subscription_id = "6c4d2513-a873-41b4-afdd-b05a33206631"
# retention_duration   = "P8D"

dg_vm_private_ip = ["10.40.12.22", "10.40.12.23"]

powerbi_dg_vm_private_ip = ["10.40.12.24", "10.40.12.25"]

edit_vm_private_ip = ["10.40.12.6", "10.40.12.7"]

tenant_id = "yrk32651"

retention_duration = "P8D"
# cnp_vault_sub  = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
# cnp_vault_rg   = "cnp-core-infra"
# data disks
dg_vm_data_disks = [{
  datadisk1 = {
    name                 = "data-gateway-vm01-data-dev"
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
      name                 = "data-gateway-vm02-data-dev"
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

powerbi_dg_vm_data_disks = [{
  datadisk1 = {
    name                 = "data-gateway-vm01-data-dev"
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
      name                 = "data-gateway-vm02-data-dev"
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