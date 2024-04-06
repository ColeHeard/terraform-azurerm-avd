# Example A - Shared Desktop "Power" Pool

This example environment demonstrates the creation of a single shared desktop ("Power") pool. 

You can really leverage cost savings with scaling plans here - but the mutltisession environment can require some serious manpower to automate the stack. 

Note the use of the managed_image_id field. This field accepts an azurerm_shared_image_version image; allowing custom "golden" images to be used in lieu of a market place image. 

> If you're looking to build a shared desktop environment, you may also consider (**FSLogix**)[https://learn.microsoft.com/en-us/fslogix/overview-what-is-fslogix].