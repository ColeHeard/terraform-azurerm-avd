###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Locals
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
locals {
  general01_vms_users = {
    bobjones = {
      network           = data.azurerm_subnet.network
      vmsize            = "Standard_D4as_v4"
      marketplace_image = null
      managed_image_id  = data.azurerm_shared_image_version.custom_image_1.id
      vmnumber          = 1 # Must be pool unique to avoid name collision.
    },
    janedoe = {
      network           = data.azurerm_subnet.network
      vmsize            = "Standard_D4s_v5"
      marketplace_image = var.market_place_images.win11s
      managed_image_id  = null
      vmnumber          = 2 # Must be pool unique to avoid name collision.
    },
    billsmith = {
      network           = data.azurerm_subnet.network
      vmsize            = "Standard_D4as_v4"
      marketplace_image = null
      managed_image_id  = data.azurerm_shared_image_version.custom_image_1.id
      vmnumber          = 4 # Must be pool unique to avoid name collision.
    },
    ferrisbeuller = {
      network           = data.azurerm_subnet.dmz_restricted
      vmsize            = "Standard_D2as_v4"
      marketplace_image = var.market_place_images.win11s
      managed_image_id  = null
      vmnumber          = 0 # Must be pool unique to avoid name collision.
    },
    sidious = {
      network           = data.azurerm_subnet.dmz_restricted
      vmsize            = "Standard_D2as_v4"
      marketplace_image = null
      managed_image_id  = data.azurerm_shared_image_version.custom_image_2.id
      vmnumber          = 66 # Must be pool unique to avoid name collision.
    },
    /*     foo = {
      network           = data.azurerm_subnet.network
      vmsize            = "Standard_D2s_v5"
      marketplace_image = var.market_place_images.win10s
      managed_image_id  = null
      vmnumber          = 3 # Must be pool unique to avoid name collision.
    }, */
    bar = {
      network           = data.azurerm_subnet.network
      vmsize            = "Standard_D2s_v5"
      marketplace_image = var.market_place_images.win10s
      managed_image_id  = null
      vmnumber          = 5 # Must be pool unique to avoid name collision.
    }
  }
  general02_vms_users = {
    user1 = {
      vmsize           = "Standard_D4as_v4"
      managed_image_id = data.azurerm_shared_image_version.custom_image_1.id
      vmnumber         = 1 # Must be pool unique to avoid name collision.
    },
    user2 = {
      vmsize           = "Standard_D2s_v5"
      managed_image_id = data.azurerm_shared_image_version.custom_image_2.id
      vmnumber         = 2 # Must be pool unique to avoid name collision.
    }
  }
}