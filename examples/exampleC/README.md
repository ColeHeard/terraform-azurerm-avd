# Example C - PWR

This example environment demonstrates the creation of a single shared desktop ("Power") pool. 

This example also demostrates that the exclusion of workspace_id and domain will skip the creation of the domain join extension (azurerm_virtual_machine_extension.domain_join_ext) and the log analytics extension (azurerm_virtual_machine_extension.mmaagent_ext). 