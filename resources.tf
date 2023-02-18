###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Resources
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
# The hostpool uses logic from var.pool_type to set the majority of the fields. 
# Description and RDP properties are "changed" every deployment. Lifecycle block prevents this update. 
resource "azurerm_virtual_desktop_host_pool" "pool" {
  resource_group_name              = var.rg
  location                         = var.region
  name                             = "${local.prefix}-HP"
  friendly_name                    = "${local.prefix}-HP"
  validate_environment             = var.validate_environment
  custom_rdp_properties            = var.custom_rdp_properties
  description                      = "The ${local.prefix}-HP was created with Terraform on ${formatdate("EEEE, DD-MMM-YY 'at' HH:mmaaz", timestamp())}."
  type                             = var.pool_type == "Desktop" ? "Personal" : "Pooled"
  maximum_sessions_allowed         = var.pool_type == "Desktop" ? null : var.maximum_sessions_allowed
  personal_desktop_assignment_type = var.pool_type == "Desktop" ? var.desktop_assignment_type : null
  start_vm_on_connect              = var.pool_type != "Application" ? true : false
  load_balancer_type               = var.pool_type == "Desktop" ? "Persistent" : var.load_balancer_type
  preferred_app_group_type         = var.pool_type != "Application" ? "Desktop" : "RailApplications"
  scheduled_agent_updates {
    enabled  = var.enable_agent_update_schedule
    timezone = var.timezone
    schedule {
      day_of_week = "Saturday"
      hour_of_day = 2
    }
    schedule {
      day_of_week = "Sunday"
      hour_of_day = 2
    }
  }
  lifecycle {
    ignore_changes = [
      description,
      custom_rdp_properties
    ]
  }
  tags = local.tags
}
# The hostpools registration token. Used by the DSC extension/AVD agent to tie the virtual machine to the hostpool as a "Sessionhost."
resource "azurerm_virtual_desktop_host_pool_registration_info" "token" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.pool.id
  expiration_date = timeadd(timestamp(), "2h")
}
# Functionally, workspaces have a 1-to-1 relationship with the hostpool. The friendly_name field is surfaced to the end user.
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = "${local.prefix}-WS"
  friendly_name       = "Virtual ${var.pool_type != "Application" ? "Applications" : "Desktop"} Workspace"
  description         = "The ${local.prefix}-WS was created with Terraform on ${formatdate("EEEE, DD-MMM-YY 'at' HH:mmaaz", timestamp())}."
  resource_group_name = var.rg
  location            = var.region
  tags                = local.tags
  lifecycle {
    ignore_changes = [
      description
    ]
  }
}
# The application group. In this module it is limited to a single AAD group. You can use outputs to add additional groups from the root module.
resource "azurerm_virtual_desktop_application_group" "app_group" {
  for_each            = toset(local.aad_group_list)
  name                = "${local.prefix}-AG${format("%02d", "${index(local.aad_group_list, each.value) + 1}")}"
  friendly_name       = "${each.value} application group"
  description         = "${each.value} application group - created with Terraform on ${formatdate("EEEE, DD-MMM-YY 'at' HH:mmaaz", timestamp())}."
  resource_group_name = var.rg
  host_pool_id        = azurerm_virtual_desktop_host_pool.pool.id
  location            = var.region
  type                = var.pool_type == "Application" ? "RemoteApp" : "Desktop"
  tags                = local.tags
}
# The association object ties the application group(s) to the workspace.
resource "azurerm_virtual_desktop_workspace_application_group_association" "association" {
  for_each             = toset(local.aad_group_list)
  application_group_id = azurerm_virtual_desktop_application_group.app_group[each.value].id
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
}
# AAD group role and scope assignment.
resource "azurerm_role_assignment" "rbac" {
  for_each           = toset(local.aad_group_list)
  scope              = azurerm_virtual_desktop_application_group.app_group[each.value].id
  role_definition_id = data.azurerm_role_definition.avduser_role.id
  principal_id       = data.azuread_group.aad_group[each.value].id
}
# Applications for RAIL pools.
resource "azurerm_virtual_desktop_application" "application" {
  for_each                     = local.applications
  name                         = replace(each.value["app_name"], " ", "")
  friendly_name                = each.value["app_name"]
  description                  = "${each.value["app_name"]} application - created with Terraform on ${formatdate("EEEE, DD-MMM-YY 'at' HH:mmaaz", timestamp())}."
  application_group_id         = azurerm_virtual_desktop_application_group.app_group[each.value["aad_group"]].id
  path                         = each.value["local_path"]
  command_line_argument_policy = each.value["cmd_argument"] != null ? "DoNotAllow" : "Require"
  command_line_arguments       = each.value["cmd_argument"]
  show_in_portal               = true
  icon_path                    = each.value["local_path"]
  icon_index                   = 0
  lifecycle {
    ignore_changes = [
      description
    ]
  }
}
# The virtual machine and disk.
resource "azurerm_windows_virtual_machine" "vm" {
  count                 = var.vmcount
  name                  = "${local.prefix}-${format("%02d", count.index)}"
  resource_group_name   = var.rg
  location              = var.region
  size                  = var.vmsize
  network_interface_ids = ["${azurerm_network_interface.nic.*.id[count.index]}"]
  provision_vm_agent    = true
  admin_username        = var.local_admin
  admin_password        = var.local_pass
  os_disk {
    name                 = "${local.prefix}-${format("%02d", count.index)}-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_id = var.managed_image_id
  dynamic "source_image_reference" {
    for_each = var.managed_image_id == null ? ["var.managed_image_id is null, single loop!"] : []
    content {
      publisher = var.market_place_image.publisher
      offer     = var.market_place_image.offer
      sku       = var.market_place_image.sku
      version   = var.market_place_image.version
    }
  }
  depends_on = [
    azurerm_network_interface.nic
  ]
  tags = merge(local.tags, {
    Automation = "OU check - AVD"
  })
}
# The sessionhost's NIC.
resource "azurerm_network_interface" "nic" {
  count               = var.vmcount
  name                = "${local.prefix}-${format("%02d", count.index)}-nic"
  resource_group_name = var.rg
  location            = var.region
  ip_configuration {
    name                          = "${lower(local.prefix)}_${format("%02d", count.index)}_config)"
    subnet_id                     = var.network_data.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = local.tags
}
# Required extension - the DSC installs all three agents and passes the registration token to the AVD agent.
# As local.token is updated dynamically, the lifecycle block is used to prevent needless recreation of the resource.
resource "azurerm_virtual_machine_extension" "vm_dsc_ext" {
  count                      = var.vmcount
  name                       = "${local.prefix}-${format("%02d", count.index)}-avd_dsc"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true
  settings                   = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.pool.name}"
      }
    }
