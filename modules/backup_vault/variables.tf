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

# variable "storageaccount_id" {
# }

variable "storageaccount_ids" {
}

variable "rg_name" {}

variable "sa_name" {}