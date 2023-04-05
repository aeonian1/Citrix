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
             }
            "Citrix Cloud Connector Metrics Service" { 
                Write-Host "File Location: C:\Program Files(x86)\Citrix\NetScaler Cloud Gateway\MetricsService.exe"
                Write-Host "Description: Responsible for collection of metrics from the NetScaler Gateway Service as well as for the generation of Synthetics. This service forwards all the data from the Cloud Connector to the Analytics Service"
            }
            "Citrix NetScaler Cloud Gateway" { 
                Write-Host "File Location: C:\Program Files(x86)\Citrix\NetScaler Cloud Gateway\Citrix.NetScaler.CloudGateway.exe"
                Write-Host "Description: Provides internet connectivity to on-premise desktops and applications without the need to open in-bound firewall rules or deploying components in the DMZ"
            }
            "CitrixClxMtpService" { 
                Write-Host "File Location: C:\Program Files\Citrix\ClxMtpService\Citrix.ClxMtpService.exe"
                Write-Host "Description: ClxMtp Service"
            }
            "CitrixConfigSyncService" { 
                Write-Host "File Location: C:\Program Files\Citrix\ConfigSync\ConfigSyncService.exe"
                Write-Host "Description: Copies brokering configuration locally for high availability mode"
            } 
            "CitrixHighAvailabilityService" { 
                Write-Host "File Location: C:\Program Files\Citrix\Broker\Service\HighAvailabilityService.exe"
                Write-Host "Description: Provides continuity of service during outage of central site"
            }
            "CitrixITSMAdapterProvider" {
                Write-Host "File Location: C:\Program Files\Citrix\CitrixITSMAdapterProvider\WorkspaceAutomationConnectorPlugin.exe"
                Write-Host "Description: Automate provisioning and management of Virtual Apps and Desktops"
             }
            "CitrixWEMAuthSvc" {
                Write-Host "File Location: C:\Program Files\Citrix\WemProvider\Connector.Authentication.Host.exe"
                Write-Host "Description: Provides authentication service for Citrix WEM Agents to connect to cloud infrastructure servers"
             }
            "CitrixWemMsgSvc" {
                Write-Host "File Location: C:\Program Files\Citrix\WemProvider\Connector.Messaging.Host.exe"
                Write-Host "Description: Provides service for Citrix WEM Cloud service to receive messages from cloud infrastructure servers"
             }
            "CitrixWorkspaceCloudADProvider" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\Agent\Citrix.CloudServices.Agent.exe"
                Write-Host "Description: Enabled the Citrix Cloud to facilitate management of resources associated with the Active Directory domain accounts it is installed into"
             }
            "CitrixWorkspaceCloudAgentDiscovery" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\Agent Discovery\Citrix.CloudServices.AgentDiscovery.exe"
                Write-Host "Description: Enables the Cloud to faciliate management of XenApp and XenDesktop (Legacy)"
             }
            "CitrixWorkspaceCloudAgentLogger" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\AgentLogger\Citrix.CloudServices.AgentLogger.exe"
                Write-Host "Description: Enables the Cloud to faciliate management of XenApp and XenDesktop (Legacy)"
             }
            "CitrixWorkspaceCloudAgentSystem" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\AgentSystem\Citrix.CloudServices.AgentSystem.exe"
                Write-Host "Description: Handles the system calls necessary for the on-premise agents"
             }
            "CitrixWorkspaceCloudAgentWatchdog" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\AgentWatchDog\Citrix.CloudServices.AgentWatchDog.exe"
                Write-Host "Description: Monitors and upgrades the on-premise agents"
             }
            "CitrixWorkspaceCloudCredentialProvider" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\CredentialProvider\Citrix.CloudServices.CredentialProvider.exe"
                Write-Host "Description: Citrix Cloud credential provider"
             }
            "CitrixWorkspaceCloudWebRelayProvider" { 
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\WebRelayAgent\Citrix.CloudServices.WebRelay.Agent.exe"
                Write-Host "Description: Enables HTTP Requests received from WebRelay Cloud service to be forwarded to on-premises Web Servers"
            }
            "RemoteHCLServer" {
                Write-Host "File Location: C:\Program Files\Citrix\RemoteHCLServer\Service\RemoteHCLServer.exe"
                Write-Host "Description: Proxies communication between the Delivery Controller and the Hypervisor"
             }
            "XaXdCloudProxy" { 
                Write-Host "File Location: C:\Program Files\Citrix\XaXdCloudProxy\XaXdCloudProxy.exe"
                Write-Host "Description: Enables communication to a remote Broker service from local VDAs and StoreFront servers"
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


Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like "Citrix*" } | ForEach-Object {
    Write-Host $_.DisplayName
    Write-Host $_.DisplayVersion
    Write-Host $_.InstallSource
}
