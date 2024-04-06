###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Locals
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
# This local is used to create the workspace prefix.
locals {
  list = {
    prod_workspace  = terraform.workspace == "default" ? "PD" : ""
    dev_workspace   = terraform.workspace == "development" ? "DV" : ""
    uat_workspace   = terraform.workspace == "uat" ? "UT" : ""
    other_workspace = terraform.workspace != "default" && terraform.workspace != "development" && terraform.workspace != "uat" ? "TE" : ""
  }
  workspace_prefix = coalesce(local.list.prod_workspace, local.list.dev_workspace, local.list.uat_workspace, local.list.other_workspace)
}
locals {
  region_prefix = var.region_prefix_map[var.region]
  prefix        = "${local.region_prefix}${local.workspace_prefix}"
}