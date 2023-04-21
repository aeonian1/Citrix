###
# This tool is used to gather state information about Citrix StoreFront
#
# Updated    - 2023-04-11
# Updated By - MW 
# Version    - 1
###

## TODO - IIS CHECK
## Native citrix commands without Cloud login
## CHECK WHO IS USER


$global:counter = 0
$global:errorlist = @()

function Compare-String($string1, $string2){
    if($string1 -eq $string2){
        Write-Host "$string1".PadRight(50) + " -   $string2" -ForegroundColor Green
    }
    else{
        Write-Host "$string1".PadRight(50) + " -   $string2" -ForegroundColor Red
    }
}


# Checks the status of services on Citrix Cloud connectors and provides basic info if they failed
Function Check-ServiceStatus {
    param (
        [Parameter(Mandatory=$true)]
        [String]$ServiceName
    )
    $Service = Get-Service -Name $ServiceName
    $LeftSpaced = '{0, -50}' -f $Service.DisplayName + " - "

    if ($Service -ne $null -and $Service.Status -eq 'Running') {
        Write-Host $LeftSpaced $Service.Status -ForegroundColor Green
    } else {
        Write-Host $LeftSpaced $Service.Status -ForegroundColor Red

        # Append service name to errorlist
        $global:errorlist += "Service - " + $ServiceName + " - " + $Service.Status
        $global:counter++


        switch ($ServiceName) {
            "CitrixClusterService" { 
                Write-Host "File Location: C:\Program Files\Citrix\Receiver StoreFront\Services\ClusterService\Citrix.DeliveryServices.ClusterService.ServiceHost.exe"
                Write-Host "Description:   Provides server group join services"
                Write-Host ""
             }
            "CitrixConfigurationReplication" { 
                Write-Host "File Location: C:\Program Files\Citrix\Receiver StoreFront\Services\ConfigurationReplicationService\Citrix.DeliveryServices.ConfigurationReplicationService.ServiceHost.exe"
                Write-Host "Description:   Provides access to Delivery Services configuration Information"
                Write-Host ""
            }
            "CitrixCredentialWallet" { 
                Write-Host "File Location: C:\Program Files\Citrix\Receiver StoreFront\Services\CredentialWallet\Citrix.DeliveryServices.CredentialWallet.ServiceHost.exe"
                Write-Host "Description:   Provides a secure store of Credentials"
                Write-Host ""
            }
            "CitrixDefaultDomainService" { 
                Write-Host "File Location: C:\Program Files\Citrix\Receiver StoreFront\Services\DefaultDomainServices\Citrix.DeliveryServices.DomainServices.ServiceHost.exe"
                Write-Host "Description:   Provides authentication, change password, and other domain services"
                Write-Host ""
            }
            "Citrix Peer Resolution Service" { 
                Write-Host "File Location: C:\Program Files\Citrix\Receiver StoreFront\Services\PeerNameResolution\Citrix.DeliveryServices.PeerNameResolution.ServiceHost.exe"
                Write-Host "Description:   Resolves peer names within peer-to-peer meshes"
                Write-Host ""
            }
            "CitrixServiceMonitor" { 
                Write-Host "File Location: C:\Program Files\Citrix\Receiver StoreFront\Services\ServiceMonitor\Citrix.DeliveryServices.ServiceMonitor.ServiceHost.exe"
                Write-Host "Description:   Provides health monitoring of StoreFront services"
                Write-Host ""
            }
            "CitrixSubscriptionsStore" { 
                Write-Host "File Location: C:\Program Files\Citrix\Receiver StoreFront\Services\CitrixSubscriptionsStore\Citrix.DeliveryServices.CitrixSubscriptionsStore.ServiceHost.exe"
                Write-Host "Description:   Provides a store and replication of user subscriptions"
                Write-Host ""
            }
            "CitrixTelemetryService" { 
                Write-Host "File Location: C:\Program Files\Citrix\Telemetry Service\TelemetryService.exe"
                Write-Host "Description:   Telemetry Service"
                Write-Host ""
            }
            Default {
                Write-Host "Something went wrong"
            }
        }
    }
}

