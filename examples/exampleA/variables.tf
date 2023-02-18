###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Variables - Resources
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
variable "region" {
  type        = string
  description = "Location of the resource group."
  default     = "westus"
}
variable "market_place_images" {
  type = map(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))
  description = "The market place image calalog for this AVD deployment."
  default = {
    "win10s" = {
      publisher = "microsoftwindowsdesktop"
      offer     = "windows-10"
      sku       = "win10-21h2-ent"
      version   = "latest"
    }
    "win11s" = {
      publisher = "microsoftwindowsdesktop"
      offer     = "windows-11"
      sku       = "win11-21h2-ent"
      version   = "latest"
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
variable "rdp_restricted" {
  type        = string
  description = "Only clipboard redirected. Scaling display options configured. No compression."
  default     = "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:0;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:;enablecredsspsupport:i:1;use multimon:i:0;screen mode id:i:1;smart sizing:i:1;autoreconnection enabled:i:1;bandwidthautodetect:i:1;networkautodetect:i:1"
}
variable "rdp_internal_desktop" {
  type        = string
  description = "Printers, disks, webcam, and clipboard available in remote session. Scaling display options configured. No compression."
  default     = "drivestoredirect:s:dynamicdrives;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:0;redirectprinters:i:0;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:0;screen mode id:i:1;smart sizing:i:1;autoreconnection enabled:i:1;bandwidthautodetect:i:1;networkautodetect:i:1;camerastoredirect:s:*;dynamic resolution:i:1"
}