###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Outputs
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
output "pool" {
  description = "The pool created by this module"
  value       = azurerm_virtual_desktop_host_pool.pool
}
output "workspace" {
  description = "The workspace created by this module"
  value       = azurerm_virtual_desktop_workspace.workspace
}
output "applications" {
  description = "The application group(s) created by this module"
  value       = azurerm_virtual_desktop_application_group.app_group[*]
}
output "rg" {
  description = "The resource group selected for this pool"
  value       = var.rg
}
output "region" {
  description = "The Azure region selected for this pool"
  value       = var.region
}
output "timezone" {
  description = "The timezone selected for this pool"
  value       = var.timezone
}
output "token" {
  description = "The hostpool token created for this pool."
  value       = local.token
  sensitive   = true
}