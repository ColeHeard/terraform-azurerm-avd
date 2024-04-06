###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Variables
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
variable "region" {
  type        = string
  description = "Location of the resource group."
  default     = "southcentralus"
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