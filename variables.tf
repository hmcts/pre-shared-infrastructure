variable "product" {
  default = "pre"
}

variable "location" {
  default = "UK South"
}

variable "env" {}

variable "jenkins_AAD_objectId" {}

variable "common_tags" {
  type = map(string)
}

variable "sa_account_tier" {
  default = "Standard"
}

variable "sa_replication_type" {
  default = "GRS"
}

variable "vnet_address_space" {}

variable "video_edit_vm_snet_address" {}

variable "privatendpt_snet_address" {}

variable "bastion_snet_address" {}

variable "data_gateway_snet_address" {}

variable "mgmt_net_rg_name" {}

variable "num_vid_edit_vms" {
  default = 2
}

variable "num_datagateway" {
  default = 2
}

variable "mgmt_net_name" {}

variable "mgmt_subscription_id" {} // set by jenkins library

variable "jenkins_ptlsbox_oid" {
  default = "6df94cb5-c203-4493-bc8a-3f6aad1133e1"
}
variable "jenkins_ptlsbox_appid" {
  default = "a87b3880-6dce-4f9d-b4c4-c4cf3622cb5d"
}

variable "schedules" {
  type = list(object({
    name      = string
    frequency = string
    interval  = number
    run_time  = string
    start_vm  = bool
  }))
  default = []
}

# Dynatrace
variable "dynatrace_server" {
  description = "The server URL, if you want to configure an alternative communication endpoint."
  type        = string
  default     = null
}

variable "server" {
  default = null
}
variable "hostgroup" {
  default = null
}

# Addtional variables required for postgres

// 2 variables with the same value???? see var "product"

variable "project" {
  default = "sds"
}

variable "pgsql_admin_username" {
  default = "psqladmin"
}

variable "database_name" {
  default = "pre-db"
}

variable "pgsql_storage_mb" {
  default = "32768"
}

variable "zone" {
  description = "Availability Zone for Postgres"
  default     = "1"
}

# Private DNS zone configuration (for postgres)
variable "dns_resource_group" {
  default = "core-infra-intsvc-rg"
}

variable "private_dns_zone" {
  default = "private.postgres.database.azure.com"
}

variable "dts_pre_ent_appreg_oid" {}

variable "cors_rules" {
  type = list(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  description = "cors rule for final storage account"
  default = [
    {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "POST"]
      allowed_origins    = ["https://*.justice.gov.uk", "https://*.blob.core.windows.net", "https://*.files.core.windows.net"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 600
    }
  ]
}

variable "retention_duration" {}

variable "tenant_id" {}

variable "vm_type" {
  default = "windows"
}

variable "dg_vm_data_disks" {}

variable "edit_vm_data_disks" {}

variable "powerbi_dg_vm_data_disks" {}

variable "dg_vm_private_ip" {}

variable "powerbi_dg_vm_private_ip" {}

variable "edit_vm_private_ip" {}

variable "install_dynatrace_oa" {
  default = true
}

# variable "pre_app_admin" {}

variable "pre_ent_appreg_app_id" {}

variable "aks_subscription_id" {
  default = "867a878b-cb68-4de5-9741-361ac9e178b6"
}

variable "location_backup" {
  default = "UK West"
}

variable "dts_pre_backup_appreg_oid" {}

variable "immutability_period_backup" {}

variable "restore_policy_days" {}

variable "cnp_vault_sub" {
  description = "The subscription ID of the subscription that contains the CNP KeyVault"
  type        = string
}
