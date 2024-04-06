###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Data
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
data "azurerm_subnet" "network" {
  name                 = "SAMPLE_AVD_SUBNET"
  virtual_network_name = "SAMPLE_AVD_VNET"
  resource_group_name  = "NETWORK-RG-EXAMPLE"
}
data "azurerm_shared_image_version" "custom_image" {
  name                = "1.4.5"
  image_name          = "W10-22H2-CUSTOM"
  gallery_name        = "A_SAMPLE_ACG"
  resource_group_name = "ACG-RG-EXAMPLE"
}