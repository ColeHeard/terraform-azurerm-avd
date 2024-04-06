###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Variables
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
variable "rg" {
  type        = string
  description = "AVD resource group string for name concat."
  default     = "AVD"
}
variable "region" {
  type        = string
  description = "Location of the resource group."
  default     = "uksouth"
}
variable "blue_app" {
  type = map(object({
    app_name     = string
    local_path   = string
    cmd_argument = string
    aad_group    = string
  }))
  description = "This is the blue application object."
  default = {
    "blueapp" = {
      app_name     = "Blue App"
      local_path   = "C:\\Program Files (x86)\\BlueApplicationFoundation\\Blue.EXE"
      cmd_argument = null
      aad_group    = "SG-BlueApp-Users"
    }
  }
}
variable "red_app" {
  type = map(object({
    app_name     = string
    local_path   = string
    cmd_argument = string
    aad_group    = string
  }))
  description = "This is the red application object."
  default = {
    "redapp" = {
      app_name     = "Red App"
      local_path   = "C:\\Program Files\\Red App Developers\\RedApp5.EXE"
      cmd_argument = "configuration.set"
      aad_group    = "SG-RedApp-Users"
    }
    "redapputility" = {
      app_name     = "Red App Utility"
      local_path   = "C:\\Program Files\\Red App Developers\\RedUtility.EXE"
      cmd_argument = null
      aad_group    = "SG-RedApp-Users"
    }
    "redappexporter" = {
      app_name     = "Red App Export tool"
      local_path   = "C:\\Program Files\\Red App Developers\\RedExporter.EXE"
      cmd_argument = null
      aad_group    = "SG-RedApp-Users"
    }
    "redappadmin" = {
      app_name     = "Red App Administration tool"
      local_path   = "C:\\Program Files\\Red App Developers\\AdminConsoleRedApp.EXE"
      cmd_argument = null
      aad_group    = "SG-RedApp-Administrators"
    }
  }
}
variable "yellow_app" {
  type = map(object({
    app_name     = string
    local_path   = string
    cmd_argument = string
    aad_group    = string
  }))
  description = "This is the yellow application object."
  default = {
    "yellowviewer" = {
      app_name     = "YellowViewer"
      local_path   = "C:\\Program Files\\YellowAppIndustries\\YellowViewer.exe"
      cmd_argument = null
      aad_group    = "SG-YellowApp-Users"
    }
    "yellowdesigner" = {
      app_name     = "YellowDesigner"
      local_path   = "C:\\Program Files\\YellowAppIndustries\\YellowDesigner.EXE"
      cmd_argument = null
      aad_group    = "SG-YellowApp-Developers"
    }
  }
}
variable "local_admin" {
  type        = string
  description = "The local administrator username."
  sensitive   = true
}
variable "local_pass" {
  type        = string
  description = "The local administrator password."
  sensitive   = true
}
variable "domain_user" {
  type        = string
  description = "Username for domain join"
  default     = null
  sensitive   = true
}
variable "domain_pass" {
  type        = string
  description = "Password for var.domain_user"
  sensitive   = true
}
variable "workspace_id" {
  type        = string
  description = "The ID of the Log Analytics Workspace that will collect the data."
  default     = null
  sensitive   = true
}
variable "workspace_key" {
  type        = string
  description = "The Log Analytics Workspace key."
  sensitive   = true
}
variable "domain" {
  type        = string
  description = "Username for domain join"
  default     = "contoso.com"
}
variable "rdp_app_streaming" {
  type        = string
  description = "Printers, disks, and clipboard available in remote session. Bulk compression enabled."
  default     = "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;autoreconnection enabled:i:1;bandwidthautodetect:i:1;networkautodetect:i:1;compression:i:1"
}
variable "region_prefix_map" {
  type        = map(any)
  description = "A list of prefix strings to concat in locals. Can be replaced or appended."
  default = {
    northcentralus   = "NCU"
    southcentralus   = "SCU"
    westcentral      = "WCU"
    centralus        = "USC"
    westus           = "USW"
    eastus           = "USE"
    northeurope      = "NEU"
    westeurope       = "WEU"
    norwayeast       = "NWE"
    norwaywest       = "NWN"
    swedencentral    = "SWC"
    switzerlandnorth = "SLN"
    uksouth          = "UKS"
    ukwest           = "UKW"
  }
}