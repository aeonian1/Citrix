# Parameters
$customerId = ""                          # customer ID
$client_id = ""   # api user
$client_secret = ""           # api secret
$instanceId = ""  # site ID

# Token
$tokenUrl = 'https://api-us.cloud.com/cctrustoauth2/root/tokens/clients'
$response = Invoke-WebRequest $tokenUrl -Method POST -Body @{
  grant_type    = "client_credentials"
  client_id     = $client_id
  client_secret = $client_secret
}
$token = $response.Content | ConvertFrom-Json

# Headers 
$headers = @{
    Authorization       = "CwsAuth Bearer=$($token.access_token)"
    'Citrix-CustomerId' = $customerId
    'Citrix-InstanceId' = $instanceId
    Accept              = 'application/json'
  }


# Write out header
function titlebar {
  param (
    [Parameter(Mandatory = $true)]
    [string]$value
  )
  $hyphensStart = '*' * 30 + ' ' * 5
  $hyphensEnd = ' ' * 5 + '*' * 30

  Write-Host $hyphensStart $value $hyphensEnd
}

$filePath = 'test_data.json'

# Grab data form JSON file for all comparisons
$test_data = Get-Content -Path $filePath | ConvertFrom-Json


# Service Entitlement


function serviceEntitlement {
  
  $response = Invoke-WebRequest "https://core.citrixworkspacesapi.net/$customerId/serviceStates" -Headers $headers
  $serviceStates = $response | ConvertFrom-Json
  $filteredStates = $serviceStates.items | Where-Object { ($_.serviceName -eq 'xendesktop' -or $_.serviceName -eq 'netscalergateway') }

  foreach ($state in $filteredStates) {
    if ($state.daysToExpiration -lt 90) {
      Write-Host ""
      titlebar("Service Entitlement")
      Write-Host ""
      Write-Host "Service Name:".PadRight(50) $($state.serviceName) -ForegroundColor Red
      Write-Host "Days to Expiration:".PadRight(50) $($state.daysToExpiration) -ForegroundColor Red
      Write-Host ""
    }
  }
}


function systemLogs {
    Write-Host ""
    titlebar("System Logs")
  
    # System Logs
    $response = Invoke-WebRequest "https://api-us.cloud.com/systemlog/records" -Headers $headers
  
    $json = ConvertFrom-Json $response
    $items = $json.items | Where-Object { ([DateTime]::UtcNow - [DateTime]::Parse($_.utcTimestamp)).Days -lt 7 }
    $items | ForEach-Object {
      $eventType = $_.eventType
      $targetEmail = $_.targetEmail
      $actorDisplayName = $_.actorDisplayName
      $message = $_.message.'en-US'
      $utcTimestamp = $_.utcTimestamp
      Write-Output "`nEvent type: $eventType"
      Write-Output "Target email: $targetEmail"
      Write-Output "Actor display name: $actorDisplayName"
      Write-Output "Message: $message"
      Write-Output "UTC timestamp: $utcTimestamp`n"
    }
}

function getSite {
    Write-Host ""
    titlebar("Site Health")
    Write-Host ""
    $response = Invoke-WebRequest "https://api-us.cloud.com/cvad/manage/Zones" -Headers $headers
  
    $response = $response | ConvertFrom-Json | ForEach-Object {
      $resourceindex = 2
      $_.Items | ForEach-Object {
        $resource = "resource$resourceindex"
  
        if ($($_[0].Name) -eq $test_data.$resource.name) {
          Write-Host "Name:".PadRight(50) $($_[0].Name) -ForegroundColor Green
        }
        else {
          Write-Host "Name:".PadRight(50) $($_[0].Name) -ForegroundColor Red
        }
  
        if ($($_[0].IsHealthy) -eq $True) {
          Write-Host "IsHealthy:".PadRight(50) $($_[0].IsHealthy) -ForegroundColor Green
        }
        else {
          Write-Host "IsHealthy:".PadRight(50) $($_[0].IsHealthy) -ForegroundColor Red
        }
  
        if ($null -eq $($_[0].Metadata)) {
          Write-Host "Metadata:".PadRight(50) $($_[0].Metadata) -ForegroundColor Green
        }
        else {
          Write-Host "Metadata:".PadRight(50) $($_[0].Metadata) -ForegroundColor Red
        }
  
        Write-Host "`n"
        $resourceindex--
      }
    }
  }

