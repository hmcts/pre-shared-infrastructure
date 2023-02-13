variable "product" {
  default = "pre-recorded-evidence"
}

variable "prefix" {
  default = "pre"
}

variable "location" {
  default = "UK South"
}

variable "subscription" {
  default = ""
}

variable "env" {}

variable "dts_pre_appreg_oid" {}

variable "dts_pre_ent_appreg_oid" {}

variable "builtFrom" {
  description = "The GitHub URL for the repository that contains the infrastructure code."
  default     = "hmcts/pre-shared-infrastructure"
}

variable "dts_pre_oid" {}

variable "dts_cft_developers_oid" {}

variable "vnet_address_space" {}

variable "video_edit_vm_snet_address" {}

variable "privatendpt_snet_address" {}

variable "bastion_snet_address" {}

variable "data_gateway_snet_address" {}

variable "mgmt_net_name" {}

variable "mgmt_net_rg_name" {}

# variable "managed_oid" {}
# variable "dts_pre_project_admin" {}
# variable "pre_mi_principal_id" {}
# variable "pre_mi_tenant_id" {}
#variable "dts_pre_app_admin" {}

# variable "lawSku" {
#   type    = string
#   default = "PerGB2018"
# }

# variable "lawRetention" {
#   type    = number
#   default = "30"
# }
# variable "schedules" {
#   type = list(object({
#     name      = string
#     frequency = string
#     interval  = number
#     run_time  = string
#     start_vm  = bool
#   }))
#   default = []
# }


# Dynatrace
# variable "dynatrace_server" {
#   description = "The server URL, if you want to configure an alternative communication endpoint."
#   type        = string
#   default     = null
# }


# variable "zone" {
#   description = "Availability Zone for Postgres"
#   default     = "1"
# }

# variable "product_group_object_id" {
#   type        = string
#   default     = "b1fd4154-355f-4683-a795-d09cdb814d16"
#   description = "DTS PRE Recorded Evidence"
# }

# variable "subscription_id" {}
# variable "client_id" {}
# variable "client_secret" {}
# variable "tenant_id" {}
