###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Data
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
data "azurerm_resource_group" "example" {
  name = "AVD-RG-EXAMPLE"
}
data "azurerm_subnet" "dmz_restricted" {
  name                 = "SAMPLE_AVD_SUBNET_DMZ"
  virtual_network_name = "SAMPLE_AVD_VNET_DMZ"
  resource_group_name  = "NETWORK-RG-EXAMPLE"
}
data "azurerm_shared_image_version" "custom_image_3" {
  name                = "2.0.0"
  image_name          = "W11-23H2-CUSTOM2"
  gallery_name        = "A_SAMPLE_ACG"
  resource_group_name = "ACG-RG-EXAMPLE"
}