###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Locals
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
# Dynamic region, workspace, and pool type naming locals. Could be organized better.
locals {
  region_prefix         = var.region_prefix_map[var.region]
  production_workspace  = terraform.workspace == "default" ? "PRD" : ""
  development_workspace = terraform.workspace == "development" ? "DEV" : ""
  uat_workspace         = terraform.workspace == "uat" ? "UAT" : ""
  other_workspace       = terraform.workspace != "default" && terraform.workspace != "development" && terraform.workspace != "uat" ? "TST" : ""
  workspace_prefix      = coalesce(local.production_workspace, local.development_workspace, local.uat_workspace, local.other_workspace)
  pool_type_prefix      = var.pool_type == "desktop" ? "GEN" : (var.pool_type == "SharedDesktop" ? "PWR" : "APP")
  prefix                = "${local.region_prefix}-${local.workspace_prefix}${local.pool_type_prefix}${format("%02d", var.pool_number)}"
}
# Locates unique AAD groups for application group for_each loop. 
locals {
  aad_group_list = var.application_map != null ? distinct(values({ for k, v in var.application_map : k => v.aad_group })) : ["${var.aad_group_desktop}"]
  applications   = var.application_map != null ? var.application_map : tomap({}) # Null is not accepted as for_each value, substituing for an empty map if null.
}
# Calculates if an extension type is needed for this pool's sessionhosts.
locals {
  extensions = {
    domain_join = var.domain != null ? var.vmcount : 0
    mmaagent    = var.workspace_id != null ? var.vmcount : 0
  }
}
# Determines the default sessionhost size if unspecified. 
locals {
  size_selected   = var.vmsize != null ? var.vmsize : "Standard_D2as_v4"
  size_unselected = lower(var.pool_type) == "desktop" ? "Standard_D2as_v4" : "Standard_D4as_v4"
  vmsize          = coalesce(local.size_selected, local.size_unselected)
}
# Maps the retrieved token to a local.
locals {
  token = azurerm_virtual_desktop_host_pool_registration_info.token.token
}
# Dynamic tags - to-do.
locals {
  tags = {
    Function  = "Azure Virtual Desktop"
    CreatedBy = "Your Name"
    Status    = terraform.workspace == "default" ? "Production" : "${terraform.workspace}"
  }
}