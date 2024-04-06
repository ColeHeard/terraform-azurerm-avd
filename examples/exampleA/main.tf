###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Modules
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
module "shared02_pool" {
  # Required Input
  source      = "ColeHeard/avd/azurerm"
  version     = "1.1.0"
  pool_number = 2
  pool_type   = "shareddesktop"
  region      = var.region
  rg          = data.azurerm_resource_group.example.id
  # Optional Input
  aad_group_desktop        = "SG-AVD-BUSINESSUNIT01023-Users"
  maximum_sessions_allowed = 8
  custom_rdp_properties    = local.rdp_settings.internal
  tags                     = [{ Example = "Business Unit CONTACT or something, IDK." }]
}
module "shared02_vms_a" {
  # Required Input
  count        = 22
  source       = "ColeHeard/avdsh/azurerm"
  version      = "1.0.0"
  network_data = data.azurerm_subnet.network
  pool_input   = module.shared02_pool.hp_output
  region       = module.shared02_pool.region
  rg           = module.shared02_pool.rg
  token        = module.shared02_pool.token
  side         = "a"
  # Optional Input
  vmnumber         = count.index
  vmsize           = "Standard_D16as_v5"
  managed_image_id = data.azurerm_shared_image_version.prod_image55_1_16.id
  local_admin      = var.local_admin
  local_pass       = var.local_pass
  workspace_id     = var.workspace_id
  workspace_key    = var.workspace_key
}
module "shared02_vms_b" {
  # Required Input
  count        = 0
  source       = "ColeHeard/avdsh/azurerm"
  version      = "1.0.0"
  network_data = data.azurerm_subnet.network
  pool_input   = module.shared02_pool.hp_output
  region       = module.shared02_pool.region
  rg           = module.shared02_pool.rg
  token        = module.shared02_pool.token
  side         = "b"
  # Optional Input
  vmnumber         = count.index
  vmsize           = "Standard_D16as_v5"
  managed_image_id = data.azurerm_shared_image_version.prod_image55_1_17_2.id # Preparing for new version roleout here.
  local_admin      = var.local_admin
  local_pass       = var.local_pass
  workspace_id     = var.workspace_id
  workspace_key    = var.workspace_key
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Resources
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
# Resources that could be shared among pools were not included in the module.
# Sample scaling plan. 
resource "azurerm_virtual_desktop_scaling_plan" "shared_scaling" {
  name                = "${local.prefix}-DesktopScaling-SP01"
  resource_group_name = data.azurerm_resource_group.example.id
  location            = var.region
  friendly_name       = "Shared Desktop Scaling Plan"
  description         = "This scaling plan is used to power down unused machines on a schedule to minimize cost."
  time_zone           = "Central Europe Standard Time" # https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/
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
    hostpool_id          = module.shared02.pool.id
    scaling_plan_enabled = true
  }
}