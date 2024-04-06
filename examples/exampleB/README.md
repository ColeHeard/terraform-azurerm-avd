# Example B - Application Streaming hosts.

This example environment demonstrates the creation of a single application streaming ("Application") pool, occasionally referreed to as "RAIL".

Take note of the syntax used for var.blue_app, var.red_app, and var.yellow_app.

Each unique aad_group key value will create a new application group. 

Each application will tie to the application group with the matching aad_group.

Note the use of the managed_image_id field. This field accepts an azurerm_shared_image_version image; allowing custom "golden" images to be used in lieu of a market place image. 

> If you're looking to build a shared desktop environment, you may also consider (**FSLogix**)[https://learn.microsoft.com/en-us/fslogix/overview-what-is-fslogix].