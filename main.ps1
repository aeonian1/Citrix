Import-Module PSScriptRoot\CloudConnector.ps1
Import-Module PSScriptRoot\StoreFront.ps1

# Import the object from the file
$dataObject = Import-Clixml -Path ".\Data\dataObject.xml"

# Loop through each computer in the array and run a command
foreach ($computer in $dataObject.cloudconnector) {
    Invoke-Command -ComputerName $computer -ScriptBlock { CloudConnectorMain }
}

foreach ($computer in $dataObject.storefront) {
    Invoke-Command -ComputerName $computer -ScriptBlock { StoreFrontMain }
}

