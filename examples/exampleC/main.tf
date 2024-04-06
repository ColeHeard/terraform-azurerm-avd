###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Modules
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
# This code creates general pool 01.
module "general01_pool" {
  # Required Input
  source      = "ColeHeard/avd/azurerm"
  version     = "1.1.0"
  pool_number = 01
  pool_type   = "desktop"
  region      = var.region
  rg          = data.azurerm_resource_group.example.id
  # Optional Input
  aad_group_desktop            = "SG-AVD-PersonalDesktop-Users"
  desktop_assignment_type      = "manual"
  enable_agent_update_schedule = true
  custom_rdp_properties        = var.rdp_internal_desktop
  tags                         = [{ Example = "Example" }]
}
module "general01_vms" {
  # Required Input
  for_each     = local.general01_vms_users
  source       = "ColeHeard/avdsh/azurerm"
  version      = "1.0.0"
  network_data = each.value["network"]
  pool_input   = module.general01_pool.hp_output
  region       = module.general01_pool.region
  rg           = module.general01_pool.region_prefix
  token        = module.general01_pool.token
  side         = "a"
  # Optional Input
  vmnumber          = each.value["vmnumber"]
  vmsize            = each.value["vmsize"]
  marketplace_image = each.value["marketplace_image"]
  managed_image_id  = each.value["managed_image_id"]
  domain            = var.domain
  domain_user       = var.domain_user
  domain_pass       = var.domain_pass
  local_admin       = var.local_admin
  local_pass        = var.local_pass
  workspace_id      = var.workspace_id
  workspace_key     = var.workspace_key
}

# This code creates general pool 02.
module "general02_pool" {
  # Required Input
  source      = "ColeHeard/avd/azurerm"
  version     = "1.1.0"
  pool_number = 01
  pool_type   = "desktop"
  region      = var.region
  rg          = data.azurerm_resource_group.example.id
  # Optional Input
  aad_group_desktop            = "SG-AVD-ExternalDesktop-Users"
  desktop_assignment_type      = "manual" # :( Sadface - could be fixed with powershell/UPN based VM assignments???
  enable_agent_update_schedule = true
  custom_rdp_properties        = var.rdp_internal_desktop
  tags                         = [{ Example = "Example" }, { Example2 = "Wow" }]
}
module "general02_vms" {
  # Required Input
  for_each     = local.general02_vms_users
  source       = "ColeHeard/avdsh/azurerm"
  version      = "1.0.0"
  network_data = data.azurerm_subnet.dmz_restricted
  pool_input   = module.general02_pool.hp_output
  region       = module.general02_pool.region
  rg           = module.general02_pool.region_prefix
  token        = module.general02_pool.token
  side         = "b"
  # Optional Input
  vmnumber         = each.value["vmnumber"]
  vmsize           = each.value["vmsize"]
  managed_image_id = each.value["managed_image_id"]
  domain           = var.domain
  domain_user      = var.domain_user
  domain_pass      = var.domain_pass
  local_admin      = var.local_admin
  local_pass       = var.local_pass
  workspace_id     = var.workspace_id
  workspace_key    = var.workspace_key
}