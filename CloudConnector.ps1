###
# This tool is used to gather state information about Citrix Cloud Connectors
#
# Updated    - 2023-04-24
# Updated By - MW 
# Version    - 1
###

# Base
Import-Module ".\Modules\Mod_Firewall.psm1"
Import-Module ".\Modules\Mod_Networking.psm1"
Import-Module ".\Modules\Mod_Registry.psm1"
Import-Module ".\Modules\Mod_Services.psm1"
Import-Module ".\Modules\Mod_StringStdout.psm1"
Import-Module ".\Modules\Mod_SystemInfo.psm1"
Import-Module ".\Modules\Mod_WindowsEvent.psm1"


$global:counter = 0
$global:errorlist = @()


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


# Entry point into this script
function CloudConnectorMain {
    asnp Citrix*

    systemInfo
    serviceCheck
    LHCStatus
    agentStatus
    getFirewallStatus
    checkNetworkRequirements

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