###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Modules
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
module "external04_pool" {
  # Required Input
  source      = "ColeHeard/avd/azurerm"
  version     = "1.1.0"
  pool_number = 4
  pool_type   = "desktop"
  region      = var.region
  rg          = data.azurerm_resource_group.example.id
  # Optional Input
  aad_group_desktop            = "SG-AVD-External-TemporaryDesktop-Users"
  enable_agent_update_schedule = false
  custom_rdp_properties        = local.rdp_settings.rescricted
  tags                         = [{ Example = "404" }]
}
module "external04_vms" {
  # Required Input
  count        = 30
  source       = "ColeHeard/avdsh/azurerm"
  version      = "1.0.0"
  network_data = data.azurerm_subnet.dmz_restricted
  pool_input   = module.external04_pool.hp_output
  region       = module.external04_pool.region
  rg           = module.external04_pool.rg
  token        = module.external04_pool.token
  side         = "b"
  # Optional Input
  vmnumber         = count.index
  vmsize           = "Standard_D2s_v5"
  managed_image_id = data.azurerm_shared_image_version.custom_image_3.id
  local_admin      = var.local_admin
  local_pass       = var.local_pass
}