function GetFirewallStatus {
    Write-Host "`n--- Windows Firewall Rule Status ---" -ForegroundColor Yellow
    Get-NetFirewallRule -Group "Citrix XenDesktop" | 
    Select-Object DisplayName, PrimaryStatus, Enabled, Direction, Action, 
        @{
            Name='Color';
            Expression={
                if($_.PrimaryStatus -ne 'OK' -or $_.Enabled -ne $true){
                    'Red'
                }
                else{
                    'Green'
                }
            }
        } | 
    Format-Table -AutoSize -Property DisplayName, PrimaryStatus, Enabled, Direction, Action
}