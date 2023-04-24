###
# This tool is used to gather state information about Citrix StoreFront
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

# StoreFront Specific
Import-Module ".\Modules\Mod_IIS.psm1"
Import-Module ".\Modules\Mod_StoreFront.psm1"

$global:counter = 0
$global:errorlist = @()


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





# Entry point into this script
function StoreFrontMain {
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