SETTINGS
  protected_settings         = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${local.token}"
    }
  }
PROTECTED_SETTINGS
  depends_on = [
    azurerm_virtual_desktop_host_pool.pool
  ]
  lifecycle {
    ignore_changes = [
      protected_settings,
    ]
  }
}
# Optional extension - only created if var.domain does not equal null.
# The lifecycle block prevents recreation for the existing VMs ext. when credentials are updated.
resource "azurerm_virtual_machine_extension" "domain_join_ext" {
  count                      = local.extensions.domain_join
  name                       = "${local.prefix}-${format("%02d", count.index)}-domainJoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
    {
      "Name": "${var.domain}",
      "OUPath": "${var.ou}",
      "User": "${var.domain_user}@${var.domain}",
      "Restart": "true",
      "Options": "3"
    }
SETTINGS
  protected_settings         = <<PROTECTED_SETTINGS
    {
      "Password": "${var.domain_pass}"
    }
PROTECTED_SETTINGS
  lifecycle {
    ignore_changes = [settings, protected_settings]
  }
}
# Optional extension - only created if var.workspaceid does not equal null.
resource "azurerm_virtual_machine_extension" "mmaagent_ext" {
  count                      = local.extensions.mmaagent
  name                       = "${local.prefix}-${format("%02d", count.index)}-avd_mma"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.*.id[count.index]
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
    {
      "workspaceId": "${var.workspace_id}"
    }
SETTINGS
  protected_settings         = <<PROTECTED_SETTINGS
   {
      "workspaceKey": "${var.workspace_key}"
   }
PROTECTED_SETTINGS
}