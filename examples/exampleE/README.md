# Example E - Creating VMs without companion module

This example environment demonstrates the creation of one shared desktop ("Power") pool without the use of the companion module. 

While the [**sessionhost companion module**](https://github.com/ColeHeard/terraform-azurerm-avdsh) does provide many more options, the core features pre-v1.1.0 are still present. 

Using the built in VM creation tool will forever tie each VM to an index created within the module argument *vmcount*. 

All machines must be identical for usage. Use only with managed images, FSLogix, and/or MSIX.
 
> Removal of individual, personal VMs may have unintended consequences on unrelated machines. **Read your Terraform Plan output!** 