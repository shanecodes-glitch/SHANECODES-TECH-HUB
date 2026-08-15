<#
.SYNOPSIS
    One-click fixes for common Windows problems.
.DESCRIPTION
    Network reset, DNS flush, Windows Update reset, performance boost, and more.
.NOTES
    Author: Shane Nichael Obinguar (ShaneCodes)
    Version: 2.0 (Supercharged)
#>

#Requires -RunAsAdministrator

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

$LogPath = "$env:TEMP\ShaneCodes_QuickFix_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

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
    SHANECODES QUICK FIX WIZARD v2.0
============================================================

  [1] Reset Network Adapters
  [2] Clear DNS Cache
  [3] Fix Windows Update
  [4] Boost System Performance
  [5] Reset Internet Settings
  [6] Fix Broken Shortcuts
  [7] Reset Windows Activation
  [8] Fix Windows Security
  [9] Run All Fixes
  [0] Exit

"@ -ForegroundColor Cyan

$Choice = Read-Host "Enter your choice (0-9)"

function Run-Fix {
    param($Command, $Description)
    Write-Log "Running: $Description..." "Yellow"
    try {
        Invoke-Expression $Command -ErrorAction Stop
        Write-Log "[OK] $Description completed" "Green"
        return $true
    } catch {
        Write-Log "[FAIL] $Description failed: $_" "Red"
        return $false
    }
}

switch ($Choice) {
    "1" { Run-Fix "netsh winsock reset" "Winsock Reset" }
    "2" { Run-Fix "ipconfig /flushdns" "DNS Flush" }
    "3" {
        Run-Fix "Stop-Service -Name wuauserv, bits, cryptSvc -Force" "Stopping Update Services"
        Run-Fix "Remove-Item '$env:WINDIR\SoftwareDistribution.old' -Recurse -Force -ErrorAction SilentlyContinue; Rename-Item '$env:WINDIR\SoftwareDistribution' 'SoftwareDistribution.old'" "Renaming Cache"
        Run-Fix "Start-Service -Name wuauserv, bits, cryptSvc" "Starting Update Services"
    }
    "4" {
        Run-Fix "Remove-Item '$env:TEMP\*' -Recurse -Force -ErrorAction SilentlyContinue" "Cleaning Temp Files"
        Run-Fix "powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" "Enabling High Performance"
    }
    "5" {
        Run-Fix "netsh winhttp reset proxy" "Proxy Reset"
        Run-Fix "rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl,,4" "Resetting IE Settings"
    }
    "6" {
        $Desktop = [Environment]::GetFolderPath("Desktop")
        $Files = Get-ChildItem -Path $Desktop -Filter "*.lnk" -File
        $Fixed = 0
        foreach ($File in $Files) {
            try {
                $Shell = New-Object -ComObject WScript.Shell
                $Shortcut = $Shell.CreateShortcut($File.FullName)
                if (-not (Test-Path $Shortcut.TargetPath)) {
                    Remove-Item -Path $File.FullName -Force
                    $Fixed++
                }
            } catch {}
        }
        Write-Log "Fixed $Fixed broken shortcuts" "Green"
    }
    "7" {
        Run-Fix "cscript //nologo $env:WINDIR\system32\slmgr.vbs /rearm" "SLMGR Rearm"
        Run-Fix "cscript //nologo $env:WINDIR\system32\slmgr.vbs /upk" "SLMGR Uninstall Key"
        Run-Fix "cscript //nologo $env:WINDIR\system32\slmgr.vbs /rilc" "SLMGR Reinstall Licensing"
        Run-Fix "cscript //nologo $env:WINDIR\system32\slmgr.vbs /ato" "SLMGR Activate"
    }
    "8" {
        Run-Fix "Set-MpPreference -DisableRealtimeMonitoring $false" "Enable Defender"
        Run-Fix "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLUA' -Value 1" "Enable UAC"
    }
    "9" {
        Write-Log "Running ALL fixes..." "Yellow"
        Run-Fix "netsh winsock reset" "Winsock Reset"
        Run-Fix "ipconfig /flushdns" "DNS Flush"
        Run-Fix "Stop-Service -Name wuauserv, bits, cryptSvc -Force" "Stopping Update Services"
        Run-Fix "Remove-Item '$env:WINDIR\SoftwareDistribution.old' -Recurse -Force -ErrorAction SilentlyContinue; Rename-Item '$env:WINDIR\SoftwareDistribution' 'SoftwareDistribution.old'" "Renaming Cache"
        Run-Fix "Start-Service -Name wuauserv, bits, cryptSvc" "Starting Update Services"
        Run-Fix "Remove-Item '$env:TEMP\*' -Recurse -Force -ErrorAction SilentlyContinue" "Cleaning Temp Files"
        Run-Fix "netsh winhttp reset proxy" "Proxy Reset"
        Write-Log "All fixes completed!" "Green"
    }
    "0" { Write-Log "Exiting..." "Gray"; exit }
    default { Write-Log "Invalid choice!" "Red" }
}

Read-Host "`nPress Enter to exit"