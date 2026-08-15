<#
.SYNOPSIS
    Clears browsing history, cookies, and temp files to protect privacy.
.DESCRIPTION
    Cleans Chrome, Edge, Firefox caches and history, temp files, and DNS cache.
.NOTES
    Author: Shane Nichael Obinguar (ShaneCodes)
    Version: 2.0 (Supercharged)
#>

#Requires -RunAsAdministrator

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

$LogPath = "$env:TEMP\ShaneCodes_Privacy_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

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
    SHANECODES PRIVACY GUARD v2.0
============================================================

"@ -ForegroundColor Cyan

Write-Log "Starting privacy cleanup..." "Yellow"

$Browsers = @(
    @{Name="Chrome"; Path="$env:LOCALAPPDATA\Google\Chrome\User Data\Default"},
    @{Name="Edge"; Path="$env:APPDATA\Microsoft\Edge\User Data\Default"},
    @{Name="Firefox"; Path="$env:APPDATA\Mozilla\Firefox\Profiles"}
)

$TotalCleaned = 0

foreach ($Browser in $Browsers) {
    if (Test-Path $Browser.Path) {
        Write-Log "Cleaning $($Browser.Name)..." "Gray"
        $Dirs = @("Cache", "Code Cache", "Cookies", "History", "Service Worker")
        foreach ($Dir in $Dirs) {
            $DirPath = Join-Path $Browser.Path $Dir
            if (Test-Path $DirPath) {
                $Size = (Get-ChildItem -Path $DirPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                Remove-Item -Path "$DirPath\*" -Recurse -Force -ErrorAction SilentlyContinue
                $Cleaned = [math]::Round($Size / 1MB, 1)
                if ($Cleaned -gt 0) {
                    Write-Log "$Dir: $Cleaned MB cleaned" "Green"
                    $TotalCleaned += $Cleaned
                }
            }
        }
    }
}

# Temp files
$TempPaths = @("$env:TEMP", "$env:WINDIR\Temp")
foreach ($Path in $TempPaths) {
    if (Test-Path $Path) {
        $Size = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
        $Cleaned = [math]::Round($Size / 1MB, 1)
        if ($Cleaned -gt 0) {
            Write-Log "Temp: $Cleaned MB cleaned" "Green"
            $TotalCleaned += $Cleaned
        }
    }
}

# DNS Cache
ipconfig /flushdns | Out-Null
Write-Log "DNS cache flushed" "Green"

Write-Log "Total cleaned: $([math]::Round($TotalCleaned, 1)) MB" "Cyan"

Read-Host "`nPress Enter to exit"