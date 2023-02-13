variable "prefix" {
  default = "pre"
}

variable "location" {
  default = "UK South"
}

variable "env" {}


variable "sa_account_tier" {
  default = "Standard"
}

variable "sa_replication_type" {
  default = "GRS"
}

variable "ip_rules" {
  description = "PowerPlatformInfra.UKSouth"
  type        = list(string)
  default = [
    "20.49.145.249/30",
    "20.49.166.40/30",
    "20.49.166.118/30",
    "20.49.166.129/30",
    "20.49.244.238/30",
    "20.58.70.192/27",
    "20.58.70.224/28",
    "20.90.125.211",
    "20.90.124.134",
    "20.90.129.0/27",
    "20.90.129.32/28",
    "20.90.131.0/26",
    "20.90.131.64/27",
    "20.90.131.120/29",
    "20.90.169.112/30",
    "20.108.81.107/30",
    "51.11.24.198/30",
    "51.11.25.68/30",
    "51.11.25.172/30",
    "51.11.172.30/30",
    "51.11.172.56/30",
    "51.11.172.160/30",
    "51.104.30.172/30",
    "51.104.30.192/26",
    "51.104.31.0/27",
    "51.104.31.32/28",
    "51.104.31.48/29",
    "51.104.31.64/26",
    "51.104.248.11/30",
    "51.132.161.225/30",
    "51.132.215.162/30",
    "51.132.215.182/30",
    "51.143.208.216/29",
    "51.145.104.29/30",
    "51.140.77.227",
    "51.140.245.29",
    "51.140.80.51",
    "51.140.61.124",
    "51.141.47.105",
    "51.141.124.13",
    "51.105.77.96/27",
    "51.140.148.0/28",
    "51.140.211.0/28",
    "51.140.212.224/27",
  ]
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