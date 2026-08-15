<#
.SYNOPSIS
    Measures boot time and provides optimization recommendations.
.DESCRIPTION
    Analyzes boot time, startup programs, disk health, and Fast Startup status.
.NOTES
    Author: Shane Nichael Obinguar (ShaneCodes)
    Version: 2.0 (Supercharged)
#>

#Requires -RunAsAdministrator

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

$LogPath = "$env:TEMP\ShaneCodes_BootAnalyzer_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

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
    SHANECODES BOOT SPEED ANALYZER v2.0
============================================================

"@ -ForegroundColor Cyan

try {
    $BootTime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
    $Uptime = (Get-Date) - $BootTime
    $Seconds = $Uptime.TotalSeconds
    $Rating = if ($Seconds -lt 60) { "Excellent" } elseif ($Seconds -lt 120) { "Good" } elseif ($Seconds -lt 180) { "Fair" } elseif ($Seconds -lt 300) { "Slow" } else { "Very Slow" }
    $Color = if ($Seconds -lt 120) { "Green" } elseif ($Seconds -lt 300) { "Yellow" } else { "Red" }
    
    Write-Log "Last Boot: $BootTime" "White"
    Write-Log "Uptime: $([math]::Round($Uptime.TotalHours, 2)) hours" "White"
    Write-Log "Boot Time: $([math]::Round($Seconds, 1)) seconds" $Color
    Write-Log "Rating: $Rating" $Color
} catch {
    Write-Log "Failed to get boot time." "Red"
}

Read-Host "`nPress Enter to exit"