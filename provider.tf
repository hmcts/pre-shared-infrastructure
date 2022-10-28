terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.3.0"
    }
    random = {
      source = "hashicorp/random"
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

terraform {
  backend "azurerm" {}
}
provider "azurerm" {
  alias           = "oms"
  subscription_id = module.log_analytics_workspace.subscription_id
  features {}
}

data "azuread_service_principal" "kv" {
  # display_name = "Azure Key Vault"
  application_id = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"
}


provider "azurerm" {
  alias           = "oms"
  subscription_id = module.log_analytics_workspace.subscription_id
  features {}
}

provider "azurerm" {
  alias                      = "cnp"
  skip_provider_registration = "true"
  features {}
  subscription_id = var.cnp_vault_sub
}

data "azuread_service_principal" "kv" {
  # display_name = "Azure Key Vault"
  application_id = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"
}

provider "azurerm" {
  features {}
  alias           = "loganalytics"
  subscription_id = local.log_analytics_workspace[[for x in keys(local.log_analytics_env_mapping) : x if contains(local.log_analytics_env_mapping[x], var.env)][0]].subscription_id
}

provider "azurerm" {
  alias                      = "hmcts-control"
  skip_provider_registration = "true"
  features {}
  subscription_id = "04d27a32-7a07-48b3-95b8-3c8691e1a263"
}


provider "azurerm" {
  subscription_id            = local.hub[var.environment].subscription
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