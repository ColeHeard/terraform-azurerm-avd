###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Variables - Required
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
variable "rg" {
  type        = string
  description = "Name of the resource group."
}
variable "pool_type" {
  type        = string
  description = "The pool type."
  validation {
    condition = anytrue([
      lower(var.pool_type) == "desktop",
      lower(var.pool_type) == "shareddesktop",
      lower(var.pool_type) == "application"
    ])
    error_message = "The var.pool_type input was incorrect. Please select desktop, shareddesktop, or application."
  }
}
variable "pool_number" {
  type        = number
  description = "The number of this pool. Use to avoid name collision."
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Variables - Optional
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
variable "region" {
  type        = string
  description = "The desired Azure region for the pool. See also var.region_prefix_map."
  validation {
    condition = anytrue([
      lower(var.region) == "northcentralus",
      lower(var.region) == "southcentralus",
      lower(var.region) == "westcentral",
      lower(var.region) == "centralus",
      lower(var.region) == "westus",
      lower(var.region) == "eastus",
      lower(var.region) == "northeurope",
      lower(var.region) == "westeurope",
      lower(var.region) == "norwayeast",
      lower(var.region) == "norwaywest",
      lower(var.region) == "swedencentral",
      lower(var.region) == "switzerlandnorth",
      lower(var.region) == "uksouth",
      lower(var.region) == "ukwest"
    ])
    error_message = "Please select one of the approved regions: northcentralus, southcentralus, westcentral, centralus, westus, eastus, northeurope, westeurope, norwayeast, norwaywest, swedencentral, switzerlandnorth, uksouth, or ukwest."
  }
}
# An awkward limitation due to variable validation limitations: https://github.com/hashicorp/terraform/issues/25609#issuecomment-1136340278.
variable "aad_group_desktop" {
  type        = string
  description = "The desktop pool's assignment AAD group. Required if var.pool_type != application."
  default     = null
}
# An awkward limitation due to variable validation limitations: https://github.com/hashicorp/terraform/issues/25609#issuecomment-1136340278.
variable "application_map" {
  type = map(object({
    app_name     = string
    local_path   = string
    cmd_argument = string
    aad_group    = string
  }))
  description = "A map of all applications and metadata. Required if var.pool_type == application."
  default     = null
}
variable "desktop_assignment_type" {
  type        = string
  description = "Sets the personal desktop assignment type."
  default     = "Automatic"
  validation {
    condition = anytrue([
      lower(var.desktop_assignment_type) == "automatic",
      lower(var.desktop_assignment_type) == "direct",
    ])
    error_message = "The var.desktop_assignment_type input was incorrect. Please select automatic or direct."
  }
}
variable "load_balancer_type" {
  type        = string
  description = "The method of load balancing the pool with use to distribute users across sessionhosts."
  default     = "DepthFirst"
  validation {
    condition = anytrue([
      lower(var.load_balancer_type) == "breadthfirst",
      lower(var.load_balancer_type) == "depthfirst",
      lower(var.load_balancer_type) == "persistent"
    ])
    error_message = "The var.load_balancer_type input was incorrect. Please select breadthfirst, depthfirst, or persistent."
  }
}
variable "validate_environment" {
  type        = bool
  description = "Set as true to enable validation environment."
  default     = false
}
variable "maximum_sessions_allowed" {
  type        = number
  description = "The maximum number of concurrent sessions on a single sessionhost"
  default     = 3
}
# https://learn.microsoft.com/en-us/azure/virtual-desktop/rdp-properties
variable "custom_rdp_properties" {
  type        = string
  description = "Sets custom RDP properieties for the pool"
  default     = null
}
variable "enable_agent_update_schedule" {
  type        = bool
  description = "When enabled, the pool will only perform updates on the sessionhost agents at the selected time."
  default     = true
}
variable "timezone" {
  type        = string
  description = "The timezone used to schedule updates for the AVD, Geneva agent, and side-by-side stack agent."
  default     = "Central Standard Time"
}
variable "tags" {
  type        = map(any)
  description = "The tags for the virtual machines and their subresources."
  default     = { Warning = "No tags" }
}
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Variables - Naming
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
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
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Variables - Virtual Machines
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
variable "vmcount" {
  type        = number
  description = "The number of VMs requested for this pool."
  default     = 0
  validation {
    condition = (
      var.vmcount >= 0 &&
      var.vmcount <= 99
    )
    error_message = "The number of VMs must be between 0 and 99."
  }
}
variable "secure_boot" {
  type        = bool
  description = "Controls the trusted launch settings for the sessionhost VMs."
  default     = true
}
# To-do 
variable "market_place_image" {
  type        = map(any)
  description = "The publisher, offer, sku, and version of an image in Azure's market place. Only used if var.custom_image is null."
  default = {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-10"
    sku       = "win10-22h2-ent"
    version   = "latest"
  }
}
variable "managed_image_id" {
  type        = any
  description = "The ID of an Azure Compute Gallery image."
  default     = null
}
variable "network_data" {
  type        = any
  description = "The network data needed for sessionhost connectivity."
  default     = null
}
variable "local_admin" {
  type        = string
  description = "The local administrator username."
  default     = null
}
variable "local_pass" {
  type        = string
  description = "The local administrator password."
  default     = null
  sensitive   = true
}
variable "domain" {
  type        = string
  description = "Domain name string."
  default     = null
}
variable "domain_user" {
  type        = string
  description = "The identity that will join the VM to the domain. Omit the domain name itself."
  default     = null
}
variable "domain_pass" {
  type        = string
  description = "Password for var.domain_user"
  sensitive   = true
  default     = null
}
variable "workspace_id" {
  type        = string
  description = "The ID of the Log Analytics Workspace that will collect the data."
  default     = null
}
variable "workspace_key" {
  type        = string
  description = "The Log Analytics Workspace key."
  sensitive   = true
  default     = null
}
variable "vmsize" {
  type        = string
  description = "The VM SKU desired for the pool. If none are selected, VMSize will be chosen based on var.pool_type."
  default     = "standard_d2as_v4"
}
# To-do Azure Automation runbook to key off OU VM tag. This will be included within another repository.
variable "ou" {
  type        = string
  description = "The OU a VM should be placed within."
  default     = "" # Currently does not work, needs blank string to create VMs.
}