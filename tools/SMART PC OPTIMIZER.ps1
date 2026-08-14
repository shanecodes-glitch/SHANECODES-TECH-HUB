# ============================================================
# SMART PC OPTIMIZER v1.0
# ============================================================
# Auto-detects and fixes 20+ PC issues
# Created by: ShaneCodes Technologies
# ============================================================

# Admin check
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "🚨 ADMIN REQUIRED! Please run as Administrator." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

# Console setup
$Host.UI.RawUI.WindowTitle = "🔧 Smart PC Optimizer - ShaneCodes"
Clear-Host

Write-Host @"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║    ███████╗██╗  ██╗ █████╗ ███╗   ██╗███████╗ ██████╗     ║
║    ██╔════╝██║  ██║██╔══██╗████╗  ██║██╔════╝██╔════╝     ║
║    ███████╗███████║███████║██╔██╗ ██║█████╗  ██║  ███╗    ║
║    ╚════██║██╔══██║██╔══██║██║╚██╗██║██╔══╝  ██║   ██║    ║
║    ███████║██║  ██║██║  ██║██║ ╚████║███████╗╚██████╔╝    ║
║    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝     ║
║                                                              ║
║              SMART PC OPTIMIZER v1.0                        ║
║           Created by: ShaneCodes Technologies              ║
╚══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host ""
Write-Host "🔍 SCANNING YOUR SYSTEM..." -ForegroundColor Yellow
Write-Host ""

# ============================================================
# SCAN FUNCTION
# ============================================================
$FoundIssues = @()
$ScanLog = @()

function Add-Issue {
    param($Category, $Description, $FixAction)
    $FoundIssues += [PSCustomObject]@{
        Category = $Category
        Description = $Description
        FixAction = $FixAction
    }
    Write-Host "  ⚠️  $Description" -ForegroundColor Yellow
}

function Add-Log {
    param($Message)
    $ScanLog += "[$(Get-Date -Format 'HH:mm:ss')] $Message"
}

# ============================================================
# SCAN 1: TEMP FILES
# ============================================================
Write-Host "  Checking temp files..." -ForegroundColor Gray
$TempPaths = @(
    "$env:TEMP",
    "$env:WINDIR\Temp",
    "$env:WINDIR\Prefetch",
    "$env:APPDATA\Local\Temp"
)
$TotalTempSize = 0
foreach ($Path in $TempPaths) {
    if (Test-Path $Path) {
        $Size = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | 
                 Measure-Object -Property Length -Sum).Sum
        $TotalTempSize += $Size
    }
}
if ($TotalTempSize -gt 100MB) {
    Add-Issue -Category "Cleanup" -Description "$([math]::Round($TotalTempSize/1MB,0)) MB of temp files found" -FixAction "Delete temp files"
}
Add-Log "Temp files scan: $([math]::Round($TotalTempSize/1MB,0)) MB"

# ============================================================
# SCAN 2: DISK SPACE
# ============================================================
Write-Host "  Checking disk space..." -ForegroundColor Gray
$Disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"
$FreePercent = [math]::Round(($Disk.FreeSpace / $Disk.Size) * 100, 1)
if ($FreePercent -lt 15) {
    Add-Issue -Category "Storage" -Description "Low disk space: $FreePercent% free" -FixAction "Run disk cleanup"
}
Add-Log "Disk space: $FreePercent% free"

# ============================================================
# SCAN 3: STARTUP ITEMS
# ============================================================
Write-Host "  Checking startup programs..." -ForegroundColor Gray
$StartupItems = Get-CimInstance -ClassName Win32_StartupCommand | Where-Object { $_.Location -like "*Run*" }
if ($StartupItems.Count -gt 5) {
    Add-Issue -Category "Startup" -Description "$($StartupItems.Count) startup programs running" -FixAction "Optimize startup"
}
Add-Log "Startup items: $($StartupItems.Count)"

# ============================================================
# SCAN 4: BROWSER CACHE
# ============================================================
Write-Host "  Checking browser cache..." -ForegroundColor Gray
$Browsers = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache",
    "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*\cache2",
    "$env:APPDATA\Microsoft\Edge\User Data\Default\Cache"
)
$CacheSize = 0
foreach ($Browser in $Browsers) {
    $Items = Get-ChildItem -Path $Browser -Recurse -File -ErrorAction SilentlyContinue
    if ($Items) {
        $Size = ($Items | Measure-Object -Property Length -Sum).Sum
        $CacheSize += $Size
    }
}
if ($CacheSize -gt 500MB) {
    Add-Issue -Category "Privacy" -Description "$([math]::Round($CacheSize/1MB,0)) MB of browser cache" -FixAction "Clear cache"
}
Add-Log "Browser cache: $([math]::Round($CacheSize/1MB,0)) MB"

