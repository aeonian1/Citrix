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

        switch ($ServiceName) {
            "cdfCaptureService" { 
                Write-Host "File Location: C:\Program Files\Citrix\CdfCaptureService\CdfCaptureService.exe"
                Write-Host "Description: Captures CDF traces from all configured components and components"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix CDF Capture*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
             }
            "Citrix Cloud Connector Metrics Service" { 
                Write-Host "File Location: C:\Program Files(x86)\Citrix\NetScaler Cloud Gateway\MetricsService.exe"
                Write-Host "Description: Responsible for collection of metrics from the NetScaler Gateway Service as well as for the generation of Synthetics. This service forwards all the data from the Cloud Connector to the Analytics Service"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
            }
            "Citrix NetScaler Cloud Gateway" { 
                Write-Host "File Location: C:\Program Files(x86)\Citrix\NetScaler Cloud Gateway\Citrix.NetScaler.CloudGateway.exe"
                Write-Host "Description: Provides internet connectivity to on-premise desktops and applications without the need to open in-bound firewall rules or deploying components in the DMZ"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
            }
            "CitrixClxMtpService" { 
                Write-Host "File Location: C:\Program Files\Citrix\ClxMtpService\Citrix.ClxMtpService.exe"
                Write-Host "Description: ClxMtp Service"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
                
            }
            "CitrixConfigSyncService" { 
                Write-Host "File Location: C:\Program Files\Citrix\ConfigSync\ConfigSyncService.exe"
                Write-Host "Description: Copies brokering configuration locally for high availability mode"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
            } 
            "CitrixHighAvailabilityService" { 
                Write-Host "File Location: C:\Program Files\Citrix\Broker\Service\HighAvailabilityService.exe"
                Write-Host "Description: Provides continuity of service during outage of central site"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
            }
            "CitrixITSMAdapterProvider" {
                Write-Host "File Location: C:\Program Files\Citrix\CitrixITSMAdapterProvider\WorkspaceAutomationConnectorPlugin.exe"
                Write-Host "Description: Automate provisioning and management of Virtual Apps and Desktops"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
             }
            "CitrixWEMAuthSvc" {
                Write-Host "File Location: C:\Program Files\Citrix\WemProvider\Connector.Authentication.Host.exe"
                Write-Host "Description: Provides authentication service for Citrix WEM Agents to connect to cloud infrastructure servers"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
             }
            "CitrixWemMsgSvc" {
                Write-Host "File Location: C:\Program Files\Citrix\WemProvider\Connector.Messaging.Host.exe"
                Write-Host "Description: Provides service for Citrix WEM Cloud service to receive messages from cloud infrastructure servers"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
             }
            "CitrixWorkspaceCloudADProvider" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\Agent\Citrix.CloudServices.Agent.exe"
                Write-Host "Description: Enabled the Citrix Cloud to facilitate management of resources associated with the Active Directory domain accounts it is installed into"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
             }
            "CitrixWorkspaceCloudAgentDiscovery" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\Agent Discovery\Citrix.CloudServices.AgentDiscovery.exe"
                Write-Host "Description: Enables the Cloud to faciliate management of XenApp and XenDesktop (Legacy)"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
             }
            "CitrixWorkspaceCloudAgentLogger" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\AgentLogger\Citrix.CloudServices.AgentLogger.exe"
                Write-Host "Description: Enables the Cloud to faciliate management of XenApp and XenDesktop (Legacy)"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
             }
            "CitrixWorkspaceCloudAgentSystem" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\AgentSystem\Citrix.CloudServices.AgentSystem.exe"
                Write-Host "Description: Handles the system calls necessary for the on-premise agents"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
             }
            "CitrixWorkspaceCloudAgentWatchdog" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\AgentWatchDog\Citrix.CloudServices.AgentWatchDog.exe"
                Write-Host "Description: Monitors and upgrades the on-premise agents"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
             }
            "CitrixWorkspaceCloudCredentialProvider" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\CredentialProvider\Citrix.CloudServices.CredentialProvider.exe"
                Write-Host "Description: Citrix Cloud credential provider"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
             }
            "CitrixWorkspaceCloudWebRelayProvider" { 
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\WebRelayAgent\Citrix.CloudServices.WebRelay.Agent.exe"
                Write-Host "Description: Enables HTTP Requests received from WebRelay Cloud service to be forwarded to on-premises Web Servers"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
            }
            "RemoteHCLServer" {
                Write-Host "File Location: C:\Program Files\Citrix\RemoteHCLServer\Service\RemoteHCLServer.exe"
                Write-Host "Description: Proxies communication between the Delivery Controller and the Hypervisor"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
             }
            "XaXdCloudProxy" { 
                Write-Host "File Location: C:\Program Files\Citrix\XaXdCloudProxy\XaXdCloudProxy.exe"
                Write-Host "Description: Enables communication to a remote Broker service from local VDAs and StoreFront servers"
                Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix WEM*" } | 
                ForEach-Object { 
                    Write-Host "Version      : " $_.DisplayVersion 
                    Write-Host "Install Date : " $_.InstallDate 
                }
            }
            Default {
                Write-Host "Something went wrong"
            }
        }
    }
}

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
    }
}


# Registry values

Write-Host "`n# LHC Status"
RegistryOutput -Path "HKLM:\Software\Citrix\Broker\Service\LHC" -Name "Enabled" -ExpectedValue 1 -Title "LHC Enabled"
RegistryOutput -Path "HKLM:\Software\Citrix\Broker\Service\LHC" -Name "IsElected" -ExpectedValue 1 -Title "LHC Elected Node"
RegistryOutput -Path "HKLM:\Software\Citrix\Broker\Service\LHC" -Name "OutageModeEntered" -ExpectedValue 1 -Title "LHC In Outage Mode"


Write-Host "`n# Agent Status"
RegistryOutput -Path "HKLM:\Software\Citrix\Broker\CloudServices\Install\AgentSystem" -Name "ProductVersionBase" -ExpectedValue "6.70.0" -Title "Agent Version"
RegistryOutput -Path "HKLM:\Software\Citrix\Broker\CloudServices\AgentFoundation" -Name "Configured" -ExpectedValue 1 -Title "Agent Configured"
RegistryOutput -Path "HKLM:\Software\Citrix\Broker\CloudServices\AgentFoundation" -Name "ImmediateUpgrade" -ExpectedValue 0 -Title "Agent Upgrade Pending"
RegistryOutput -Path "HKLM:\Software\Citrix\Broker\CloudServices\AgentFoundation" -Name "InMaintenance" -ExpectedValue 0 -Title "Agent in Maintenance"



Write-Host "`n# Ping Test"
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
