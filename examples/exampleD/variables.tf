###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Variables
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
variable "region" {
  type        = string
  description = "Location of the resource group."
  default     = "swedencentral"
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