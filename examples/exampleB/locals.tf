###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Locals
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
# Dynamic region, workspace, and pool type naming locals.
locals {
  region_prefix         = var.region_prefix_map[var.region]
  production_workspace  = terraform.workspace == "default" ? "PRD" : ""
  development_workspace = terraform.workspace == "development" ? "DEV" : ""
  uat_workspace         = terraform.workspace == "uat" ? "UAT" : ""
  other_workspace       = terraform.workspace != "default" && terraform.workspace != "development" && terraform.workspace != "uat" ? "TST" : ""
  workspace_prefix      = coalesce(local.production_workspace, local.development_workspace, local.uat_workspace, local.other_workspace)
  prefix                = "${local.region_prefix}-${local.workspace_prefix}"
}