variable "product" {
  default = "pre"
}

variable "location" {
  default = "UK South"
}

variable "subscription" {
  default = ""
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

variable "mgmt_net_name" {}

variable "mgmt_net_rg_name" {}

variable "num_vid_edit_vms" {
  default = 2
}
variable "vid_edit_vm_spec" {
  default = "Standard_E4s_v4"
}
variable "num_datagateway" {
  default = 2
}
variable "datagateway_spec" {
  default = "Standard_F8s_v2"
}

variable "mgmt_subscription_id" {} // set by jenkins library

variable "power_app_user_oid" {
  default = "56a29187-3d5f-4262-99d6-c635776e0eac"
}
variable "jenkins_ptlsbox_oid" {
  default = "6df94cb5-c203-4493-bc8a-3f6aad1133e1"
}
variable "jenkins_ptlsbox_appid" {
  default = "a87b3880-6dce-4f9d-b4c4-c4cf3622cb5d"
}
variable "managed_oid" {}
variable "dts_pre_oid" {}
variable "dts_cft_developers_oid" {}
variable "dts_pre_project_admin" {}
variable "pre_mi_principal_id" {}
variable "pre_mi_tenant_id" {}
variable "dts_pre_app_admin" {}

variable "lawRetention" {
  type    = number
  default = "30"
}
variable "ip_rules" {
  description = "PowerPlatformInfra.UKSouth"
  type        = list(string)
  default = [
    "20.49.145.249/32",
    "20.49.166.40/32",
    "20.49.166.118/32",
    "20.49.166.129/32",
    "20.49.244.238/32",
    "20.90.131.0/26",
    "20.90.131.64/27",
    "20.90.131.120/29",
    "20.90.169.112/32",
    "20.90.240.169/32",
    "20.108.81.107/32",
    "51.11.24.198/32",
    "51.11.25.68/32",
    "51.11.25.172/32",
    "51.11.172.30/32",
    "51.11.172.56/32",
    "51.11.172.160/32",
    "51.104.30.172/30",
    "51.104.30.192/26",
    "51.104.31.0/27",
    "51.104.31.32/28",
    "51.104.31.48/29",
    "51.104.31.64/26",
    "51.104.248.11/32",
    "51.132.161.225/32",
    "51.132.215.162/32",
    "51.132.215.182/32",
    "51.142.209.113/32",
    "51.143.208.216/29",
    "51.145.104.29/32"
    "20.58.71.128/26",
    "20.58.71.192/27",
    "20.68.125.79/32",
    "20.77.240.43/32",
    "20.90.32.128/29",
    "40.81.113.131/32",
    "40.81.116.141/32",
    "40.81.116.143/32",
    "40.81.116.223/32",
    "40.81.117.23/32",
    "51.104.36.212/32",
    "51.132.68.126/32",
    "51.132.72.50/32",
    "51.132.72.181/32",
    "51.132.73.95/32",
    "51.137.136.98/32",
    "51.137.137.158/31",
    "51.137.137.224/32",
    "51.137.137.235/32",
    "51.137.164.224/27",
    "51.137.165.192/26",
    "51.137.166.0/28",
    "51.137.166.16/29",
    "51.137.166.24/30",
    "51.137.166.64/26",
    "51.137.167.176/29",
    "51.137.180.86/32",
    "51.142.162.40/32",
    "52.142.168.104/32"
    "51.140.77.227",
    "51.140.245.29",
    "51.140.80.51", 
    "51.140.61.124",
    "51.141.47.105",
    "51.141.124.13",
    "20.90.125.211",
    "20.90.124.134",
    "51.105.77.96/27",
    "51.140.148.0/28",
    "51.140.211.0/28",
    "51.140.212.224/27",
    "20.90.129.0/27", 
    "20.90.129.32/28",
    "20.58.70.192/27",
    "20.58.70.224/28",
    "86.24.226.11",  #Chris
    "82.21.185.208", # Oli
    "62.31.90.131",  #Indy
    "82.12.61.131",  #Ayisha
    "86.179.180.2",  #Darren
  ]
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

variable "component" {
  default = "pre"
}

variable "project" {
  default = "sds"
}

variable "pgsql_admin_username" {
  default = "psqladmin"
}

variable "pg_databases" {
  description = "Databases to be deployed"
}

variable "database_name" {
  default = "pre-db"
}

variable "pgsql_sku" {
  default = "GP_Standard_D2s_v3"
}

variable "pgsql_storage_mb" {
  default = "32768"
}

variable "zone" {
  description = "Availability Zone for Postgres"
  default     = "1"
}

# Private DNS zone configuration (for postgres)
variable "DNSResGroup" {
  default = "core-infra-intsvc-rg"
}

variable "PrivateDNSZone" {
  default = "private.postgres.database.azure.com"
}

variable "dts_pre_appreg_oid" {}

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

variable "PeeringFromHubName" {
  default = "pre-recorded-evidence"
}

variable "retention_duration" {}


