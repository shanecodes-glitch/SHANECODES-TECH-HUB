# ============================================================
# REGISTRY CLEANER v2.0
# ============================================================
# Cleans invalid registry entries
# ============================================================

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: Administrator privileges required!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       REGISTRY CLEANER v2.0" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[WARNING] Registry cleaning can be risky!" -ForegroundColor Red
Write-Host "It is recommended to create a restore point first." -ForegroundColor Yellow
Write-Host ""

$Choice = Read-Host "Create restore point? (Y/N)"
if ($Choice -eq "Y" -or $Choice -eq "y") {
    try {
        Checkpoint-Computer -Description "Registry Cleaner - ShaneCodes" -RestorePointType MODIFY_SETTINGS
        Write-Host "Restore point created successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Failed to create restore point." -ForegroundColor Red
    }
}

Write-Host "`nScanning for invalid registry entries..." -ForegroundColor Yellow
$Count = 0

# Check invalid file references
$Keys = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
)

$Found = @()
foreach ($Key in $Keys) {
    if (Test-Path $Key) {
        $Items = Get-ItemProperty -Path $Key -ErrorAction SilentlyContinue
        foreach ($Property in $Items.PSObject.Properties) {
            if ($Property.Name -notin @("PSPath", "PSParentPath", "PSChildName", "PSDrive", "PSProvider")) {
                $Value = $Property.Value
                if ($Value -and $Value -is [string] -and $Value -match "\.exe|\.dll|\.com|\.bat") {
                    $PathPart = $Value -split '"' | Where-Object { $_ -match "\.exe|\.dll|\.com|\.bat" }
                    if ($PathPart) {
                        $FilePath = $PathPart[0]
                        if (-not (Test-Path $FilePath)) {
                            $Found += [PSCustomObject]@{
                                Key = $Key
                                Name = $Property.Name
                                Value = $Value
                            }
                            $Count++
                            Write-Host "  Found: $($Property.Name) -> $FilePath (invalid)" -ForegroundColor Yellow
                        }
                    }
                }
            }
        }
    }
}

Write-Host ""
if ($Count -eq 0) {
    Write-Host "No invalid registry entries found!" -ForegroundColor Green
} else {
    Write-Host "Found $Count invalid entries." -ForegroundColor Yellow
    $Confirm = Read-Host "Remove invalid entries? (Y/N)"
    if ($Confirm -eq "Y" -or $Confirm -eq "y") {
        foreach ($Entry in $Found) {
            try {
                Remove-ItemProperty -Path $Entry.Key -Name $Entry.Name -Force -ErrorAction SilentlyContinue
                Write-Host "  Removed: $($Entry.Name)" -ForegroundColor Green
            } catch {
                Write-Host "  Failed: $($Entry.Name)" -ForegroundColor Red
            }
        }
        Write-Host "`nCleaning completed!" -ForegroundColor Green
    } else {
        Write-Host "Cleaning cancelled." -ForegroundColor Gray
    }
}

Read-Host "`nPress Enter to exit"
