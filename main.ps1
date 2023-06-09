Import-Module ".\CloudConnector.psm1"
Import-Module ".\StoreFront.psm1"

# Import the object from the file
$dataObject = Import-Clixml -Path ".\Data\dataObject.xml"

#### Check Starts

# Cloud Connector
foreach ($computer in $dataObject.cloudconnector) {
    Invoke-Command -ComputerName $computer -ScriptBlock { CloudConnectorMain } -ArgumentList $dataObject.cloudconnector
}

# StoreFront
foreach ($computer in $dataObject.storefront) {
    Invoke-Command -ComputerName $computer -ScriptBlock { StoreFrontMain } -ArgumentList $dataObject.storefront
}

