# Example D - Temporary Presistent desktop pool & edge cases

This example environment demonstrates the creation of one persistent personal ("General") pool. The session-host module is looped with the count arguement. Each machine here is "personal", but temporary in lifecycle. This exists to provide workarounds for multisession application incompatibility. 

In this scenario, you would only ever provide access to basic "secure" applications on a managed image without local admin rights. 

This example also demostrates that the exclusion of workspace_id and domain will skip the creation of the domain join extension (azurerm_virtual_machine_extension.domain_join_ext) and the log analytics extension (azurerm_virtual_machine_extension.mmaagent_ext). 

> If you're looking to build an ephemeral desktop environment, see what is coming down the road for [**Ephemeral Disks**](https://learn.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks). With FSLogix and MSIX, you could live without a persistent C: drive with a persistent OS.