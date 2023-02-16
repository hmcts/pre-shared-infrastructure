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

variable "dts_pre_ent_appreg_oid" {
  default = "9168b884-7ccd-4e71-860f-7f63455818e1"
}

variable "builtFrom" {
  description = "The GitHub URL for the repository that contains the infrastructure code."
  default     = "hmcts/pre-shared-infrastructure"
}