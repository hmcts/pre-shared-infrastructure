variable "prefix" {
  default = "pre"
}

variable "location" {
  default = "UK South"
}

variable "env" {}

variable "PrivateDNSZone" {
  default = "private.postgres.database.azure.com"
}

variable "DNSResGroup" {
  default = "core-infra-intsvc-rg"
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
