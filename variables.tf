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
    "4.158.0.0/15",
    "4.234.0.0/16",
    "4.250.0.0/16",
    "13.87.64.0/19",
    "13.87.96.0/20",
    "13.104.129.128/26",
    "13.104.145.160/27",
    "13.104.146.64/26",
    "13.104.159.0/25",
    "20.0.0.0/16",
    "20.26.0.0/16",
    "20.38.106.0/23",
    "20.39.208.0/20",
    "20.39.224.0/21",
    "20.47.11.0/24",
    "20.47.34.0/24",
    "20.47.68.0/24",
    "20.47.114.0/24",
    "20.49.128.0/17",
    "20.50.96.0/19",
    "20.58.0.0/18",
    "20.60.17.0/24",
    "20.60.166.0/23",
    "20.68.0.0/18",
    "20.68.128.0/17",
    "20.77.0.0/17",
    "20.77.128.0/18",
    "20.90.64.0/18",
    "20.90.128.0/17",
    "20.95.67.0/24",
    "20.95.74.0/23",
    "20.95.82.0/23",
    "20.95.84.0/24",
    "20.108.0.0/16",
    "20.117.64.0/18",
    "20.117.128.0/17",
    "20.135.176.0/22",
    "20.135.180.0/23",
    "20.150.18.0/25",
    "20.150.40.0/25",
    "20.150.41.0/24",
    "20.150.69.0/24",
    "20.157.28.0/24",
    "20.157.107.0/24",
    "20.157.112.0/24",
    "20.157.120.0/24",
    "20.157.157.0/24",
    "20.157.182.0/24",
    "20.157.246.0/24",
    "20.162.128.0/17",
    "20.190.143.0/25",
    "20.190.169.0/24",
    "20.202.4.0/24",
    "20.209.6.0/23",
    "20.209.30.0/23",
    "20.209.88.0/23",
    "20.254.0.0/17",
    "40.64.144.0/24",
    "40.79.215.0/24",
    "40.80.0.0/22",
    "40.81.128.0/19",
    "40.90.17.32/27",
    "40.90.17.160/27",
    "40.90.29.192/26",
    "40.90.128.112/28",
    "40.90.128.160/28",
    "40.90.131.64/27",
    "40.90.139.64/27",
    "40.90.141.192/26",
    "40.90.153.64/27",
    "40.90.154.0/26",
    "40.93.67.0/24",
    "40.120.32.0/19",
    "40.120.136.0/22",
    "40.126.15.0/25",
    "40.126.41.0/24",
    "51.11.0.0/18",
    "51.11.128.0/18",
    "51.104.0.0/19",
    "51.104.192.0/18",
    "51.105.0.0/18",
    "51.105.64.0/20",
    "51.132.0.0/18",
    "51.132.128.0/17",
    "51.140.0.0/17",
    "51.140.128.0/18",
    "51.141.128.32/27",
    "51.141.129.64/26",
    "51.141.130.0/25",
    "51.141.135.0/24",
    "51.141.192.0/18",
    "51.142.64.0/18",
    "51.142.192.0/18",
    "51.143.128.0/18",
    "51.143.208.0/20",
    "51.143.224.0/19",
    "51.145.0.0/17",
    "52.101.88.0/23",
    "52.101.95.0/24",
    "52.101.96.0/23",
    "52.102.164.0/24",
    "52.103.37.0/24",
    "52.103.165.0/24",
    "52.108.50.0/23",
    "52.108.88.0/24",
    "52.108.99.0/24",
    "52.108.100.0/23",
    "52.109.28.0/22",
    "52.111.242.0/24",
    "52.112.231.0/24",
    "52.112.240.0/20",
    "52.113.128.0/24",
    "52.113.200.0/22",
    "52.113.204.0/24",
    "52.113.224.0/19",
    "52.114.88.0/22",
    "52.120.160.0/19",
    "52.120.240.0/20",
    "52.123.141.0/24",
    "52.123.142.0/23",
    "52.136.21.0/24",
    "52.151.64.0/18",
    "52.239.187.0/25",
    "52.239.231.0/24",
    "52.245.64.0/22",
    "52.253.162.0/23",
    "104.44.89.224/27",
    "172.165.0.0/16",
    "172.166.0.0/15",
    "172.187.128.0/17",
    "13.87.0.0/18",
    "20.150.27.0/24",
    "20.190.172.0/24",
    "40.79.201.0/24",
    "40.80.12.0/22",
    "40.81.160.0/20",
    "40.90.130.128/28",
    "40.90.143.64/27",
    "40.90.150.96/27",
    "40.126.44.0/24",
    "51.141.129.192/26",
    "51.141.156.0/22",
    "51.142.40.11",
    "51.142.47.249",
    "51.142.47.252",
    "51.143.192.0/21",
    "51.143.200.0/28",
    "51.143.201.0/24",
    "52.108.138.0/24",
    "52.109.40.0/22",
    "52.136.18.0/24",
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


