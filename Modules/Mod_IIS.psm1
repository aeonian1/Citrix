
function iisInfo {
    # Get IIS status
    $iisStatus = Get-Service W3SVC | Select-Object -ExpandProperty Status

    # Get IIS version
    $iisVersion = (Get-WebConfigurationProperty -filter /system.webServer/serverRuntime -name "version").Value

    # Get IIS application pool information
    $appPools = Get-ChildItem IIS:\AppPools | Select-Object Name, State, ManagedRuntimeVersion

    # Format output
    $output = @{
        "IIS Status" = $iisStatus
        "IIS Version" = $iisVersion
        "Application Pools" = $appPools
    }

    $output.GetEnumerator() | ForEach-Object {
        $var = $_.Key
        $value = $_.Value
        "$var".PadRight(50) + " -   $value"
    }
}