variable "location_backup" {
  default = "UK West"
}

variable "role_assignments" {
  type        = list(string)
  description = "List of roles to assign to the provided Managed Identity"
  default     = ["Storage Account Backup Contributor"]
}

variable "retention_duration" {}

variable "product" {}

variable "env" {}

variable "location" {}

variable "storageaccount_ids" {
  type        = list(string)
  description = "List of storage accounts to take a backup of"
  default     = []
}

# variable "storageaccount_name" {}

variable "rg_name" {}