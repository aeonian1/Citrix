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