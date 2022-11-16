vnet_address_space          = "10.101.0.0/24"
video_edit_vm_snet_address  = "10.101.0.0/26" 
privatendpt_snet_address    = "10.101.0.64/26" 
bastion_snet_address        = "10.101.0.128/26" 
data_gateway_snet_address   = "10.101.0.192/26" 
num_vid_edit_vms            = 1
mgmt_net_name               = "ss-ptl-vnet"
mgmt_net_rg_name            = "ss-ptl-network-rg"
power_app_user_oid          = "2757c27a-aa98-4cdf-9aaa-90cf47d0656c"
managed_oid                 = "2008e85a-5f57-4a54-870e-abbacd6b4d09" # 2008e85a-5f57-4a54-870e-abbacd6b4d09
dts_pre_oid                 = "b1fd4154-355f-4683-a795-d09cdb814d16"
dts_cft_developers_oid      = "b2a1773c-a5ae-48b5-b5fa-95b0e05eee05"
dts_pre_project_admin       = "56a29187-3d5f-4262-99d6-c635776e0eac"
dts_pre_app_admin           = "d055ba21-5814-4278-8752-aaffa7eaac62"
devops_admin                = "64e5c2d9-c957-4038-873f-7eb4e6250c7d"
pre_mi_principal_id         = "d03f73e6-40ed-40a2-a0ec-059286505905"
pre_mi_tenant_id            = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"

# managed_oid                 = "2008e85a-5f57-4a54-870e-abbacd6b4d09" # 2008e85a-5f57-4a54-870e-abbacd6b4d09
# dts_pre_oid                 = "b1fd4154-355f-4683-a795-d09cdb814d16"
# dts_cft_developers_oid      = "b2a1773c-a5ae-48b5-b5fa-95b0e05eee05"
# dts_pre_project_admin       = "56a29187-3d5f-4262-99d6-c635776e0eac"
# # env                         = "stg"
pg_databases = [
  {
    name : "pre-pdb-stg"
  }
]
