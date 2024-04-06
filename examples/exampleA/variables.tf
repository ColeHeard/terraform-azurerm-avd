###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Variables
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
variable "region" {
  type        = string
  description = "Location of the resource group."
  default     = "northeurope"
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
variable "domain" {
  type        = string
  description = "Username for domain join"
  default     = "contoso.com"
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