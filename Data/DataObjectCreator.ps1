# Define the object
$dataObject = @{
    "storefront" = "server1", "server2"
    "cloudconnector" = "ccserver1", "ccserver2"
    "provisioning" = "pvsserver1", "pvsserver2"
}

# Export the object to a file
$dataObject | Export-Clixml -Path "dataObject.xml"



