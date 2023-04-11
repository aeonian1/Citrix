###
# This tool is used to gather state information about Citrix Cloud Connectors
#
# Updated    - 2023-04-11
# Updated By - MW 
###

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
            "cdfCaptureService" { 
                Write-Host "File Location: C:\Program Files\Citrix\CdfCaptureService\CdfCaptureService.exe"
                Write-Host "Description: Captures CDF traces from all configured components and components"
                Write-Host ""
             }
            "Citrix Cloud Connector Metrics Service" { 
                Write-Host "File Location: C:\Program Files(x86)\Citrix\NetScaler Cloud Gateway\MetricsService.exe"
                Write-Host "Description: Responsible for collection of metrics from the NetScaler Gateway Service as well as for the generation of Synthetics. This service forwards all the data from the Cloud Connector to the Analytics Service"
                Write-Host ""
            }
            "Citrix NetScaler Cloud Gateway" { 
                Write-Host "File Location: C:\Program Files(x86)\Citrix\NetScaler Cloud Gateway\Citrix.NetScaler.CloudGateway.exe"
                Write-Host "Description: Provides internet connectivity to on-premise desktops and applications without the need to open in-bound firewall rules or deploying components in the DMZ"
                Write-Host ""
            }
            "CitrixClxMtpService" { 
                Write-Host "File Location: C:\Program Files\Citrix\ClxMtpService\Citrix.ClxMtpService.exe"
                Write-Host "Description: ClxMtp Service"
                Write-Host ""
            }
            "CitrixConfigSyncService" { 
                Write-Host "File Location: C:\Program Files\Citrix\ConfigSync\ConfigSyncService.exe"
                Write-Host "Description: Copies brokering configuration locally for high availability mode"
                Write-Host ""
            } 
            "CitrixHighAvailabilityService" { 
                Write-Host "File Location: C:\Program Files\Citrix\Broker\Service\HighAvailabilityService.exe"
                Write-Host "Description: Provides continuity of service during outage of central site"
                Write-Host ""
            }
            "CitrixITSMAdapterProvider" {
                Write-Host "File Location: C:\Program Files\Citrix\CitrixITSMAdapterProvider\WorkspaceAutomationConnectorPlugin.exe"
                Write-Host "Description: Automate provisioning and management of Virtual Apps and Desktops"
                Write-Host ""
             }
            "CitrixWEMAuthSvc" {
                Write-Host "File Location: C:\Program Files\Citrix\WemProvider\Connector.Authentication.Host.exe"
                Write-Host "Description: Provides authentication service for Citrix WEM Agents to connect to cloud infrastructure servers"
                Write-Host ""
             }
            "CitrixWemMsgSvc" {
                Write-Host "File Location: C:\Program Files\Citrix\WemProvider\Connector.Messaging.Host.exe"
                Write-Host "Description: Provides service for Citrix WEM Cloud service to receive messages from cloud infrastructure servers"
                Write-Host ""
             }
            "CitrixWorkspaceCloudADProvider" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\Agent\Citrix.CloudServices.Agent.exe"
                Write-Host "Description: Enabled the Citrix Cloud to facilitate management of resources associated with the Active Directory domain accounts it is installed into"
                Write-Host ""
             }
            "CitrixWorkspaceCloudAgentDiscovery" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\Agent Discovery\Citrix.CloudServices.AgentDiscovery.exe"
                Write-Host "Description: Enables the Cloud to faciliate management of XenApp and XenDesktop (Legacy)"
                Write-Host ""
             }
            "CitrixWorkspaceCloudAgentLogger" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\AgentLogger\Citrix.CloudServices.AgentLogger.exe"
                Write-Host "Description: Enables the Cloud to faciliate management of XenApp and XenDesktop (Legacy)"
                Write-Host ""
             }
            "CitrixWorkspaceCloudAgentSystem" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\AgentSystem\Citrix.CloudServices.AgentSystem.exe"
                Write-Host "Description: Handles the system calls necessary for the on-premise agents"
                Write-Host ""
             }
            "CitrixWorkspaceCloudAgentWatchdog" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\AgentWatchDog\Citrix.CloudServices.AgentWatchDog.exe"
                Write-Host "Description: Monitors and upgrades the on-premise agents"
                Write-Host ""
             }
            "CitrixWorkspaceCloudCredentialProvider" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\CredentialProvider\Citrix.CloudServices.CredentialProvider.exe"
                Write-Host "Description: Citrix Cloud credential provider"
                Write-Host ""
             }
            "CitrixWorkspaceCloudWebRelayProvider" { 
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\WebRelayAgent\Citrix.CloudServices.WebRelay.Agent.exe"
                Write-Host "Description: Enables HTTP Requests received from WebRelay Cloud service to be forwarded to on-premises Web Servers"
                Write-Host ""
            }
            "RemoteHCLServer" {
                Write-Host "File Location: C:\Program Files\Citrix\RemoteHCLServer\Service\RemoteHCLServer.exe"
                Write-Host "Description: Proxies communication between the Delivery Controller and the Hypervisor"
                Write-Host ""
             }
            "XaXdCloudProxy" { 
                Write-Host "File Location: C:\Program Files\Citrix\XaXdCloudProxy\XaXdCloudProxy.exe"
                Write-Host "Description: Enables communication to a remote Broker service from local VDAs and StoreFront servers"
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

        $global:errorlist += write-host $LeftSpaced (Get-ItemPropertyValue -Path $Path -Name $Name) - "Expected Value = " $ExpectedValue -ForegroundColor Red
        $global:counter++
    }
}