function systemInfo {
    $disk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object Size,FreeSpace
    $diskSize = [math]::Round($disk.Size / 1GB)
    $diskFree = [math]::Round($disk.FreeSpace / 1GB)
    $diskPercentFree = [math]::Round(($disk.FreeSpace / $disk.Size) * 100)

    $disk2 = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='E:'" | Select-Object Size,FreeSpace
    $diskSize2 = [math]::Round($disk2.Size / 1GB)
    $diskFree2 = [math]::Round($disk2.FreeSpace / 1GB)
    $diskPercentFree2 = [math]::Round(($disk2.FreeSpace / $disk2.Size) * 100)

    $cpuCores = (Get-WmiObject -Class Win32_Processor).NumberOfCores
    $cpuUsage = Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
    
    $memory = Get-WmiObject -Class Win32_ComputerSystem | Select-Object TotalPhysicalMemory
    $memorySize = [math]::Round($memory.TotalPhysicalMemory / 1GB)
    $memoryUsage = Get-WmiObject -Class Win32_OperatingSystem | Select-Object FreePhysicalMemory,TotalVisibleMemorySize | ForEach-Object {[math]::Round((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory) / $_.TotalVisibleMemorySize) * 100)}
    
    $swap = Get-WmiObject -Class Win32_PageFileUsage | Select-Object AllocatedBaseSize,CurrentUsage
    $swapSize = [math]::Round($swap.AllocatedBaseSize / 1GB)
    $swapUsage = [math]::Round($swap.CurrentUsage / 1GB)

    Write-Host "DISK C:                                            -  $diskFree GB / $diskSize GB ($diskPercentFree%)"
    Write-Host "DISK E:                                            -  $diskFree2 GB / $diskSize2 GB ($diskPercentFree2%)"
    Write-Host "CPU                                                -  $cpuUsage% ($cpuCores cores)"
    Write-Host "MEMORY                                             -  $memoryUsage% ($memorySize GB)"
    Write-Host "SWAP                                               -  $swapUsage GB / $swapSize GB"
}

# Checks the expected value for a registry property against the existing
function RegistryOutput {
    param (
        [Parameter(Mandatory=$true)]
        [String]$Path,
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [String]$ExpectedValue,
        [Parameter(Mandatory=$true)]
        [String]$Title
    )

    $LeftSpaced = '{0, -50}' -f $Title + " - "

    if ((Get-ItemPropertyValue -Path $Path -Name $Name) -eq $ExpectedValue) {
        Write-Host $LeftSpaced (Get-ItemPropertyValue -Path $Path -Name $Name) -ForegroundColor Green
    } else {
        Write-Host $LeftSpaced (Get-ItemPropertyValue -Path $Path -Name $Name) - "Expected Value = " $ExpectedValue -ForegroundColor Red

        $global:errorlist += $LeftSpaced + (Get-ItemPropertyValue -Path $Path -Name $Name) - "Expected Value = " + $ExpectedValue
        $global:counter++
    }
}


# Checks the status of Citrix servics
function serviceCheck {
    # Check Service
    Write-Host "`n# Service Status" -ForegroundColor Yellow
    Check-ServiceStatus("CitrixClusterService")
    Check-ServiceStatus("CitrixConfigurationReplication")
    Check-ServiceStatus("CitrixCredentialWallet")
    Check-ServiceStatus("CitrixDefaultDomainService")
    Check-ServiceStatus("Citrix Peer Resolution Service")
    Check-ServiceStatus("CitrixServiceMonitor")
    Check-ServiceStatus("CitrixSubscriptionsStore")
    Check-ServiceStatus("CitrixTelemetryService")
}


# Gets Config Replication Information
function configReplicationStatus {
    Write-Host "`n# Config Replication Status" -ForegroundColor Yellow
    RegistryOutput -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastSourceServer" -ExpectedValue (Get-ItemPropertyValue -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastSourceServer") -Title "Last Source Server"
    RegistryOutput -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastStartTime" -ExpectedValue (Get-ItemPropertyValue -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastStartTime") -Title "Last Start Time Config Replication"
    RegistryOutput -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastEndTime" -ExpectedValue (Get-ItemPropertyValue -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastEndTime") -Title "Last End Time Config Replication"
    RegistryOutput -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastUpdateStatus" -ExpectedValue "Complete" -Title "Last Update Status"
    # RegistryOutput -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastErrorMessage" -ExpectedValue " " -Title "Last Error Message" -WarningAction Ignore
}



