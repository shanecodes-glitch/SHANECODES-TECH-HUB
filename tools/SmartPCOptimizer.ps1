# ============================================================
# SMART PC OPTIMIZER v1.0 (FIXED)
# ============================================================
# Created by: Shane Nichael Obinguar (ShaneCodes)
# ============================================================
# (c) 2024-2025 ShaneCodes Technologies. All rights reserved.
# ============================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "Smart PC Optimizer v1.0"

# ============================================================
# ADMIN CHECK
# ============================================================
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "[ERROR] Run as Administrator!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

# ============================================================
# BANNER
# ============================================================
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
    Write-Host "  ⚠️  $([math]::Round($TotalTempSize/1MB,0)) MB of temp files found" -ForegroundColor Yellow
} else {
    Write-Host "  ✅ Temp files: $([math]::Round($TotalTempSize/1MB,0)) MB" -ForegroundColor Green
}

# ============================================================
# SCAN 2: DISK SPACE
# ============================================================
Write-Host "  Checking disk space..." -ForegroundColor Gray
$Disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" -ErrorAction SilentlyContinue
if ($Disk) {
    $FreePercent = [math]::Round(($Disk.FreeSpace / $Disk.Size) * 100, 1)
    if ($FreePercent -lt 15) {
        Write-Host "  ⚠️  Low disk space: $FreePercent% free" -ForegroundColor Yellow
    } else {
        Write-Host "  ✅ Disk space: $FreePercent% free" -ForegroundColor Green
    }
}

# ============================================================
# SCAN 3: STARTUP ITEMS
# ============================================================
Write-Host "  Checking startup programs..." -ForegroundColor Gray
$StartupItems = Get-CimInstance -ClassName Win32_StartupCommand -ErrorAction SilentlyContinue
if ($StartupItems) {
    $Count = $StartupItems.Count
    if ($Count -gt 5) {
        Write-Host "  ⚠️  $Count startup programs running" -ForegroundColor Yellow
    } else {
        Write-Host "  ✅ $Count startup programs" -ForegroundColor Green
    }
}

# ============================================================
# SCAN 4: BROWSER CACHE
# ============================================================
Write-Host "  Checking browser cache..." -ForegroundColor Gray
$Browsers = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache",
    "$env:APPDATA\Mozilla\Firefox\Profiles\*\cache2",
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
    Write-Host "  ⚠️  $([math]::Round($CacheSize/1MB,0)) MB of browser cache" -ForegroundColor Yellow
} else {
    Write-Host "  ✅ Browser cache: $([math]::Round($CacheSize/1MB,0)) MB" -ForegroundColor Green
}

# ============================================================
# SCAN 5: RECYCLE BIN (FIXED - Using COM Object)
# ============================================================
Write-Host "  Checking Recycle Bin..." -ForegroundColor Gray
try {
    # Alternative method using Shell.Application
    $Shell = New-Object -ComObject Shell.Application
    $RecycleBin = $Shell.NameSpace(0xA)
    $RecycleSize = 0
    if ($RecycleBin) {
        $Items = $RecycleBin.Items()
        foreach ($Item in $Items) {
            $RecycleSize += $Item.Size
        }
    }
    if ($RecycleSize -gt 1GB) {
        Write-Host "  ⚠️  $([math]::Round($RecycleSize/1GB,1)) GB in Recycle Bin" -ForegroundColor Yellow
    } else {
        Write-Host "  ✅ Recycle Bin: $([math]::Round($RecycleSize/1MB,0)) MB" -ForegroundColor Green
    }
} catch {
    Write-Host "  ⚠️  Unable to check Recycle Bin size" -ForegroundColor Yellow
}

# ============================================================
# SCAN 6: WINDOWS UPDATES
# ============================================================
Write-Host "  Checking Windows Updates..." -ForegroundColor Gray
try {
    $UpdateSession = New-Object -ComObject Microsoft.Update.Session -ErrorAction SilentlyContinue
    if ($UpdateSession) {
        $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
        $SearchResult = $UpdateSearcher.Search("IsInstalled=0")
        if ($SearchResult.Updates.Count -gt 0) {
            Write-Host "  ⚠️  $($SearchResult.Updates.Count) pending updates" -ForegroundColor Yellow
        } else {
            Write-Host "  ✅ No pending updates" -ForegroundColor Green
        }
    } else {
        Write-Host "  ⚠️  Unable to check Windows Updates" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ⚠️  Unable to check Windows Updates" -ForegroundColor Yellow
}

# ============================================================
# RESULTS
# ============================================================
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                     SCAN RESULTS                            ║" -ForegroundColor Cyan
Write-Host "╠══════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
Write-Host "║  ✅ SCAN COMPLETE!                                          ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Read-Host "`nPress Enter to exit"