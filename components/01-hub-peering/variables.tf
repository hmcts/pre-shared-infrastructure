variable "prefix" {
  default = "pre"
}

variable "env" {}

variable "PeeringFromHubName" {
  default = "pre-recorded-evidence"
}

variable "builtFrom" {
  description = "The GitHub URL for the repository that contains the infrastructure code."
  default     = "hmcts/pre-shared-infrastructure"
}