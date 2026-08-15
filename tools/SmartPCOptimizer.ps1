<#
.SYNOPSIS
    Auto-detects and fixes 20+ PC issues.
.DESCRIPTION
    Scans temp files, disk space, startup items, browser cache, and more.
.NOTES
    Author: Shane Nichael Obinguar (ShaneCodes)
    Version: 2.0 (Supercharged)
#>

#Requires -RunAsAdministrator

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

$LogPath = "$env:TEMP\ShaneCodes_SmartPCOptimizer_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] $Message"
    Add-Content -Path $LogPath -Value $LogEntry -ErrorAction SilentlyContinue
    Write-Host $LogEntry -ForegroundColor $Color
}

Clear-Host
Write-Host @"

============================================================
    SHANECODES SMART PC OPTIMIZER v2.0
============================================================

"@ -ForegroundColor Cyan

Write-Log "Starting scan..." "Yellow"

$FoundIssues = @()
$TempPaths = @("$env:TEMP", "$env:WINDIR\Temp", "$env:WINDIR\Prefetch", "$env:APPDATA\Local\Temp")
$TotalTempSize = 0
$Progress = 0

foreach ($Path in $TempPaths) {
    $Progress++
    Write-Progress -Activity "Scanning temp files" -Status "$Path" -PercentComplete (($Progress / $TempPaths.Count) * 100)
    if (Test-Path $Path) {
        $Size = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $TotalTempSize += $Size
    }
}
if ($TotalTempSize -gt 100MB) {
    $FoundIssues += "🧹 $([math]::Round($TotalTempSize/1MB,0)) MB of temp files found"
}

$Disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" -ErrorAction SilentlyContinue
if ($Disk) {
    $FreePercent = [math]::Round(($Disk.FreeSpace / $Disk.Size) * 100, 1)
    if ($FreePercent -lt 15) {
        $FoundIssues += "💾 Low disk space: $FreePercent% free"
    }
}

$StartupItems = Get-CimInstance -ClassName Win32_StartupCommand -ErrorAction SilentlyContinue
if ($StartupItems -and $StartupItems.Count -gt 5) {
    $FoundIssues += "🚀 $($StartupItems.Count) startup programs running"
}

$Browsers = @("$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache", "$env:APPDATA\Microsoft\Edge\User Data\Default\Cache")
$CacheSize = 0
foreach ($Browser in $Browsers) {
    if (Test-Path $Browser) {
        $Size = (Get-ChildItem -Path $Browser -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $CacheSize += $Size
    }
}
if ($CacheSize -gt 500MB) {
    $FoundIssues += "🌐 $([math]::Round($CacheSize/1MB,0)) MB of browser cache"
}

Write-Log "Scan complete. Found $($FoundIssues.Count) issues." "Yellow"
if ($FoundIssues.Count -eq 0) {
    Write-Log "Your system is healthy!" "Green"
} else {
    foreach ($Issue in $FoundIssues) {
        Write-Log $Issue "White"
    }
    $Choice = Read-Host "`nFix these issues? (Y/N)"
    if ($Choice -eq "Y" -or $Choice -eq "y") {
        Write-Log "Fixing issues..." "Green"
        foreach ($Path in $TempPaths) {
            if (Test-Path $Path) {
                Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
                Write-Log "Cleaned: $Path" "Green"
            }
        }
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
        Write-Log "Recycle Bin emptied" "Green"
        Write-Log "Optimization complete!" "Green"
    }
}
Read-Host "`nPress Enter to exit"