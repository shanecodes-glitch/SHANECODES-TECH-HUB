<#
.SYNOPSIS
    Securely shreds files/folders with military-grade overwrite (7 passes).
.DESCRIPTION
    Overwrites file contents with random data 7 times before deletion.
    Includes free space wiping and recursive folder shredding.
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

# --- LOGGING SETUP ---
$LogPath = "$env:TEMP\ShaneCodes_Shredder_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$ProgressPreference = 'Continue'

function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] $Message"
    Add-Content -Path $LogPath -Value $LogEntry -ErrorAction SilentlyContinue
    Write-Host $LogEntry -ForegroundColor $Color
}

Write-Log "========================================" "Cyan"
Write-Log "    SHANECODES FILE SHREDDER v2.0" "Cyan"
Write-Log "========================================" "Cyan"
Write-Log "Log: $LogPath" "Gray"

# --- SHRED FUNCTION ---
function Shred-File {
    param(
        [Parameter(Mandatory)]
        [string]$FilePath,
        [int]$Passes = 7
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Log "File not found: $FilePath" "Red"
        return $false
    }

    try {
        $File = Get-Item -Path $FilePath
        $Length = $File.Length
        $Buffer = New-Object byte[] 4096
        $Random = New-Object System.Random

        Write-Log "Shredding: $($File.Name) ($([math]::Round($Length/1KB,2)) KB)" "Gray"

        for ($i = 1; $i -le $Passes; $i++) {
            Write-Progress -Activity "Shredding $($File.Name)" -Status "Pass $i of $Passes" -PercentComplete (($i / $Passes) * 100)
            
            $Stream = [System.IO.File]::OpenWrite($FilePath)
            $Position = 0
            while ($Position -lt $Length) {
                $Random.NextBytes($Buffer)
                $WriteSize = [Math]::Min($Buffer.Length, $Length - $Position)
                $Stream.Write($Buffer, 0, $WriteSize)
                $Position += $WriteSize
            }
            $Stream.Close()
            Write-Log "  Pass $i/$Passes complete" "Green"
        }

        Remove-Item -Path $FilePath -Force
        Write-Log "[OK] Permanently deleted: $($File.Name)" "Green"
        return $true
    }
    catch {
        Write-Log "FAILED: $FilePath - $_" "Red"
        return $false
    }
}

# --- MAIN MENU ---
do {
    Clear-Host
    Write-Host @"

============================================================
    SHANECODES FILE SHREDDER v2.0
============================================================

  ⚠️  WARNING: This tool PERMANENTLY deletes files!
  NO RECOVERY IS POSSIBLE!

  [1] SHRED FILE
  [2] SHRED FOLDER
  [3] SHRED FREE SPACE (Wipe entire drive free space)
  [0] EXIT

"@ -ForegroundColor Cyan

    $Choice = Read-Host "  Enter your choice (0-3)"
    
    switch ($Choice) {
        "1" {
            $FilePath = Read-Host "`n  Enter full file path"
            if (Shred-File -FilePath $FilePath) {
                Write-Log "File shredding completed successfully." "Green"
            }
            Read-Host "`nPress Enter to continue"
        }
        "2" {
            $FolderPath = Read-Host "`n  Enter full folder path"
            if (Test-Path -Path $FolderPath -PathType Container) {
                $Files = Get-ChildItem -Path $FolderPath -Recurse -File
                $Total = $Files.Count
                Write-Log "Found $Total file(s) in folder." "Gray"
                $Count = 0
                foreach ($File in $Files) {
                    $Count++
                    Write-Progress -Activity "Shredding folder: $FolderPath" -Status "$Count of $Total" -PercentComplete (($Count / $Total) * 100)
                    if (Shred-File -FilePath $File.FullName) { $Count++ }
                }
                Remove-Item -Path $FolderPath -Force -ErrorAction SilentlyContinue
                Write-Log "[OK] Folder shredded: $FolderPath" "Green"
            } else {
                Write-Log "Folder not found: $FolderPath" "Red"
            }
            Read-Host "`nPress Enter to continue"
        }
        "3" {
            Write-Log "Wiping free space on C:..." "Yellow"
            $Drive = Get-PSDrive -Name C
            $FreeSpace = $Drive.Free
            if ($FreeSpace -gt 0) {
                $TempFile = "$env:TEMP\shred_temp.dat"
                $Stream = [System.IO.File]::OpenWrite($TempFile)
                $Buffer = New-Object byte[] 65536
                $Random = New-Object System.Random
                $Written = 0
                while ($Written -lt $FreeSpace) {
                    $Random.NextBytes($Buffer)
                    $Stream.Write($Buffer, 0, $Buffer.Length)
                    $Written += $Buffer.Length
                    Write-Progress -Activity "Wiping free space" -Status "$([math]::Round($Written/1GB,2)) GB" -PercentComplete (($Written / $FreeSpace) * 100)
                }
                $Stream.Close()
                Remove-Item -Path $TempFile -Force
                Write-Log "[OK] Free space wiped." "Green"
            } else {
                Write-Log "No free space to wipe." "Yellow"
            }
            Read-Host "`nPress Enter to continue"
        }
        "0" {
            Write-Log "Thank you for using ShaneCodes File Shredder!" "Green"
            exit
        }
        default {
            Write-Log "Invalid choice!" "Red"
            Start-Sleep -Seconds 1
        }
    }
} while ($true)