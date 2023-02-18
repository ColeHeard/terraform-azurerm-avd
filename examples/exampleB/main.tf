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
data "azurerm_subnet" "network" {
  name                 = "SAMPLE_AVD_SUBNET"
  virtual_network_name = "SAMPLE_AVD_VNET"
  resource_group_name  = "NETWORK-RG-EXAMPLE"
}
data "azurerm_shared_image_version" "custom_image" {
  name                = "1.4.5"
  image_name          = "W10-22H2-CUSTOM"
  gallery_name        = "A_SAMPLE_ACG"
  resource_group_name = "ACG-RG-EXAMPLE"
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Module
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
module "application_pool" {
  # Required Input
  source       = "ColeHeard/avd/azurerm"
  version      = "1.0.0"
  pool_type    = "application"
  rg           = azurerm_resource_group.main_rg.id
  region       = var.region
  local_admin  = var.local_admin
  local_pass   = var.local_pass
  network_data = data.azurerm_subnet.network
  # Optional Input
  application_map          = merge(var.red_app, var.blue_app, var.yellow_app)
  managed_image_id         = data.azurerm_shared_image_version.custom_image
  custom_rdp_properties    = var.rdp_app_streaming
  domain                   = var.domain
  domain_user              = var.domain_user
  domain_pass              = var.domain_pass
  workspace_id             = var.workspace_id
  workspace_key            = var.workspace_key
  vmsize                   = "Standard_D8as_v4"
  vmcount                  = 10
  maximum_sessions_allowed = 7
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Resources
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
# Resources that could be shared among pools were not included in the module.
# A sample resouce group.
resource "azurerm_resource_group" "main_rg" {
  name     = "${local.prefix}-${var.rg}-RG"
  location = var.region
}
# Sample scaling plan. 
resource "azurerm_virtual_desktop_scaling_plan" "app_plan" {
  name                = "${local.prefix}-${var.rg}-SP"
  resource_group_name = azurerm_resource_group.main_rg.id
  location            = var.region
  friendly_name       = "Application Pool Scaling Plan"
  description         = "This scaling plan is used to power down unused machines on a schedule to minimize cost."
  time_zone           = "Central Standard Time"
  schedule {
    name                                 = "WorkWeek"
    days_of_week                         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    ramp_up_start_time                   = "06:00"
    ramp_up_load_balancing_algorithm     = "BreadthFirst"
    ramp_up_minimum_hosts_percent        = 15
    ramp_up_capacity_threshold_percent   = 75
    peak_start_time                      = "08:00"
    peak_load_balancing_algorithm        = "BreadthFirst"
    ramp_down_start_time                 = "18:00"
    ramp_down_load_balancing_algorithm   = "DepthFirst"
    ramp_down_minimum_hosts_percent      = 15
    ramp_down_force_logoff_users         = false
    ramp_down_wait_time_minutes          = 50
    ramp_down_notification_message       = "Please log off in the next 45 minutes..."
    ramp_down_capacity_threshold_percent = 5
    ramp_down_stop_hosts_when            = "ZeroSessions"
    off_peak_start_time                  = "21:00"
    off_peak_load_balancing_algorithm    = "DepthFirst"
  }
  schedule {
    name                                 = "Weekend"
    days_of_week                         = ["Saturday", "Sunday"]
    ramp_up_start_time                   = "09:00"
    ramp_up_load_balancing_algorithm     = "DepthFirst"
    ramp_up_minimum_hosts_percent        = 15
    ramp_up_capacity_threshold_percent   = 75
    peak_start_time                      = "12:00"
    peak_load_balancing_algorithm        = "DepthFirst"
    ramp_down_start_time                 = "15:00"
    ramp_down_load_balancing_algorithm   = "DepthFirst"
    ramp_down_minimum_hosts_percent      = 15
    ramp_down_force_logoff_users         = false
    ramp_down_wait_time_minutes          = 50
    ramp_down_notification_message       = "Please log off in the next 45 minutes..."
    ramp_down_capacity_threshold_percent = 5
    ramp_down_stop_hosts_when            = "ZeroSessions"
    off_peak_start_time                  = "18:00"
    off_peak_load_balancing_algorithm    = "DepthFirst"
  }
  # Hostpools created from the module can be referenced post creation as seen here.
  host_pool {
    hostpool_id          = module.application_pool.pool.id
    scaling_plan_enabled = true
  }
}