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
    RegistryOutput -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastErrorMessage" -ExpectedValue " " -Title "Last Error Message"
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
    try {Get-WinEvent -FilterHashtable @{LogName='Application'; ProviderName='Citrix*'; Level=1,2,3; StartTime=$yesterday} -ErrorAction Ignore | Format-List } catch { Write-Host "No Events Found"}
}

# Entry point into this script
function main {
    serviceCheck
    configReplicationStatus


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
