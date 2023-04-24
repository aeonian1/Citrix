# Retrieves the Application events from -1 day
function getEvents {
    $yesterday = (Get-Date) - (New-TimeSpan -Days 1)
    Write-Host "`n--- Citrix Application Events - FATAL / ERROR / WARNING ---" -ForegroundColor Yellow
    try { 
        $event = Get-WinEvent -FilterHashtable @{LogName='Application'; ProviderName='Citrix*'; Level=1,2,3; StartTime=$yesterday} -ErrorAction Ignore  
        if ($event -eq $null) {
            Write-Host "No Events Found"
        } else {
            Write-Host $event | Format-List
        }
    } catch { Write-Host "No Events Found" }
}