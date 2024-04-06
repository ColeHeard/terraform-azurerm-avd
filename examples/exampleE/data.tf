###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Data
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
data "azurerm_resource_group" "sample" {
  name = "AVD-RG-SAMPLE"
}
data "azurerm_subnet" "usernet" {
  name                 = "SAMPLE_AVD_SUBNET"
  virtual_network_name = "SAMPLE_AVD_VNET"
  resource_group_name  = "NETWORK-RG-EXAMPLE"
}
data "azurerm_shared_image_version" "base_image" {
  name                = "2.4.3"
  image_name          = "BASEIMAGE-W11-23H2-A"
  gallery_name        = "A_SAMPLE_ACG"
  resource_group_name = "ACG-RG-EXAMPLE"
}