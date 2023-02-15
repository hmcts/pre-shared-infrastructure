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
  subscription_id            = local.hub[local.hub_name].subscription
  skip_provider_registration = "true"
  features {}
  alias = "hub"
}

provider "azurerm" {
  subscription_id            = "867a878b-cb68-4de5-9741-361ac9e178b6"
  skip_provider_registration = true
  features {}
  # alias = "sds"
}
