variable "prefix" {
  default = "pre"
}

variable "location" {
  default = "UK South"
}

variable "env" {}

variable "builtFrom" {
  description = "The GitHub URL for the repository that contains the infrastructure code."
  default     = "hmcts/pre-shared-infrastructure"
}