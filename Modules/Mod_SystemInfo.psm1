function systemInfo {
    $disk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object Size,FreeSpace
    $diskSize = [math]::Round($disk.Size / 1GB)
    $diskFree = [math]::Round($disk.FreeSpace / 1GB)
    $diskPercentFree = [math]::Round(($disk.FreeSpace / $disk.Size) * 100)

    $disk2 = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='E:'" | Select-Object Size,FreeSpace
    $diskSize2 = [math]::Round($disk2.Size / 1GB)
    $diskFree2 = [math]::Round($disk2.FreeSpace / 1GB)
    $diskPercentFree2 = [math]::Round(($disk2.FreeSpace / $disk2.Size) * 100)

    $cpuCores = (Get-WmiObject -Class Win32_Processor).NumberOfCores
    $cpuUsage = Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
    
    $memory = Get-WmiObject -Class Win32_ComputerSystem | Select-Object TotalPhysicalMemory
    $memorySize = [math]::Round($memory.TotalPhysicalMemory / 1GB)
    $memoryUsage = Get-WmiObject -Class Win32_OperatingSystem | Select-Object FreePhysicalMemory,TotalVisibleMemorySize | ForEach-Object {[math]::Round((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory) / $_.TotalVisibleMemorySize) * 100)}
    
    $swap = Get-WmiObject -Class Win32_PageFileUsage | Select-Object AllocatedBaseSize,CurrentUsage
    $swapSize = [math]::Round($swap.AllocatedBaseSize / 1GB)
    $swapUsage = [math]::Round($swap.CurrentUsage / 1GB)

    Write-Host "DISK C:                                            -  $diskFree GB / $diskSize GB ($diskPercentFree%)"
    Write-Host "DISK E:                                            -  $diskFree2 GB / $diskSize2 GB ($diskPercentFree2%)"
    Write-Host "CPU                                                -  $cpuUsage% ($cpuCores cores)"
    Write-Host "MEMORY                                             -  $memoryUsage% ($memorySize GB)"
    Write-Host "SWAP                                               -  $swapUsage GB / $swapSize GB"
}