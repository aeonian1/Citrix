$faults = @()
$masterList = @{
    "version" = "11.17.2.0 build 42000"
}

# Write the title for each section
function getTitle {
    param(
        [Parameter(Mandatory=$true)] [string] $title
    )

    Write-Host "`n--- $title ---"
}

# Report the number of faults detected
function getFaults {
    param(
        [Parameter(Mandatory=$false)] [ref] $faults
    )

    if ($faults.Count -eq 0) {
        Write-Host "No issues detected"
    } else {
        foreach ($fault in $faults.Value) {
            Write-Host $fault
        }
    }
}

# Compare 2 values from the masterList hash array
function compareValues {
    param(
        [Parameter(Mandatory=$true)] [string] $str1,
        [Parameter(Mandatory=$true)] [string] $str2,
        [Parameter(Mandatory=$false)] [ref] $faults
    )

    if ($str1 -eq $str2) {
        Write-Host "Version".PadRight(50) $str1 -ForegroundColor Green
    } else {
        Write-Host "$str1 - The correct value is $str2" -ForegroundColor Red
        $faults.Value += "$str1 - The correct value is $str2"
    }
}

# Check if the services are running
function checkService {
    param(
        [Parameter(Mandatory=$true)] [string] $service,
        [Parameter(Mandatory=$false)] [ref] $faults
    )

    if ((Get-Service -Name $service).Status -eq "Running") {
        Write-Host "$service".PadRight(50) "Running" -ForegroundColor Green
    } else {
        Write-Host "$service".PadRight(50) "Not Running" -ForegroundColor Red
        $faults.Value += "$service is not running"
    }
}

# Check if the default firewall rules are enabled
function checkFirewallRule {
    param(
        [Parameter(Mandatory=$true)] [string] $fwrule,
        [Parameter(Mandatory=$false)] [ref] $faults
    )

    if ((Get-NetFirewallRule -DisplayName $fwrule).Enabled -eq "True") {
        Write-Host "$fwrule".PadRight(50) "Enabled" -ForegroundColor Green
    } else {
        Write-Host "$fwrule".PadRight(50) "Not Enabled" -ForegroundColor Red
        $faults.Value += "$fwrule is not enabled"
    }
}

# Check if the services are listening on their ports
function checkPortOpen {
    param(
        [Parameter(Mandatory=$true)] [string] $port,
        [Parameter(Mandatory=$false)] [ref] $faults
    )

    if ((Test-NetConnection 127.0.0.1 -Port $port).TcpTestSucceeded -eq "True") {
        Write-Host "$port".PadRight(50) "Open" -ForegroundColor Green
    } else {
        Write-Host "$port".PadRight(50) "Not Open" -ForegroundColor Red
        $faults.Value += "$port is not open"
    }
}

# Gets the host ID
function getHostID {
    $output = & "C:\Program Files (x86)\Citrix\Licensing\ls\lmhostid.exe"
    if ($output -match '"(.*)"') {
        $hostid = $Matches[0]
        $hostid = $hostid.Replace('"', '')
        Write-Host "Host ID".PadRight(50) $hostid
    }
}

##
##

getTitle -title "License Server Info"
compareValues -str1 (Get-ItemProperty -Path "HKLM:\Software\WOW6432Node\Citrix\LicenseServer\Install" -Name Version).Version -str2 $masterList["version"] -faults ([ref]$faults)
getHostID

getTitle -title "Service Status" 
checkService -service "CtxLSPortSVC" -faults ([ref]$faults)
checkService -service "Citrix Licensing" -faults ([ref]$faults)
checkService -service "Citrix_GTLicensingProv" -faults ([ref]$faults)
checkService -service "CitrixWebServicesForLicensing" -faults ([ref]$faults)

getTitle -title "Firewall Status"
checkFirewallRule -fwrule "Citrix Web Services for Licensing" -faults ([ref]$faults)
checkFirewallRule -fwrule "Citrix Licensing" -faults ([ref]$faults)
checkFirewallRule -fwrule "Citrix Licensing Vendor Daemon" -faults ([ref]$faults)

getTitle -title "Port Status"
checkPortOpen -port 27000
checkPortOpen -port 8081
checkPortOpen -port 8083

getTitle -title "Issues Detected"
getFaults -faults ([ref]$faults)