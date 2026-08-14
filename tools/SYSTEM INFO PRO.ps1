# ============================================================
# SYSTEM INFO PRO v2.0
# ============================================================
# Displays comprehensive system information
# ============================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       SYSTEM INFO PRO v2.0" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Operating System
$OS = Get-CimInstance -ClassName Win32_OperatingSystem
Write-Host "[OS INFORMATION]" -ForegroundColor Yellow
Write-Host "  Name        : $($OS.Caption)"
Write-Host "  Version     : $($OS.Version)"
Write-Host "  Build       : $($OS.BuildNumber)"
Write-Host "  Architecture: $($OS.OSArchitecture)"
Write-Host "  Install Date: $($OS.InstallDate)"
Write-Host "  Last Boot   : $($OS.LastBootUpTime)"
Write-Host ""

# Processor
$CPU = Get-CimInstance -ClassName Win32_Processor
Write-Host "[PROCESSOR]" -ForegroundColor Yellow
Write-Host "  Name        : $($CPU.Name)"
Write-Host "  Cores       : $($CPU.NumberOfCores)"
Write-Host "  Threads     : $($CPU.NumberOfLogicalProcessors)"
Write-Host "  Max Speed   : $($CPU.MaxClockSpeed) MHz"
Write-Host ""

# Memory
$Memory = Get-CimInstance -ClassName Win32_PhysicalMemory
$TotalMemory = ($Memory | Measure-Object -Property Capacity -Sum).Sum / 1GB
$FreeMemory = (Get-CimInstance -ClassName Win32_OperatingSystem).FreePhysicalMemory / 1MB
Write-Host "[MEMORY]" -ForegroundColor Yellow
Write-Host "  Total       : $([math]::Round($TotalMemory, 2)) GB"
Write-Host "  Free        : $([math]::Round($FreeMemory, 2)) GB"
Write-Host "  Used        : $([math]::Round(($TotalMemory * 1024 - $FreeMemory) / 1024, 2)) GB"
Write-Host ""

# Disk
$Disks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"
Write-Host "[DISK DRIVES]" -ForegroundColor Yellow
foreach ($Disk in $Disks) {
    $Free = [math]::Round($Disk.FreeSpace / 1GB, 2)
    $Total = [math]::Round($Disk.Size / 1GB, 2)
    $Used = $Total - $Free
    $Percent = [math]::Round(($Used / $Total) * 100, 1)
    Write-Host "  $($Disk.DeviceID) : $Used GB / $Total GB used ($Percent%)"
}
Write-Host ""

# Network
$Network = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
Write-Host "[NETWORK]" -ForegroundColor Yellow
foreach ($Adapter in $Network) {
    Write-Host "  $($Adapter.Description)"
    Write-Host "    IP Address: $($Adapter.IPAddress -join ', ')"
    Write-Host "    Subnet    : $($Adapter.IPSubnet -join ', ')"
    Write-Host "    MAC       : $($Adapter.MACAddress)"
}
Write-Host ""

# Graphics
$GPU = Get-CimInstance -ClassName Win32_VideoController
Write-Host "[GRAPHICS]" -ForegroundColor Yellow
foreach ($Card in $GPU) {
    if ($Card.Name -notlike "*Remote*" -and $Card.Name -notlike "*Basic*") {
        Write-Host "  $($Card.Name)"
        Write-Host "    VRAM: $([math]::Round($Card.AdapterRAM / 1GB, 2)) GB"
    }
}
Write-Host ""

# Environment
Write-Host "[ENVIRONMENT]" -ForegroundColor Yellow
Write-Host "  Computer Name: $env:COMPUTERNAME"
Write-Host "  User Name    : $env:USERNAME"
Write-Host "  Domain       : $env:USERDOMAIN"
Write-Host "  Windows Dir  : $env:WINDIR"
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "            SCAN COMPLETE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Read-Host "`nPress Enter to exit"