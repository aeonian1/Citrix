# Checks the expected value for a registry property against the existing
function RegistryOutput {
    param (
        [Parameter(Mandatory=$true)]
        [String]$Path,
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [String]$ExpectedValue,
        [Parameter(Mandatory=$true)]
        [String]$Title
    )

    $LeftSpaced = '{0, -50}' -f $Title + " - "

    if ((Get-ItemPropertyValue -Path $Path -Name $Name) -eq $ExpectedValue) {
        Write-Host $LeftSpaced (Get-ItemPropertyValue -Path $Path -Name $Name) -ForegroundColor Green
    } else {
        Write-Host $LeftSpaced (Get-ItemPropertyValue -Path $Path -Name $Name) - "Expected Value = " $ExpectedValue -ForegroundColor Red

        $global:errorlist += $LeftSpaced + (Get-ItemPropertyValue -Path $Path -Name $Name) - "Expected Value = " + $ExpectedValue
        $global:counter++
    }
}

# Gets LHC Information
function LHCStatus {
    Write-Host "`n# LHC Status" -ForegroundColor Yellow
    RegistryOutput -Path "HKLM:\Software\Citrix\Broker\Service\State\LHC" -Name "Enabled" -ExpectedValue 1 -Title "LHC Enabled"
    RegistryOutput -Path "HKLM:\Software\Citrix\Broker\Service\State\LHC" -Name "IsElected" -ExpectedValue 1 -Title "LHC Elected Node"
    RegistryOutput -Path "HKLM:\Software\Citrix\Broker\Service\State\LHC" -Name "OutageModeEntered" -ExpectedValue 0 -Title "LHC In Outage Mode"
}

# Gets Agent information
function agentStatus {
    Write-Host "`n# Agent Status" -ForegroundColor Yellow
    RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\Install\AgentSystem" -Name "ProductVersionBase" -ExpectedValue "6.70.0" -Title "Agent Version"
    RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "Configured" -ExpectedValue 1 -Title "Agent Configured"
    RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "ImmediateUpgrade" -ExpectedValue 0 -Title "Agent Upgrade Pending"
    RegistryOutput -Path "HKLM:\Software\Citrix\CloudServices\AgentFoundation" -Name "InMaintenance" -ExpectedValue 0 -Title "Agent in Maintenance"
}

# Gets Config Replication Information
function configReplicationStatus {
    Write-Host "`n# Config Replication Status" -ForegroundColor Yellow
    RegistryOutput -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastSourceServer" -ExpectedValue (Get-ItemPropertyValue -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastSourceServer") -Title "Last Source Server"
    RegistryOutput -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastStartTime" -ExpectedValue (Get-ItemPropertyValue -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastStartTime") -Title "Last Start Time Config Replication"
    RegistryOutput -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastEndTime" -ExpectedValue (Get-ItemPropertyValue -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastEndTime") -Title "Last End Time Config Replication"
    RegistryOutput -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastUpdateStatus" -ExpectedValue "Complete" -Title "Last Update Status"
    # RegistryOutput -Path "HKLM:\Software\Citrix\DeliveryServices\ConfigurationReplication\" -Name "LastErrorMessage" -ExpectedValue " " -Title "Last Error Message" -WarningAction Ignore
}