# Checks the status of Citrix servics
function serviceCheck {
    # Check Service
    Write-Host "`n# Service Status" -ForegroundColor Yellow
    Check-ServiceStatus("cdfCaptureService")
    Check-ServiceStatus("Citrix Cloud Connector Metrics Service")
    Check-ServiceStatus("Citrix NetScaler Cloud Gateway")
    Check-ServiceStatus("CitrixClxMtpService")
    Check-ServiceStatus("CitrixConfigSyncService")
    Check-ServiceStatus("CitrixHighAvailabilityService")
    Check-ServiceStatus("CitrixITSMAdapterProvider")
    Check-ServiceStatus("CitrixWEMAuthSvc")
    Check-ServiceStatus("CitrixWemMsgSvc")
    Check-ServiceStatus("CitrixWorkspaceCloudADProvider")
    Check-ServiceStatus("CitrixWorkspaceCloudAgentDiscovery")
    Check-ServiceStatus("CitrixWorkspaceCloudAgentLogger")
    Check-ServiceStatus("CitrixWorkspaceCloudAgentSystem")
    Check-ServiceStatus("CitrixWorkspaceCloudAgentWatchdog")
    Check-ServiceStatus("CitrixWorkspaceCloudCredentialProvider")
    Check-ServiceStatus("CitrixWorkspaceCloudWebRelayProvider")
    Check-ServiceStatus("RemoteHCLServer")
    Check-ServiceStatus("XaXdCloudProxy")
}


# Gets LHC Information
function LHCStatus {
    Write-Host "`n# LHC Status" -ForegroundColor Yellow
    RegistryOutput -Path "HKLM:\Software\Citrix\Broker\Service\State\LHC" -Name "Enabled" -ExpectedValue 1 -Title "LHC Enabled"
    RegistryOutput -Path "HKLM:\Software\Citrix\Broker\Service\State\LHC" -Name "IsElected" -ExpectedValue 1 -Title "LHC Elected Node"
    RegistryOutput -Path "HKLM:\Software\Citrix\Broker\Service\State\LHC" -Name "OutageModeEntered" -ExpectedValue 0 -Title "LHC In Outage Mode"
}

# Gets Agent information
function agentStatus {
    Write-Host "`n# Agent Status" -ForegroundColor Yellow
    RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\Install\AgentSystem" -Name "ProductVersionBase" -ExpectedValue "6.70.0" -Title "Agent Version"
    RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "Configured" -ExpectedValue 1 -Title "Agent Configured"
    RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "ImmediateUpgrade" -ExpectedValue 0 -Title "Agent Upgrade Pending"
    RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "InMaintenance" -ExpectedValue 0 -Title "Agent in Maintenance"
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
    Get-WinEvent -FilterHashtable @{LogName='Application'; ProviderName='Citrix*'; Level=1,2,3; StartTime=$yesterday} | Format-List
}

# Entry point into this script
function main {
    serviceCheck
    LHCStatus
    agentStatus

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
