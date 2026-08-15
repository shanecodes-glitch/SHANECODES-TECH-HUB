<#
.SYNOPSIS
    Deep clean with animated progress bar and detailed logging.
.DESCRIPTION
    Cleans temp files, browser cache, prefetch, and Windows update cache.
.NOTES
    Author: Shane Nichael Obinguar (ShaneCodes)
    Version: 2.0 (Supercharged)
#>

#Requires -RunAsAdministrator

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

$LogPath = "$env:TEMP\ShaneCodes_Cleaner_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

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
    SHANECODES CLEANER v2.0
============================================================

"@ -ForegroundColor Cyan

Write-Log "Starting deep clean..." "Yellow"

function Clean-Path {
    param($Path, $Description)
    if (Test-Path $Path) {
        $Before = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
        $After = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $Cleaned = [math]::Round(($Before - $After) / 1MB, 1)
        Write-Log "$Description: $Cleaned MB cleaned" "Green"
        return $Cleaned
    }
    return 0
}

$TotalCleaned = 0

$Paths = @(
    @{Path = "$env:WINDIR\Temp"; Desc = "Windows Temp"},
    @{Path = "$env:TEMP"; Desc = "User Temp"},
    @{Path = "$env:WINDIR\Prefetch"; Desc = "Prefetch"},
    @{Path = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"; Desc = "Chrome Cache"},
    @{Path = "$env:APPDATA\Microsoft\Edge\User Data\Default\Cache"; Desc = "Edge Cache"},
    @{Path = "$env:WINDIR\SoftwareDistribution\Download"; Desc = "Update Cache"}
)

$Progress = 0
foreach ($Item in $Paths) {
    $Progress++
    Write-Progress -Activity "Cleaning $($Item.Desc)" -PercentComplete (($Progress / $Paths.Count) * 100)
    $TotalCleaned += Clean-Path -Path $Item.Path -Description $Item.Desc
}

Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Log "Recycle Bin emptied" "Green"
Write-Log "Total space cleaned: $([math]::Round($TotalCleaned, 1)) MB" "Cyan"

Read-Host "`nPress Enter to exit"