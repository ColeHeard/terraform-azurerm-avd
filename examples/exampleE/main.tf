###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Modules
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
module "msix11_pool" {
  # Required Input
  source      = "ColeHeard/avd/azurerm"
  version     = "1.1.0"
  pool_number = 11
  pool_type   = "shareddesktop"
  region      = var.region
  rg          = data.azurerm_resource_group.sample.id
  # Optional Input
  vmcount                      = 10
  vmsize                       = "Standard_D8s_v5"
  aad_group_desktop            = "SG-AVD-MSIX-APP-Users"
  enable_agent_update_schedule = false
  load_balancer_type           = "DepthFirst"
  custom_rdp_properties        = local.rdp_settings.internal
  managed_image_id             = data.azurerm_shared_image_version.base_image.id
  local_admin                  = var.local_admin
  local_pass                   = var.local_pass
  workspace_id                 = var.workspace_id
  workspace_key                = var.workspace_key
  tags                         = [{ Example = "Hello World of MSIX." }]
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Resources
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
# Resources that could be shared among pools were not included in the module.
# Sample scaling plan. 
resource "azurerm_virtual_desktop_scaling_plan" "msix_scaling" {
  name                = "${local.prefix}-MSIX-Scaling-Plan"
  resource_group_name = data.azurerm_resource_group.sample.id
  location            = var.region
  friendly_name       = "MSIX Scaling Plan"
  description         = "This scaling plan is used to power down unused machines on a schedule to minimize cost."
  time_zone           = "Eastern Standard Time" # https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/
  schedule {
    name                                 = "WorkWeek"
    days_of_week                         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Thursday", "Friday"]
    ramp_up_start_time                   = "05:00"
    ramp_up_load_balancing_algorithm     = "BreadthFirst"
    ramp_up_minimum_hosts_percent        = 20
    ramp_up_capacity_threshold_percent   = 80
    peak_start_time                      = "08:00"
    peak_load_balancing_algorithm        = "BreadthFirst"
    ramp_down_start_time                 = "18:00"
    ramp_down_load_balancing_algorithm   = "DepthFirst"
    ramp_down_minimum_hosts_percent      = 15
    ramp_down_force_logoff_users         = false
    ramp_down_wait_time_minutes          = 30
    ramp_down_notification_message       = "Please log off in the next 30 minutes..."
    ramp_down_capacity_threshold_percent = 5
    ramp_down_stop_hosts_when            = "ZeroSessions"
    off_peak_start_time                  = "21:00"
    off_peak_load_balancing_algorithm    = "DepthFirst"
  }
  # Hostpools created from the module can be referenced post creation as seen here.
  host_pool {
    hostpool_id          = module.msix11_pool.pool.id
    scaling_plan_enabled = true
  }
}