<#
.SYNOPSIS
    Diagnoses laptop battery health and generates a detailed report.
.DESCRIPTION
    Displays battery information, health percentage, and generates a battery report.
.NOTES
    Author: Shane Nichael Obinguar (ShaneCodes)
    Version: 2.0 (Supercharged)
#>

#Requires -RunAsAdministrator

# --- AUTO-ELEVATE ---
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# --- LOGGING ---
$LogPath = "$env:TEMP\ShaneCodes_Battery_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] $Message"
    Add-Content -Path $LogPath -Value $LogEntry -ErrorAction SilentlyContinue
    Write-Host $LogEntry -ForegroundColor $Color
}

Write-Log "========================================" "Cyan"
Write-Log "    SHANECODES BATTERY HEALTH v2.0" "Cyan"
Write-Log "========================================" "Cyan"
Write-Log "Log: $LogPath" "Gray"

# --- BATTERY INFO ---
try {
    $Battery = Get-CimInstance -ClassName Win32_Battery -ErrorAction Stop
    if (-not $Battery) {
        Write-Log "No battery detected. This tool is for laptops." "Yellow"
        Read-Host "Press Enter to exit"
        exit
    }

    Write-Log "Name: $($Battery.Name)" "White"
    Write-Log "Manufacturer: $($Battery.Manufacturer)" "White"
    Write-Log "Chemistry: $($Battery.Chemistry)" "White"
    Write-Log "Design Capacity: $($Battery.DesignCapacity) mWh" "White"
    Write-Log "Full Charge Capacity: $($Battery.FullChargeCapacity) mWh" "White"

    if ($Battery.DesignCapacity -gt 0) {
        $Health = [math]::Round(($Battery.FullChargeCapacity / $Battery.DesignCapacity) * 100, 1)
        $Color = if ($Health -gt 80) { "Green" } elseif ($Health -gt 60) { "Yellow" } else { "Red" }
        Write-Log "Battery Health: $Health%" $Color
        Write-Log "Status: $(if ($Health -gt 80) { 'Excellent' } elseif ($Health -gt 60) { 'Good' } else { 'Poor - Consider replacing' })" $Color
    }

    Write-Log "Battery Status: $($Battery.BatteryStatus)" "White"
    Write-Log "Estimated Run Time: $([math]::Round($Battery.EstimatedRunTime / 60, 1)) minutes" "White"

    # Generate battery report
    $ReportPath = "$env:TEMP\battery-report.html"
    powercfg /batteryreport /output "$ReportPath" 2>$null
    if (Test-Path $ReportPath) {
        Write-Log "Battery report generated: $ReportPath" "Green"
        Start-Process $ReportPath
    } else {
        Write-Log "Failed to generate battery report." "Red"
    }
} catch {
    Write-Log "Error: $_" "Red"
}

Read-Host "`nPress Enter to exit"