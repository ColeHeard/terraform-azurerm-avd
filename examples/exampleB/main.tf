###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Modules
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
module "app_pool" {
  # Required Input
  source      = "ColeHeard/avd/azurerm"
  version     = "1.1.0"
  pool_number = 01
  pool_type   = "application"
  region      = var.region
  rg          = azurerm_resource_group.main_rg.id
  # Optional Input
  application_map              = merge(var.red_app, var.blue_app, var.yellow_app)
  maximum_sessions_allowed     = 7
  enable_agent_update_schedule = true
  custom_rdp_properties        = var.rdp_app_streaming
  workspace_id                 = var.workspace_id
  tags                         = [{ Example = "Example" }]
}
module "side_a" {
  # Required Input
  count        = 50
  source       = "ColeHeard/avdsh/azurerm"
  version      = "1.0.0"
  network_data = data.azurerm_subnet.network
  pool_input   = module.app_pool.hp_output
  region       = module.app_pool.region
  rg           = module.app_pool.rg
  token        = module.app_pool.token
  side         = "a"
  # Optional Input
  vmnumber         = count.index
  vmsize           = "Standard_D8as_v4"
  managed_image_id = data.azurerm_shared_image_version.custom_image
  domain           = var.domain
  domain_user      = var.domain_user
  domain_pass      = var.domain_pass
  local_admin      = var.local_admin
  local_pass       = var.local_pass
  workspace_id     = var.workspace_id
  workspace_key    = var.workspace_key
}
module "side_b" {
  # Required Input
  count        = 50
  source       = "ColeHeard/avdsh/azurerm"
  version      = "1.0.0"
  network_data = data.azurerm_subnet.network
  pool_input   = module.app_pool.hp_output
  region       = module.app_pool.region
  rg           = module.app_pool.rg
  token        = module.app_pool.token
  side         = "b"
  # Optional Input
  vmnumber         = count.index
  vmsize           = "Standard_D8as_v4"
  managed_image_id = data.azurerm_shared_image_version.custom_image
  domain           = var.domain
  domain_user      = var.domain_user
  domain_pass      = var.domain_pass
  local_admin      = var.local_admin
  local_pass       = var.local_pass
  workspace_id     = var.workspace_id
  workspace_key    = var.workspace_key
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
  time_zone           = "Greenwich Standard Time" # https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/
  schedule {
    name                                 = "EveryDay"
    days_of_week                         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
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
  # Hostpools created from the module can be referenced post creation as seen here.
  host_pool {
    hostpool_id          = module.app_pool.pool.id
    scaling_plan_enabled = false # Disabled while pool-side rotation is occuring. Could probably be automated with an if condition.
  }
}