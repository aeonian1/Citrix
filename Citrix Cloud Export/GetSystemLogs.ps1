# Parameters
$customerId = ""                          # customer ID
$client_id = ""   # api user
$client_secret = ""           # api secret
$instanceId = ""  # site ID

# Token
$tokenUrl = 'https://api-us.cloud.com/cctrustoauth2/root/tokens/clients'
$response = Invoke-WebRequest $tokenUrl -Method POST -Body @{
  grant_type = "client_credentials"
  client_id = $client_id
  client_secret = $client_secret
}
$token = $response.Content | ConvertFrom-Json

$headers = @{
    Authorization = "CwsAuth Bearer=$($token.access_token)"
    'Citrix-CustomerId' = $customerId
    'Citrix-InstanceId' = $instanceId
    Accept = 'application/json'
  }

Write-Host "-- System Logs --"
# System Logs
$response = Invoke-WebRequest "https://api-us.cloud.com/systemlog/records" -Headers $headers

$json = ConvertFrom-Json $response
$items = $json.items | Where-Object { ([DateTime]::UtcNow - [DateTime]::Parse($_.utcTimestamp)).Days }

# Prepare an array to hold the data objects
$dataArray = @()

$items | ForEach-Object {
    $dataObject = New-Object PSObject -Property @{
        "Event Type" = $_.eventType
        "Target Email" = $_.targetEmail
        "Actor Display Name" = $_.actorDisplayName
        "Message" = $_.message.'en-US'
        "UTC Timestamp" = $_.utcTimestamp
    }
    # Add the data object to the array
    $dataArray += $dataObject
}

# Get the current date as a string
$dateString = Get-Date -Format "yyyyMMdd"

# Export the data to a CSV file, adding the date to the filename
$dataArray | Export-Csv -Path "$dateString-citrixSystemLogs.csv" -NoTypeInformation
