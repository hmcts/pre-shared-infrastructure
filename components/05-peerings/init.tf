terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.33.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2.0"
    }
  }
}

provider "azurerm" {
  #subscription_id            = local.hub[var.env].subscription
  subscription_id            = local.hub[local.hub_name].subscription
  skip_provider_registration = "true"
  features {}
  alias = "hub"
}