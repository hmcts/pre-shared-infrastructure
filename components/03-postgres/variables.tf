variable "prefix" {
  default = "pre"
}

variable "product" {
  default = "pre"
}

variable "location" {
  default = "UK South"
}

variable "env" {}

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

# variable "dts_pre_ent_appreg_oid" {
#   default = "9168b884-7ccd-4e71-860f-7f63455818e1"
# }

# variable "jenkins-mi" {
#   default = "jenkins-ptl-mi" #"7ef3b6ce-3974-41ab-8512-c3ef4bb8ae01"
# }

# variable "dts_pre_ent_appreg_oid" {}

variable "builtFrom" {
  description = "The GitHub URL for the repository that contains the infrastructure code."
  default     = "hmcts/pre-shared-infrastructure"
}

# variable "PrivateDNSZone" {
#   default = "private.postgres.database.azure.com"
# }

# variable "DNSResGroup" {
#   default = "core-infra-intsvc-rg"
# }
