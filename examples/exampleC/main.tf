###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Terraform
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
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Provider
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
provider "azurerm" {
  skip_provider_registration = true
  subscription_id            = "12345678-1234-1234-1234-1234567890ab"
  features {}
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Data
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
data "azurerm_resource_group" "example" {
  name = "DEV-RG-EXAMPLE"
}
data "azurerm_subnet" "network" {
  name                 = "SAMPLE_AVD_SUBNET"
  virtual_network_name = "SAMPLE_AVD_VNET"
  resource_group_name  = "NETWORK-RG-EXAMPLE"
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Module
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
module "power_pool" {
  # Required Input
  source       = "ColeHeard/avd/azurerm"
  version      = "1.0.0"
  pool_type    = "shareddesktop"
  rg           = data.azurerm_resource_group.example.id
  region       = var.region
  local_admin  = var.local_admin
  local_pass   = var.local_pass
  network_data = data.azurerm_subnet.network
  # Optional Input
  market_place_image       = var.market_place_images.win10m
  aad_group_desktop        = "SG-AVD-Developers"
  vmsize                   = "standard_d32as_v4"
  vmcount                  = 2
  maximum_sessions_allowed = 7
}