function deliveryGroup {
    Write-Host ""
    titlebar("Delivery Group")
    Write-Host ""
    $response = Invoke-WebRequest "https://api-us.cloud.com/cvad/manage/DeliveryGroups" -Headers $headers
    $items = $response | ConvertFrom-Json | Select-Object -ExpandProperty Items | Select-Object -Property PublishedName, Enabled, DesktopsUnregistered, TotalDesktops, SessionCount
  
    for ($i = 0; $i -lt $items.Count; $i++) {
      $item = $items[$i]
      if ($item.DesktopsUnregistered -gt 0) {
        Write-Host "PublishedName:".PadRight(50) $($item.PublishedName) -Foreground Green
        if ($($item.Enabled) -eq "True") {
          Write-Host "Enabled:".PadRight(50) $($item.Enabled) -Foreground Green
        }
        else {
          Write-Host "Enabled:".PadRight(50) $($item.Enabled) -Foreground Red
        }
        
        if ($($item.DesktopsUnregistered) -eq 0) {
          Write-Host "DesktopsUnregistered:".PadRight(50) $($item.DesktopsUnregistered) -Foreground Green
        }
        else {
          Write-Host "DesktopsUnregistered:".PadRight(50) $($item.DesktopsUnregistered) -Foreground Red
        }
        
        Write-Host "TotalDesktops:".PadRight(50) $($item.TotalDesktops)
        Write-Host "SessionCount:".PadRight(50) $($item.SessionCount)
        Write-Host ""
      }
    }
  }

  function hypervisors {
    Write-Host ""
    titlebar("Hypervisors")
    Write-Host ""
  
    $hypervisorindex = 1
  
    $response = Invoke-WebRequest "https://api-us.cloud.com/cvad/manage/hypervisors" -Headers $headers
  
    $response | ConvertFrom-Json | ForEach-Object {
      $_.Items | ForEach-Object {
        $hypervisorkey = "hypervisor$hypervisorindex"

        if ($($_[0].Fault.State) -ne "None")  {
            if ($($_[0].Name) -eq $test_data.$hypervisorkey.name) {
                Write-Host "DisplayName:".PadRight(50) $($_[0].Name) -ForegroundColor Green
              }
              else {
                Write-Host "DisplayName:".PadRight(50) $($_[0].Name) -ForegroundColor Red
              }
        
              if ($($_[0].ConnectionType) -eq $test_data.$hypervisorkey.connectiontype) {
                Write-Host "ConnectionType:".PadRight(50) $($_[0].ConnectionType) -ForegroundColor Green
              }
              else {
                Write-Host "ConnectionType:".PadRight(50) $($_[0].ConnectionType) -ForegroundColor Red
              }
        
              if ($($_[0].Addresses) -eq $test_data.$hypervisorkey.address) {
                Write-Host "Address:".PadRight(50) $($_[0].Addresses) -ForegroundColor Green
              }
              else {
                Write-Host "Address:".PadRight(50) $($_[0].Addresses) -ForegroundColor Red
              }
        
              if ($($_[0].XDPath) -eq $test_data.$hypervisorkey.xdpath) {
                Write-Host "XDPath:".PadRight(50) $($_[0].XDPath) -ForegroundColor Green
              }
              else {
                Write-Host "XDPath:".PadRight(50) $($_[0].XDPath) -ForegroundColor Red
              }
        
              if ($($_[0].InMaintenanceMode) -eq $false) {
                Write-Host "InMaintenanceMode:".PadRight(50) $($_[0].InMaintenanceMode) -ForegroundColor Green
              }
              else {
                Write-Host "InMaintenanceMode:".PadRight(50) $($_[0].InMaintenanceMode) -ForegroundColor Red
              }
        
              if ($($_[0].Fault.State) -eq "None") {
                Write-Host "Faults:".PadRight(50) $($_[0].Fault.State) -ForegroundColor Green
              }
              else {
                Write-Host "Faults:".PadRight(50) $($_[0].Fault.Reason) -ForegroundColor Red
              }
              
              Write-Host ""
        }

        $hypervisorindex++
      }
    }
  }

  function getMachineCatalogs {
    Write-Host ""
    titlebar("Machine Catalogs")
    Write-Host ""
      
    $response = Invoke-WebRequest "https://api-us.cloud.com/cvad/manage/MachineCatalogs" -Headers $headers
    $items = $response | ConvertFrom-Json | Select-Object -ExpandProperty Items
      
    $machineindex = 1
      
    foreach ($item in $items) {
      $properties = @{
        Name                    = $item.Name
        ProvisioningType        = $item.ProvisioningType
        AllocationType          = $item.AllocationType
        AssignedCount           = $item.AssignedCount
        AvailableCount          = $item.AvailableCount
        ControllerAddresses     = $item.ProvisioningScheme.ControllerAddresses
        ImageName               = $item.ProvisioningScheme.CurrentDiskImage.Image.Name
        ImagePath               = $item.ProvisioningScheme.CurrentDiskImage.Image.XDPath
        ImageDate               = $item.ProvisioningScheme.CurrentDiskImage.Date
        DiskSizeGB              = $item.ProvisioningScheme.DiskSizeGB
        Hypervisor              = $item.ProvisioningScheme.ResourcePool.Hypervisor.Name
        SessionSupport          = $item.SessionSupport
        IsMasterImageAssociated = $item.IsMasterImageAssociated
        Errors                  = $item.Errors
        Warnings                = $item.Warnings
      }

      if ($item.Errors.Count -gt 0 -or $item.Warnings.Count -gt 0) {
        $orderedKeys = @(
            'Name',
            'ProvisioningType',
            'AllocationType',
            'AssignedCount',
            'AvailableCount',
            'ControllerAddresses',
            'DiskSizeGB',
            'Hypervisor',
            'ImageName',
            'ImagePath',
            'ImageDate',
            'IsMasterImageAssociated',
            'SessionSupport',
            'Errors',
            'Warnings'
          )
          
          $machinecatalogkey = "machinecatalog$machineindex"
          
          foreach ($property in $orderedKeys) {
            if ($property -eq "Errors" -or $property -eq "Warnings") {
              if ($properties[$property].Count -eq 0) {
                Write-Host "$property :".PadRight(50) $($properties[$property]) -ForegroundColor Green
              } else {
                Write-Host "$property :".PadRight(50) $($properties[$property]) -ForegroundColor Red
              }
              
            }
            elseif ($properties[$property] -eq $test_data.$machinecatalogkey.$property) {
              Write-Host "$property :".PadRight(50) $($properties[$property]) -ForegroundColor Green
            }
            else {
              Write-Host "$property :".PadRight(50) $($properties[$property]) -ForegroundColor Red
            }
          }
      }
      
      
      
      $machineindex++
      Write-Host ""
    }
  }


  function getMachines {
    Write-Host ""
    titlebar("Machines With Faults")
    Write-Host ""
    $response = Invoke-WebRequest "https://api-us.cloud.com/cvad/manage/Machines" -Headers $headers
  
    $response = $response | ConvertFrom-Json | Select-Object -ExpandProperty Items
  
    $properties = @(
      "DnsName",
      "IPAddress",
      "AgentVersion",
      "PowerState",
      "RegistrationState",
      "InMaintenanceMode",
      "SessionCount",
      "LastDeregistrationReason",
      "LastDeregistrationTime",
      "LastErrorReason",
      "LastErrorTime"
    )
  
    foreach ($item in $response) {
      if ($item.RegistrationState -ne "Registered") {
        foreach ($property in $properties) {
          Write-Host "$property : $($item.$property)" -ForegroundColor Red
        }
        Write-Host ""
      }
    }
  }


serviceEntitlement
getSite
systemLogs
hypervisors
getMachines
getMachineCatalogs
deliveryGroup


