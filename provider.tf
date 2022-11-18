terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.3.0"
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
      version = "~> 0.6" # where X.Y is the current major version and minor version
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
  subscription_id            = local.hub[var.env].subscription
  skip_provider_registration = "true"
  features {}
  alias = "hub"
}
