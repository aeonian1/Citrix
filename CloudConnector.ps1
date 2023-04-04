Function Check-ServiceStatus {
    param (
        [Parameter(Mandatory=$true)]
        [String]$ServiceName
    )
    $Service = Get-Service -Name $ServiceName

    if ($Service -ne $null -and $Service.Status -eq 'Running') {
        Write-Host "$Service.DisplayName - $Service.Status" -ForegroundColor Green
    } else {
        Write-Host "$Service.DisplayName - $Service.Status" -ForegroundColor Red
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

