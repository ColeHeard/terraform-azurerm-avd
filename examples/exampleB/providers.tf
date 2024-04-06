###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Terraform & Providers
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.42.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.33.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "STORAGE-RG-EXAMPLE"
    storage_account_name = "storageaccountname"
    container_name       = "tfstateexampleb"
    key                  = "terraform.tfstateb"
  }
}
provider "azurerm" {
  skip_provider_registration = true
  subscription_id            = "12345678-1234-1234-1234-1234567890ab"
  features {}
}