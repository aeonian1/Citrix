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
            # StoreFront
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

            # Cloud Connector
            "cdfCaptureService" { 
                Write-Host "File Location: C:\Program Files\Citrix\CdfCaptureService\CdfCaptureService.exe"
                Write-Host "Description:   Captures CDF traces from all configured components and components"
                Write-Host ""
             }
            "Citrix Cloud Connector Metrics Service" { 
                Write-Host "File Location: C:\Program Files(x86)\Citrix\NetScaler Cloud Gateway\MetricsService.exe"
                Write-Host "Description:   Responsible for collection of metrics from the NetScaler Gateway Service as well as for the generation of Synthetics. This service forwards all the data from the Cloud Connector to the Analytics Service"
                Write-Host ""
            }
            "Citrix NetScaler Cloud Gateway" { 
                Write-Host "File Location: C:\Program Files(x86)\Citrix\NetScaler Cloud Gateway\Citrix.NetScaler.CloudGateway.exe"
                Write-Host "Description:   Provides internet connectivity to on-premise desktops and applications without the need to open in-bound firewall rules or deploying components in the DMZ"
                Write-Host ""
            }
            "CitrixClxMtpService" { 
                Write-Host "File Location: C:\Program Files\Citrix\ClxMtpService\Citrix.ClxMtpService.exe"
                Write-Host "Description:   ClxMtp Service"
                Write-Host ""
            }
            "CitrixConfigSyncService" { 
                Write-Host "File Location: C:\Program Files\Citrix\ConfigSync\ConfigSyncService.exe"
                Write-Host "Description:   Copies brokering configuration locally for high availability mode"
                Write-Host ""
            } 
            "CitrixHighAvailabilityService" { 
                Write-Host "File Location: C:\Program Files\Citrix\Broker\Service\HighAvailabilityService.exe"
                Write-Host "Description:   Provides continuity of service during outage of central site"
                Write-Host ""
            }
            "CitrixITSMAdapterProvider" {
                Write-Host "File Location: C:\Program Files\Citrix\CitrixITSMAdapterProvider\WorkspaceAutomationConnectorPlugin.exe"
                Write-Host "Description:   Automate provisioning and management of Virtual Apps and Desktops"
                Write-Host ""
             }
            "CitrixWEMAuthSvc" {
                Write-Host "File Location: C:\Program Files\Citrix\WemProvider\Connector.Authentication.Host.exe"
                Write-Host "Description:   Provides authentication service for Citrix WEM Agents to connect to cloud infrastructure servers"
                Write-Host ""
             }
            "CitrixWemMsgSvc" {
                Write-Host "File Location: C:\Program Files\Citrix\WemProvider\Connector.Messaging.Host.exe"
                Write-Host "Description:   Provides service for Citrix WEM Cloud service to receive messages from cloud infrastructure servers"
                Write-Host ""
             }
            "CitrixWorkspaceCloudADProvider" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\Agent\Citrix.CloudServices.Agent.exe"
                Write-Host "Description:   Enabled the Citrix Cloud to facilitate management of resources associated with the Active Directory domain accounts it is installed into"
                Write-Host ""
             }
            "CitrixWorkspaceCloudAgentDiscovery" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\Agent Discovery\Citrix.CloudServices.AgentDiscovery.exe"
                Write-Host "Description:   Enables the Cloud to faciliate management of XenApp and XenDesktop (Legacy)"
                Write-Host ""
             }
            "CitrixWorkspaceCloudAgentLogger" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\AgentLogger\Citrix.CloudServices.AgentLogger.exe"
                Write-Host "Description:   Enables the Cloud to faciliate management of XenApp and XenDesktop (Legacy)"
                Write-Host ""
             }
            "CitrixWorkspaceCloudAgentSystem" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\AgentSystem\Citrix.CloudServices.AgentSystem.exe"
                Write-Host "Description:   Handles the system calls necessary for the on-premise agents"
                Write-Host ""
             }
            "CitrixWorkspaceCloudAgentWatchdog" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\AgentWatchDog\Citrix.CloudServices.AgentWatchDog.exe"
                Write-Host "Description:   Monitors and upgrades the on-premise agents"
                Write-Host ""
             }
            "CitrixWorkspaceCloudCredentialProvider" {
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\CredentialProvider\Citrix.CloudServices.CredentialProvider.exe"
                Write-Host "Description:   Citrix Cloud credential provider"
                Write-Host ""
             }
            "CitrixWorkspaceCloudWebRelayProvider" { 
                Write-Host "File Location: C:\Program Files\Citrix\CloudServices\WebRelayAgent\Citrix.CloudServices.WebRelay.Agent.exe"
                Write-Host "Description:   Enables HTTP Requests received from WebRelay Cloud service to be forwarded to on-premises Web Servers"
                Write-Host ""
            }
            "RemoteHCLServer" {
                Write-Host "File Location: C:\Program Files\Citrix\RemoteHCLServer\Service\RemoteHCLServer.exe"
                Write-Host "Description:   Proxies communication between the Delivery Controller and the Hypervisor"
                Write-Host ""
             }
            "XaXdCloudProxy" { 
                Write-Host "File Location: C:\Program Files\Citrix\XaXdCloudProxy\XaXdCloudProxy.exe"
                Write-Host "Description:   Enables communication to a remote Broker service from local VDAs and StoreFront servers"
                Write-Host ""
            }
            Default {
                Write-Host "Something went wrong"
            }
        }
    }
}