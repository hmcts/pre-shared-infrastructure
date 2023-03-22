terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.37.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2.0"
    }
    azapi = {
      source = "Azure/azapi"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.6"
    }
  }
}

provider "azapi" {
}

provider "azurerm" {
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azurerm" {
  alias           = "oms"
  subscription_id = module.log_analytics_workspace.subscription_id
  features {}
}

provider "azurerm" {
  alias                      = "mgmt"
  subscription_id            = var.mgmt_subscription_id
  skip_provider_registration = true
  features {}
}

provider "azurerm" {
  alias           = "private_dns"
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
  features {}

}