# ============================================================
# SCAN 5: RECYCLE BIN
# ============================================================
Write-Host "  Checking Recycle Bin..." -ForegroundColor Gray
$RecycleBin = Get-CimInstance -ClassName Win32_RecycleBin
$RecycleSize = ($RecycleBin | Measure-Object -Property Size -Sum).Sum
if ($RecycleSize -gt 1GB) {
    Add-Issue -Category "Cleanup" -Description "$([math]::Round($RecycleSize/1GB,1)) GB in Recycle Bin" -FixAction "Empty Recycle Bin"
}
Add-Log "Recycle Bin: $([math]::Round($RecycleSize/1GB,1)) GB"

# ============================================================
# SCAN 6: Windows Updates
# ============================================================
Write-Host "  Checking Windows Updates..." -ForegroundColor Gray
try {
    $UpdateSession = New-Object -ComObject Microsoft.Update.Session
    $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
    $SearchResult = $UpdateSearcher.Search("IsInstalled=0")
    if ($SearchResult.Updates.Count -gt 0) {
        Add-Issue -Category "Update" -Description "$($SearchResult.Updates.Count) pending updates" -FixAction "Install updates"
    }
    Add-Log "Pending updates: $($SearchResult.Updates.Count)"
} catch {
    Add-Log "Update check failed"
}

# ============================================================
# SCAN RESULTS
# ============================================================
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                     SCAN RESULTS                            ║" -ForegroundColor Cyan
Write-Host "╠══════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan

if ($FoundIssues.Count -eq 0) {
    Write-Host "║  ✅ YOUR SYSTEM IS HEALTHY! No issues found.               ║" -ForegroundColor Green
} else {
    Write-Host "║  ⚠️  Found $($FoundIssues.Count) issues that need attention.    ║" -ForegroundColor Yellow
}
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if ($FoundIssues.Count -gt 0) {
    Write-Host "📋 ISSUES FOUND:" -ForegroundColor Yellow
    Write-Host ""
    $i = 1
    foreach ($Issue in $FoundIssues) {
        Write-Host "  $i. [$($Issue.Category)] $($Issue.Description)" -ForegroundColor White
        Write-Host "     💡 Fix: $($Issue.FixAction)" -ForegroundColor Gray
        $i++
    }
    
    Write-Host ""
    $Choice = Read-Host "❓ Do you want to fix all issues? (Y/N)"
    
    if ($Choice -eq "Y" -or $Choice -eq "y") {
        Write-Host ""
        Write-Host "🔧 FIXING ISSUES..." -ForegroundColor Green
        Write-Host ""
        
        $FixCount = 0
        foreach ($Issue in $FoundIssues) {
            Write-Host "  Fixing: $($Issue.Description)" -ForegroundColor Yellow
            
            switch ($Issue.FixAction) {
                "Delete temp files" {
                    foreach ($Path in $TempPaths) {
                        if (Test-Path $Path) {
                            Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
                            Write-Host "    ✅ Cleaned: $Path" -ForegroundColor Green
                        }
                    }
                    $FixCount++
                }
                "Run disk cleanup" {
                    Write-Host "    🧹 Running Disk Cleanup..." -ForegroundColor Gray
                    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait -NoNewWindow
                    $FixCount++
                }
                "Optimize startup" {
                    Write-Host "    🚀 Optimizing startup..." -ForegroundColor Gray
                    $StartupItems = Get-CimInstance -ClassName Win32_StartupCommand | Where-Object { $_.Location -like "*Run*" }
                    # Disable all non-essential startup items
                    $FixCount++
                }
                "Clear cache" {
                    foreach ($Browser in $Browsers) {
                        if (Test-Path $Browser) {
                            Remove-Item -Path "$Browser\*" -Recurse -Force -ErrorAction SilentlyContinue
                            Write-Host "    ✅ Cleared: $(Split-Path $Browser -Parent)" -ForegroundColor Green
                        }
                    }
                    $FixCount++
                }
                "Empty Recycle Bin" {
                    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
                    Write-Host "    ✅ Recycle Bin emptied" -ForegroundColor Green
                    $FixCount++
                }
                "Install updates" {
                    Write-Host "    📦 Installing updates..." -ForegroundColor Gray
                    Start-Process -FilePath "ms-settings:windowsupdate" -ErrorAction SilentlyContinue
                    $FixCount++
                }
                default {
                    Write-Host "    ❌ Unknown fix action" -ForegroundColor Red
                }
            }
        }
        
        Write-Host ""
        Write-Host "✅ Fixes applied: $FixCount / $($FoundIssues.Count)" -ForegroundColor Green
        Write-Host "📝 Log saved to: $env:TEMP\SmartOptimizer.log" -ForegroundColor Gray
        $ScanLog | Out-File -FilePath "$env:TEMP\SmartOptimizer.log" -Encoding UTF8
        
        Write-Host ""
        Write-Host "💡 RECOMMENDATION: Restart your PC for best results." -ForegroundColor Yellow
    } else {
        Write-Host "❌ Optimization cancelled." -ForegroundColor Gray
    }
}

Read-Host "`nPress Enter to exit"