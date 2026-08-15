<#
.SYNOPSIS
    Create, manage, and restore system restore points.
.DESCRIPTION
    Includes restore point creation, listing, and system restoration.
.NOTES
    Author: Shane Nichael Obinguar (ShaneCodes)
    Version: 2.0 (Supercharged)
#>

#Requires -RunAsAdministrator

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

$LogPath = "$env:TEMP\ShaneCodes_Restore_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

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
    SHANECODES SYSTEM RESTORE MANAGER v2.0
============================================================

  [1] CREATE RESTORE POINT
  [2] LIST RESTORE POINTS
  [3] RESTORE SYSTEM
  [4] SYSTEM RESTORE STATUS
  [0] EXIT

"@ -ForegroundColor Cyan

$Choice = Read-Host "Enter your choice (0-4)"

switch ($Choice) {
    "1" {
        $Desc = Read-Host "Enter description"
        try {
            Checkpoint-Computer -Description $Desc -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
            Write-Log "Restore point created successfully!" "Green"
        } catch {
            Write-Log "Failed: $_" "Red"
        }
    }
    "2" {
        try {
            $Points = Get-ComputerRestorePoint
            if ($Points) {
                $Points | Format-Table SequenceNumber, CreationTime, Description -AutoSize
            } else {
                Write-Log "No restore points found." "Yellow"
            }
        } catch {
            Write-Log "Failed: $_" "Red"
        }
    }
    "3" {
        try {
            $Points = Get-ComputerRestorePoint
            if ($Points) {
                $Points | Format-Table SequenceNumber, CreationTime, Description -AutoSize
                $Seq = Read-Host "Enter Sequence Number"
                Restore-Computer -RestorePoint $Seq -Force
                Write-Log "Restore initiated. System will restart." "Green"
            } else {
                Write-Log "No restore points available." "Yellow"
            }
        } catch {
            Write-Log "Failed: $_" "Red"
        }
    }
    "4" {
        try {
            $Protection = Get-WmiObject -Class Win32_SystemRestore -ErrorAction SilentlyContinue
            if ($Protection) {
                Write-Log "System Restore is available" "Green"
            } else {
                Write-Log "System Restore is not available" "Red"
            }
        } catch {
            Write-Log "Failed to check restore status." "Red"
        }
    }
    "0" { Write-Log "Exiting..." "Gray"; exit }
    default { Write-Log "Invalid choice!" "Red" }
}

Read-Host "`nPress Enter to exit"