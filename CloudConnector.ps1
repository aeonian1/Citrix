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

        #!TODO - add description, file location 
        switch ($ServiceName) {
            "cdfCaptureService" {  }
            "Citrix Cloud Connector Metrics Service" { }
            "Citrix NetScaler Cloud Gateway" { }
            "CitrixClxMtpService" { }
            "CitrixConfigSyncService" { } 
            "CitrixHighAvailabilityService" { }
            "CitrixITSMAdapterProvider" { }
            "CitrixWEMAuthSvc" { }
            "CitrixWemMsgSvc" { }
            "CitrixWorkspaceCloudADProvider" { }
            "CitrixWorkspaceCloudAgentDiscovery" { }
            "CitrixWorkspaceCloudAgentLogger" { }
            "CitrixWorkspaceCloudAgentSystem" { }
            "CitrixWorkspaceCloudAgentWatchdog" { }
            "CitrixWorkspaceCloudCredentialProvider" { }
            "CitrixWorkspaceCloudWebRelayProvider" { }
            "RemoteHCLServer" { }
            "XaXdCloudProxy" { }
            Default {}
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

