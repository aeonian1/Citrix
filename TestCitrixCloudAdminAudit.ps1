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

  
# Get Site information 
function getSiteInfo {
$response = Invoke-WebRequest "https://api-us.cloud.com/catalogservice/$customerId/sites" -Headers $headers
$response.Content
}

# Get all administrators
$response = Invoke-WebRequest "https://api-us.cloud.com/cvad/manage/Admin/Administrators" -Headers $headers

# Prepare an empty array to hold data objects
$adminDataArray = @()

# Convert the response to JSON and iterate over each item
$response | ConvertFrom-Json | ForEach-Object {
  $_.Items | ForEach-Object {
      $adminData = New-Object PSObject -Property @{
          "DisplayName" = $_.User.DisplayName
          "Enabled"     = $_.Enabled
          "Roles"       = ($_.ScopesAndRoles | ForEach-Object { $_.Role.Name } | Sort-Object) -join ", "
      }
      # Add the data object to the array
      $adminDataArray += $adminData
  }
}

# Export the data to a CSV file, enforcing column order
$adminDataArray | Select-Object DisplayName, Enabled, Roles | Export-Csv -Path "test_administrator_audit.csv" -NoTypeInformation
