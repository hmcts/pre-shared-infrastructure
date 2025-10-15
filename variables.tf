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

variable "mgmt_net_rg_name" {}

variable "mgmt_net_name" {}

variable "mgmt_subscription_id" {} // set by jenkins library

# Addtional variables required for postgres
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

# Private DNS zone configuration (for postgres)
variable "dns_resource_group" {
  default = "core-infra-intsvc-rg"
}

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

#storage lifecycle management
variable "delete_after_days_since_creation_greater_than" {
  type        = number
  default     = 90
  description = "Number of days to keep an ingest file for before deleting it. Default 90 days"
}

#  storage lifecycle management enabled
variable "storage_policy_enabled" {
  type        = bool
  default     = false
  description = "Status of the storage account lifecycle policy. Default 'false'"
}

variable "aks_subscription_id" {
  default = "867a878b-cb68-4de5-9741-361ac9e178b6"
}

variable "dts_pre_backup_appreg_oid" {}

variable "restore_policy_days" {}

variable "cnp_vault_sub" {
  description = "The subscription ID of the subscription that contains the CNP KeyVault"
}

variable "dev_subscription_id" {
  default = "867a878b-cb68-4de5-9741-361ac9e178b6"
}

variable "stg_subscription_id" {
  default = "74dacd4f-a248-45bb-a2f0-af700dc4cf68"
}