# Performs a ping test against the Service Address
function pingCheck {
    Write-Host "`n# Ping Test" -ForegroundColor Yellow
    if (Test-Connection (Get-ItemPropertyValue -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "ServiceAddressFormat")) {
        RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "ServiceAddressFormat" -ExpectedValue "https://service-us.citrixworkspaceapi.net/" -Title "Connection Status"
    } else {
        RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "ServiceAddressFormat" -ExpectedValue "https://service-us.citrixworkspaceapi.net/" -Title "Connection Status"
    }
    if (Test-Connection (Get-ItemPropertyValue -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "ServiceAddressFormat")) {
        RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "ServiceAddressFormatGlobal" -ExpectedValue "https://service.citrixworkspaceapi.net/" -Title "Connection Status Global"
    } else {
        RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "ServiceAddressFormatGlobal" -ExpectedValue "https://service.citrixworkspaceapi.net/" -Title "Connection Status Global"
    }
}

# Gets windows events 
function getEvents {
    $yesterday = (Get-Date) - (New-TimeSpan -Days 1)
    Write-Host "`n--- Citrix Application Events - FATAL / ERROR / WARNING ---" -ForegroundColor Yellow
    try { 
        $event = Get-WinEvent -FilterHashtable @{LogName='Application'; ProviderName='Citrix*'; Level=1,2,3; StartTime=$yesterday} -ErrorAction Ignore  
        if ($event -eq $null) {
            Write-Host "No Events Found"
        } else {
            Write-Host $event | Format-List
        }
    } catch { Write-Host "No Events Found" }
}

function iisInfo {
    # Get IIS status
    $iisStatus = Get-Service W3SVC | Select-Object -ExpandProperty Status

    # Get IIS version
    $iisVersion = (Get-WebConfigurationProperty -filter /system.webServer/serverRuntime -name "version").Value

    # Get IIS application pool information
    $appPools = Get-ChildItem IIS:\AppPools | Select-Object Name, State, ManagedRuntimeVersion

    # Format output
    $output = @{
        "IIS Status" = $iisStatus
        "IIS Version" = $iisVersion
        "Application Pools" = $appPools
    }

    $output.GetEnumerator() | ForEach-Object {
        $var = $_.Key
        $value = $_.Value
        "$var".PadRight(50) + " -   $value"
    }
}


function getInfo {
    Write-Host "`n--- StoreFront Get Commands ---" -ForegroundColor Yellow

    Compare-String(Get-STFDeployment | Select-Object -Property "Hostbaseurl", "https://storefront./") 
    Compare-String(Get-STFServerGroup | Select-Object -Property "ClusterMembers", "{,,,}")
    Get-STFVersion 
    Compare-String(Get-STFRoamingGateway | Select-Object -Property "Name", "")
    Compare-String(Get-STFRoamingGateway | Select-Object -Property "Logon", "")
    Compare-String(Get-STFRoamingGateway | Select-Object -Property "CallbackUrl", "")
    Compare-String(Get-STFRoamingGateway | Select-Object -Property "Location", "")
    Compare-String(Get-STFRoamingGateway | Select-Object -Property "SessionReliability", "")
    Compare-String(Get-STFRoamingGateway | Select-Object -Property "RequestTicketTwoStas", "")
    Compare-String(Get-STFRoamingGateway | Select-Object -Property "StasUseLoadBalancing", "")
    Compare-String(Get-STFRoamingGateway | Select-Object -Property "StasBypassDuration", "")
    Compare-String(Get-STFRoamingGateway | Select-Object -Property "SecureTicketAuthorityUrls", "")
    Get-STFStoreService | Select-Object -Property Name, ConfigurationFile
}

# Entry point into this script
function main {
    systemInfo
    serviceCheck
    configReplicationStatus
    # iisInfo
    getInfo


    # Missing DNS entries 
    #pingCheck()

    if ($global:counter -ne 0) {
        Write-Host "`nErrors Found" -ForegroundColor Red
        foreach ($error in $global:errorlist) {
            Write-Host "`t$error" -ForegroundColor Red
        }
    }

    getEvents
}

main
