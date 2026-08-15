<#
.SYNOPSIS
    One-click network reset with full logging and diagnostics.
.DESCRIPTION
    Resets Winsock, IP stack, flushes DNS, releases/renews IP, and registers DNS.
    Includes connectivity testing and IP configuration display.
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
$LogPath = "$env:TEMP\ShaneCodes_NetworkRefresh_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] $Message"
    Add-Content -Path $LogPath -Value $LogEntry -ErrorAction SilentlyContinue
    Write-Host $LogEntry -ForegroundColor $Color
}

Write-Log "========================================" "Cyan"
Write-Log "    SHANECODES NETWORK REFRESH v2.0" "Cyan"
Write-Log "========================================" "Cyan"
Write-Log "Log: $LogPath" "Gray"

# --- FUNCTIONS ---
function Invoke-NetworkCommand {
    param([string]$Command, [string]$Description)
    Write-Log "  $Description..." "Gray"
    try {
        Invoke-Expression $Command -ErrorAction Stop
        Write-Log "  [OK] $Description completed" "Green"
        return $true
    }
    catch {
        Write-Log "  [FAIL] $Description failed: $_" "Red"
        return $false
    }
}

function Test-Connectivity {
    Write-Log "Testing connectivity..." "Yellow"
    $Hosts = @("8.8.8.8", "1.1.1.1", "google.com")
    $Connected = 0
    foreach ($Host in $Hosts) {
        if (Test-Connection -ComputerName $Host -Count 1 -Quiet -ErrorAction SilentlyContinue) {
            Write-Log "  [OK] $Host" "Green"
            $Connected++
        } else {
            Write-Log "  [FAIL] $Host" "Red"
        }
    }
    Write-Log "Connectivity: $Connected/$($Hosts.Count) hosts reachable" "Cyan"
}

# --- MAIN MENU ---
do {
    Clear-Host
    Write-Host @"

============================================================
    SHANECODES NETWORK REFRESH v2.0
============================================================

  [1] RUN FULL NETWORK REFRESH (All Steps)
  [2] RESET WINSOCK
  [3] FLUSH DNS CACHE
  [4] RELEASE & RENEW IP
  [5] CHECK NETWORK STATUS
  [6] SHOW IP CONFIGURATION
  [0] EXIT

"@ -ForegroundColor Cyan

    $Choice = Read-Host "  Enter your choice (0-6)"
    
    switch ($Choice) {
        "1" {
            Write-Log "Running FULL NETWORK REFRESH..." "Yellow"
            Invoke-NetworkCommand "netsh winsock reset" "Winsock Reset"
            Invoke-NetworkCommand "netsh int ip reset" "IP Stack Reset"
            Invoke-NetworkCommand "ipconfig /flushdns" "DNS Flush"
            Invoke-NetworkCommand "ipconfig /release" "IP Release"
            Invoke-NetworkCommand "ipconfig /renew" "IP Renew"
            Invoke-NetworkCommand "ipconfig /registerdns" "DNS Register"
            Invoke-NetworkCommand "netsh winhttp reset proxy" "Proxy Reset"
            Write-Log "========================================" "Cyan"
            Write-Log "           NETWORK REFRESH COMPLETE!" "Green"
            Write-Log "========================================" "Cyan"
            Write-Log "  [INFO] It is recommended to restart your PC." "Yellow"
            Read-Host "`nPress Enter to continue"
        }
        "2" { Invoke-NetworkCommand "netsh winsock reset" "Winsock Reset"; Read-Host "`nPress Enter to continue" }
        "3" { Invoke-NetworkCommand "ipconfig /flushdns" "DNS Flush"; Read-Host "`nPress Enter to continue" }
        "4" { Invoke-NetworkCommand "ipconfig /release" "IP Release"; Invoke-NetworkCommand "ipconfig /renew" "IP Renew"; Read-Host "`nPress Enter to continue" }
        "5" { Test-Connectivity; Read-Host "`nPress Enter to continue" }
        "6" { ipconfig /all; Read-Host "`nPress Enter to continue" }
        "0" { Write-Log "Thank you for using ShaneCodes Network Refresh Tool!" "Green"; exit }
        default { Write-Log "Invalid choice!" "Red"; Start-Sleep -Seconds 1 }
    }
} while ($true)