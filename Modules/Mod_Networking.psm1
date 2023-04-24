# Tests if the connection to the Destination succeeds
function testNetworkPort {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$DestinationIP,

        [Parameter(Mandatory=$true, Position=1)]
        [ValidateSet("TCP", "UDP")]
        [string]$Protocol,
        
        [Parameter(Mandatory=$true, Position=2)]
        [int]$Port
    )
    
    if ($Protocol -eq "TCP") {
        $socket = New-Object Net.Sockets.TcpClient
    }
    elseif ($Protocol -eq "UDP") {
        $socket = New-Object Net.Sockets.UdpClient
    }
    else {
        throw "Invalid protocol specified."
    }
    
    try {
        $socket.Connect($DestinationIP, $Port)
        Write-Output "Connection to $DestinationIP on port $Port using $Protocol succeeded."
    }
    catch {
        Write-Output "Connection to $DestinationIP on port $Port using $Protocol failed: $_"
    }
    finally {
        $socket.Dispose()
    }
}

# Performs a ping test against the Service Address
function pingCheck {
    Write-Host "`n# Ping Test" -ForegroundColor Yellow
    if (Test-Connection (Get-ItemPropertyValue -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "ServiceAddressFormat")) {
        RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "ServiceAddressFormat" -ExpectedValue "https://service-us.citrixworkspaceapi.net/" -Title "Connection Status"
    } else {
        RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "ServiceAddressFormat" -ExpectedValue "https://service-us.citrixworkspaceapi.net/" -Title "Connection Status"
    }
    if (Test-Connection (Get-ItemPropertyValue -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "ServiceAddressFormat")) {
        RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "ServiceAddressFormatGlobal" -ExpectedValue "https://service.citrixworkspaceapi.net/" -Title "Connection Status Global"
    } else {
        RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "ServiceAddressFormatGlobal" -ExpectedValue "https://service.citrixworkspaceapi.net/" -Title "Connection Status Global"
    }
}