terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.33.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.6"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

provider "azurerm" {
  subscription_id            = local.hub[local.hub_name].subscription
  skip_provider_registration = "true"
  features {}
  alias = "hub"
}

provider "azurerm" {
  alias           = "private_dns"
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
  features {}
}
