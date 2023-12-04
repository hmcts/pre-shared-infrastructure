variable "product" {}

variable "env" {}

variable "location" {}

variable "storageaccount_ids" {
  type        = list(string)
  description = "List of storage accounts to take a backup of"
  default     = []
}

variable "location_backup" {
  default = "UK West"
}

variable "role_assignments" {
  type        = list(string)
  description = "List of roles to assign to the provided Managed Identity"
  default     = ["Storage Account Backup Contributor"]
}

variable "retention_duration" {}

variable "rg_name" {}

variable "service_principal" {}

variable "sa_account_tier" {
  default = "Standard"
}

variable "immutability_period_backup" {}

variable "sa_subnets" {}

variable "common_tags" {}