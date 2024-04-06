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
locals {
  rdp_settings = {
    internal   = "drivestoredirect:s:dynamicdrives;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:0;redirectprinters:i:0;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:0;screen mode id:i:1;smart sizing:i:1;autoreconnection enabled:i:1;bandwidthautodetect:i:1;networkautodetect:i:1;camerastoredirect:s:*;dynamic resolution:i:1"
    rescricted = "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:0;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:;enablecredsspsupport:i:1;use multimon:i:0;screen mode id:i:1;smart sizing:i:1;autoreconnection enabled:i:1;bandwidthautodetect:i:1;networkautodetect:i:1"
    streaming  = "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;autoreconnection enabled:i:1;bandwidthautodetect:i:1;networkautodetect:i:1;compression:i:1"
  }
}