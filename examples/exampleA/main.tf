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
  name = "AVD-RG-EXAMPLE"
}
data "azurerm_subnet" "network" {
  name                 = "SAMPLE_AVD_SUBNET"
  virtual_network_name = "SAMPLE_AVD_VNET"
  resource_group_name  = "NETWORK-RG-EXAMPLE"
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Modules
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
module "general_pool01" {
  # Required Input
  source       = "ColeHeard/avd/azurerm"
  version      = "1.0.0"
  pool_type    = "desktop"
  rg           = data.azurerm_resource_group.example.id
  region       = var.region
  local_admin  = var.local_admin
  local_pass   = var.local_pass
  network_data = data.azurerm_subnet.network
  # Optional Input
  market_place_image    = var.market_place_images.win11s
  aad_group_desktop     = "SG-AVD-PersonalDesktop-Users"
  custom_rdp_properties = var.rdp_internal_desktop
  domain                = var.domain
  domain_user           = var.domain_user
  domain_pass           = var.domain_pass
  workspace_id          = var.workspace_id
  workspace_key         = var.workspace_key
  vmsize                = "standard_d4as_v4"
  vmcount               = 20
}
module "general_pool02" {
  # Required Input
  source       = "ColeHeard/avd/azurerm"
  version      = "1.0.0"
  pool_type    = "desktop"
  rg           = data.azurerm_resource_group.example.id
  region       = var.region
  local_admin  = var.local_admin
  local_pass   = var.local_pass
  network_data = data.azurerm_subnet.network
  # Optional Input
  market_place_image    = var.market_place_images.win10s
  aad_group_desktop     = "SG-AVD-External-Users"
  custom_rdp_properties = var.rdp_restricted
  domain                = var.domain
  domain_user           = var.domain_user
  domain_pass           = var.domain_pass
  workspace_id          = var.workspace_id
  workspace_key         = var.workspace_key
  vmcount               = 5
  pool_number           = 2
}