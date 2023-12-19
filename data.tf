###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Data
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
# Required permissions to access an Azure VM. 
data "azurerm_role_definition" "avduser_role" {
  name = "Desktop Virtualization User"
}
# Each AAD group needed for permissioning. 
data "azuread_group" "aad_group" {
  for_each         = toset(local.aad_group_list)
  display_name     = each.value
  security_enabled = true
}