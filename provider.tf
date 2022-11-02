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
  #subscription_id            = local.hub[var.env].subscription
  subscription_id            = local.hub[local.hub_name].subscription
  skip_provider_registration = "true"
  features {}
  alias = "hub"
}

provider "azurerm" {
  subscription_id            = var.private_dns_subscription
  skip_provider_registration = "true"
  features {}
  alias = "private-dns"
}

provider "azurerm" {
  subscription_id            = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
  skip_provider_registration = "true"
  features {}
  alias = "private-dns-private-endpoint"
}

provider "azurerm" {
  subscription_id            = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
  skip_provider_registration = "true"
  features {}
  alias = "vpn"
}

provider "azurerm" {
  alias = "data"
  features {}
  subscription_id = module.log_analytics_workspace.subscription_id
}

provider "azurerm" {
  subscription_id            = local.hub["sbox"].subscription
  skip_provider_registration = "true"
  features {}
  alias = "hub-sbox"
}

provider "azurerm" {
  subscription_id            = local.hub["nonprod"].subscription
  skip_provider_registration = "true"
  features {}
  alias = "hub-nonprod"
}

provider "azurerm" {
  subscription_id            = local.hub["prod"].subscription
  skip_provider_registration = "true"
  features {}
  alias = "hub-prod"
}
# data "azurerm_key_vault" "cnp_vault" {
#   provider            = azurerm.cnp
#   name                = "infra-vault-${local.dynatrace_env}"
#   resource_group_name = var.cnp_vault_rg
# }

# data "azurerm_key_vault_secret" "token" {
#   provider = azurerm.cnp

#   name         = "dynatrace-${local.dynatrace_env}-token"
#   key_vault_id = data.azurerm_key_vault.cnp_vault.id
# }

# resource "null_resource" "PowerShellScriptRunFirstTimeOnly" {
#     provisioner "local-exec" {
#         command = "Register-AzProviderFeature -FeatureName "EncryptionAtHost" -ProviderNamespace "Microsoft.Compute" "
#         interpreter = ["PowerShell", "-Command"]
#     }
# }
# resource "azurerm_resource_provider_registration" "EncryptionAtHost" {
#   name = "Microsoft.Compute/EncryptionAtHost"
#   #   feature {
#   #   name       = "EncryptionAtHost"
#   #   registered = true
#   # }
# }

# azurerm_storage_account_customer_managed_key