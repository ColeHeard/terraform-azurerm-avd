###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Data
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
data "azurerm_resource_group" "example" {
  name = "DEV-RG-EXAMPLE"
}
data "azurerm_subnet" "network" {
  name                 = "SAMPLE_AVD_SUBNET"
  virtual_network_name = "SAMPLE_AVD_VNET"
  resource_group_name  = "NETWORK-RG-EXAMPLE"
}
data "azurerm_shared_image_version" "prod_image55_1_16" {
  name                = "1.16.0"
  image_name          = "W11-23H2-CUSTOM55"
  gallery_name        = "A_SAMPLE_ACG"
  resource_group_name = "ACG-RG-EXAMPLE"
}
data "azurerm_shared_image_version" "prod_image55_1_17_2" {
  name                = "1.17.2"
  image_name          = "W11-23H2-CUSTOM55"
  gallery_name        = "A_SAMPLE_ACG"
  resource_group_name = "ACG-RG-EXAMPLE"
}