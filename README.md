# terraform-azurerm-avd

## Azure Virtual Desktop

Author: Cole Heard

Date: 12/10/2022

Version: 1.0.0

This module includes all of the hostpool specific resources needed
to create a functioning Azure Virtual Desktop environment.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >=2.33.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.42.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_role_assignment.rbac](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_virtual_desktop_application.application](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application) | resource |
| [azurerm_virtual_desktop_application_group.app_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application_group) | resource |
| [azurerm_virtual_desktop_host_pool.pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool) | resource |
| [azurerm_virtual_desktop_host_pool_registration_info.token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool_registration_info) | resource |
| [azurerm_virtual_desktop_workspace.workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace) | resource |
| [azurerm_virtual_desktop_workspace_application_group_association.association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace_application_group_association) | resource |
| [azurerm_virtual_machine_extension.domain_join_ext](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.mmaagent_ext](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.vm_dsc_ext](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [azuread_group.aad_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_role_definition.avduser_role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |

## Example Usage:
```hcl
module "example" {

	 # Required Input
	 source  = "ColeHeard\avd\azurerm"
	 version  =
	 local_admin  = 
	 local_pass  = 
	 network_data  = 
	 pool_type  = 
	 region  = 
	 rg  = 

	 # Optional Input
	 aad_group_desktop  =
	 application_map  =
	 custom_rdp_properties  =
	 desktop_assignment_type  =
	 domain  =
	 domain_pass  =
	 domain_user  =
	 enable_agent_update_schedule  =
	 load_balancer_type  =
	 managed_image_id  =
	 market_place_image  =
	 maximum_sessions_allowed  =
	 ou  =
	 pool_number  =
	 region_prefix_map  =
	 tags  =
	 timezone  =
	 validate_environment  =
	 vmcount  =
	 vmsize  =
	 workspace_id  =
	 workspace_key  =
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_group_desktop"></a> [aad\_group\_desktop](#input\_aad\_group\_desktop) | The desktop pool's assignment AAD group. Required if var.pool\_type != application. | `string` | `null` | no |
| <a name="input_application_map"></a> [application\_map](#input\_application\_map) | A map of all applications and metadata. Required if var.pool\_type == application. | <pre>map(object({<br>    app_name     = string<br>    local_path   = string<br>    cmd_argument = string<br>    aad_group    = string<br>  }))</pre> | `null` | no |
| <a name="input_custom_rdp_properties"></a> [custom\_rdp\_properties](#input\_custom\_rdp\_properties) | Sets custom RDP properieties for the pool | `string` | `null` | no |
| <a name="input_desktop_assignment_type"></a> [desktop\_assignment\_type](#input\_desktop\_assignment\_type) | Sets the personal desktop assignment type. | `string` | `"Automatic"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain name string. | `string` | `null` | no |
| <a name="input_domain_pass"></a> [domain\_pass](#input\_domain\_pass) | Password for var.domain\_user | `string` | `null` | no |
| <a name="input_domain_user"></a> [domain\_user](#input\_domain\_user) | The identity that will join the VM to the domain. Omit the domain name itself. | `string` | `null` | no |
| <a name="input_enable_agent_update_schedule"></a> [enable\_agent\_update\_schedule](#input\_enable\_agent\_update\_schedule) | When enabled, the pool will only perform updates on the sessionhost agents at the selected time. | `bool` | `true` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | The method of load balancing the pool with use to distribute users across sessionhosts. | `string` | `"DepthFirst"` | no |
| <a name="input_local_admin"></a> [local\_admin](#input\_local\_admin) | The local administrator username. | `string` | n/a | yes |
| <a name="input_local_pass"></a> [local\_pass](#input\_local\_pass) | The local administrator password. | `string` | n/a | yes |
| <a name="input_managed_image_id"></a> [managed\_image\_id](#input\_managed\_image\_id) | The ID of an Azure Compute Gallery image. | `any` | `null` | no |
| <a name="input_market_place_image"></a> [market\_place\_image](#input\_market\_place\_image) | The publisher, offer, sku, and version of an image in Azure's market place. Only used if var.custom\_image is null. | `map(any)` | <pre>{<br>  "offer": "windows-10",<br>  "publisher": "microsoftwindowsdesktop",<br>  "sku": "win10-21h2-ent",<br>  "version": "latest"<br>}</pre> | no |
| <a name="input_maximum_sessions_allowed"></a> [maximum\_sessions\_allowed](#input\_maximum\_sessions\_allowed) | The maximum number of concurrent sessions on a single sessionhost | `number` | `3` | no |
| <a name="input_network_data"></a> [network\_data](#input\_network\_data) | The network data needed for sessionhost connectivity. | `any` | n/a | yes |
| <a name="input_ou"></a> [ou](#input\_ou) | The OU a VM should be placed within. | `string` | `""` | no |
| <a name="input_pool_number"></a> [pool\_number](#input\_pool\_number) | The number of this pool. Use to avoid name collision. | `number` | `1` | no |
| <a name="input_pool_type"></a> [pool\_type](#input\_pool\_type) | The pool type. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The desired Azure region for the pool. See also var.region\_prefix\_map. | `string` | n/a | yes |
| <a name="input_region_prefix_map"></a> [region\_prefix\_map](#input\_region\_prefix\_map) | A list of prefix strings to concat in locals. Can be replaced or appended. | `map(any)` | <pre>{<br>  "centralus": "USC",<br>  "eastus": "USE",<br>  "northcentralus": "NCU",<br>  "northeurope": "NEU",<br>  "norwayeast": "NWE",<br>  "norwaywest": "NWN",<br>  "southcentralus": "SCU",<br>  "swedencentral": "SWC",<br>  "switzerlandnorth": "SLN",<br>  "uksouth": "UKS",<br>  "ukwest": "UKW",<br>  "westcentral": "WCU",<br>  "westeurope": "WEU",<br>  "westus": "USW"<br>}</pre> | no |
| <a name="input_rg"></a> [rg](#input\_rg) | Name of the resource group. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags for the virtual machines and their subresources. | `map(any)` | <pre>{<br>  "Warning": "No tags"<br>}</pre> | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | The timezone used to schedule updates for the AVD, Geneva agent, and side-by-side stack agent. | `string` | `"Central Standard Time"` | no |
| <a name="input_validate_environment"></a> [validate\_environment](#input\_validate\_environment) | Set as true to enable validation environment. | `bool` | `false` | no |
| <a name="input_vmcount"></a> [vmcount](#input\_vmcount) | The number of VMs requested for this pool. | `number` | `1` | no |
| <a name="input_vmsize"></a> [vmsize](#input\_vmsize) | The VM SKU desired for the pool. If none are selected, VMSize will be chosen based on var.pool\_type. | `string` | `"standard_d2as_v4"` | no |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | The ID of the Log Analytics Workspace that will collect the data. | `string` | `null` | no |
| <a name="input_workspace_key"></a> [workspace\_key](#input\_workspace\_key) | The Log Analytics Workspace key. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_applications"></a> [applications](#output\_applications) | The application group(s) created by this module |
| <a name="output_pool"></a> [pool](#output\_pool) | The pool created by this module |
| <a name="output_region"></a> [region](#output\_region) | The Azure region selected for this pool |
| <a name="output_rg"></a> [rg](#output\_rg) | The resource group selected for this pool |
| <a name="output_timezone"></a> [timezone](#output\_timezone) | The timezone selected for this pool |
| <a name="output_token"></a> [token](#output\_token) | The hostpool token created for this pool. |
| <a name="output_workspace"></a> [workspace](#output\_workspace) | The workspace created by this module |

# Disclaimer

> See the LICENSE file for all disclaimers. Copyright (c) 2023 Cole Heard
