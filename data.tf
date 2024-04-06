###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Data
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
# Required permissions to access an Azure VM. 
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition
data "azurerm_role_definition" "avduser_role" {
  name = "Desktop Virtualization User"
}
# Each AAD group needed for permissioning. 
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group
data "azuread_group" "aad_group" {
  for_each         = toset(local.aad_group_list)
  display_name     = each.value
  security_enabled = true
}