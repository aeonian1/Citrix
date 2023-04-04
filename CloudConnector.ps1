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

Get-Service -DisplayName "Citrix*" | Select-Object -Property DisplayName, Status, Name
