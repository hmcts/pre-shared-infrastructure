#network
mgmt_net_name        = "ss-ptl-vnet"
mgmt_net_rg_name     = "ss-ptl-network-rg"
mgmt_subscription_id = "6c4d2513-a873-41b4-afdd-b05a33206631"

#identities
dts_pre_backup_appreg_oid = "8cb76e1e-ef5a-41a7-9cb4-9513a48535dc"

#backups
restore_policy_days = "1"

#  storage lifecycle management enabled
delete_after_days_since_creation_greater_than = 90
storage_policy_enabled                        = true

cnp_vault_sub = "1c4f0704-a29e-403d-b719-b90c34ef14c9"