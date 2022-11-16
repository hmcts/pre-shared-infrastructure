vnet_address_space          = "10.50.12.0/24"
video_edit_vm_snet_address  = "10.50.12.0/26"
privatendpt_snet_address    = "10.50.12.64/26"
bastion_snet_address        = "10.50.12.128/26"  
data_gateway_snet_address   = "10.50.12.192/26"

num_vid_edit_vms            = 1
mgmt_net_name               = "ss-ptl-vnet"
mgmt_net_rg_name            = "ss-ptl-network-rg"
# mgmt_subscription_id      = "64b1c6d6-1481-44ad-b620-d8fe26a2c768"
env                         = "demo"
# app_id                    = "a87b3880-6dce-4f9d-b4c4-c4cf3622cb5d"
# app_oid                   = "6df94cb5-c203-4493-bc8a-3f6aad1133e1"
power_app_user_oid          = "f6991ff8-d675-4f54-b2ba-99af86a8e01c"
managed_oid                 = "8fddd15b-724c-41ab-829c-d85b969a81f9" # or 806e3063-e10b-40f8-be91-ec916cfad103
dts_pre_oid                 = "b1fd4154-355f-4683-a795-d09cdb814d16" #DTS Pre-recorded Evidence
dts_cft_developers_oid      = "b2a1773c-a5ae-48b5-b5fa-95b0e05eee05" # DTS CFT Developers
dts_pre_project_admin       = "56a29187-3d5f-4262-99d6-c635776e0eac" # DTS-PRE-Project Admin DTS-PRE-Project@HMCTS.NET 
dts_pre_app_admin           = "d055ba21-5814-4278-8752-aaffa7eaac62" # DTS-PRE-App-Sbx Admin
devops_admin                = "64e5c2d9-c957-4038-873f-7eb4e6250c7d" #Devops
pre_mi_principal_id         = "d03f73e6-40ed-40a2-a0ec-059286505905" #pre-demo-mi
pre_mi_tenant_id            = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
#"ManagedIdentityname": "pre-demo-mi",
pg_databases = [
  {
    name : "pre-pdb-demo"
  }
]