# ============================================================
# SHANECODES - PRIVACY GUARD v1.0
# ============================================================
# Clears browsing history, cookies, and temp files
# Created by: Shane Nichael Obinguar (ShaneCodes)
# ============================================================
# (c) 2024-2025 ShaneCodes Technologies. All rights reserved.
# ============================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "ShaneCodes - Privacy Guard v1.0"

# ============================================================
# ADMIN CHECK
# ============================================================
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host ""
    Write-Host "[ERROR] Administrator privileges required!" -ForegroundColor Red
    Write-Host "Please run as Administrator." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit
}

# ============================================================
# BANNER
# ============================================================
Write-Host @"

============================================================
                                                              
    ███████╗██╗  ██╗ █████╗ ███╗   ██╗███████╗ ██████╗     
    ██╔════╝██║  ██║██╔══██╗████╗  ██║██╔════╝██╔════╝     
    ███████╗███████║███████║██╔██╗ ██║█████╗  ██║  ███╗    
    ╚════██║██╔══██║██╔══██║██║╚██╗██║██╔══╝  ██║   ██║    
    ███████║██║  ██║██║  ██║██║ ╚████║███████╗╚██████╔╝    
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝     
                                                              
         PRIVACY GUARD v1.0                         
           Created by: ShaneCodes Technologies              
        "Protect Your Digital Privacy!"                            
                                                              
============================================================

"@ -ForegroundColor Cyan

# ============================================================
# FUNCTION: CLEAN BROWSER CACHE
# ============================================================
function Clean-BrowserCache {
    param($BrowserName, $Paths)
    
    Write-Host ""
    Write-Host "  Cleaning $BrowserName..." -ForegroundColor Gray
    
    $TotalCleaned = 0
    $PathsFound = 0
    
    foreach ($Path in $Paths) {
        if (Test-Path $Path) {
            $PathsFound++
            try {
                $Before = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
                $After = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                $Cleaned = [math]::Round(($Before - $After) / 1MB, 1)
                if ($Cleaned -gt 0) {
                    Write-Host "    [OK] $([System.IO.Path]::GetFileName($Path)): $Cleaned MB cleaned" -ForegroundColor Green
                    $TotalCleaned += $Cleaned
                }
            } catch {
                Write-Host "    [WARNING] Could not clean: $([System.IO.Path]::GetFileName($Path))" -ForegroundColor Yellow
            }
        }
    }
    
    if ($PathsFound -eq 0) {
        Write-Host "    [INFO] No cache found for $BrowserName" -ForegroundColor Gray
    }
    
    return $TotalCleaned
}

# ============================================================
# FUNCTION: CLEAR BROWSER HISTORY
# ============================================================
function Clear-BrowserHistory {
    param($BrowserName, $HistoryPaths)
    
    Write-Host ""
    Write-Host "  Clearing $BrowserName history..." -ForegroundColor Gray
    
    $Cleaned = 0
    
    foreach ($Path in $HistoryPaths) {
        if (Test-Path $Path) {
            try {
                $Files = Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue
                $Count = $Files.Count
                Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "    [OK] Removed $Count history files" -ForegroundColor Green
                $Cleaned += $Count
            } catch {
                Write-Host "    [WARNING] Could not clear history" -ForegroundColor Yellow
            }
        }
    }
    
    if ($Cleaned -eq 0) {
        Write-Host "    [INFO] No history found for $BrowserName" -ForegroundColor Gray
    }
    
    return $Cleaned
}

# ============================================================
# FUNCTION: CLEAN TEMP FILES
# ============================================================
function Clean-TempFiles {
    Write-Host ""
    Write-Host "[+] CLEANING TEMP FILES" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    $TempPaths = @(
        "$env:TEMP",
        "$env:WINDIR\Temp",
        "$env:APPDATA\Local\Temp"
    )
    
    $TotalCleaned = 0
    
    foreach ($Path in $TempPaths) {
        if (Test-Path $Path) {
            try {
                $Before = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
                $After = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                $Cleaned = [math]::Round(($Before - $After) / 1MB, 1)
                if ($Cleaned -gt 0) {
                    Write-Host "  [OK] $([System.IO.Path]::GetFileName($Path)): $Cleaned MB cleaned" -ForegroundColor Green
                    $TotalCleaned += $Cleaned
                }
            } catch {
                Write-Host "  [WARNING] Could not clean: $([System.IO.Path]::GetFileName($Path))" -ForegroundColor Yellow
            }
        }
    }
    
    return $TotalCleaned
}

# ============================================================
# FUNCTION: EMPTY RECYCLE BIN
# ============================================================
function Empty-RecycleBin {
    Write-Host ""
    Write-Host "[+] EMPTYING RECYCLE BIN" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
        Write-Host "  [OK] Recycle Bin emptied" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "  [WARNING] Could not empty Recycle Bin" -ForegroundColor Yellow
        return $false
    }
}

# ============================================================
# FUNCTION: CLEAR DNS CACHE
# ============================================================
function Clear-DNSCache {
    Write-Host ""
    Write-Host "[+] CLEARING DNS CACHE" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        ipconfig /flushdns | Out-Null
        Write-Host "  [OK] DNS cache cleared" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "  [WARNING] Could not clear DNS cache" -ForegroundColor Yellow
        return $false
    }
}

# ============================================================
# FUNCTION: CLEAR RECENT DOCUMENTS
# ============================================================
function Clear-RecentDocuments {
    Write-Host ""
    Write-Host "[+] CLEARING RECENT DOCUMENTS" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        $RecentPath = "$env:APPDATA\Microsoft\Windows\Recent"
        if (Test-Path $RecentPath) {
            Remove-Item -Path "$RecentPath\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "  [OK] Recent documents cleared" -ForegroundColor Green
            return $true
        } else {
            Write-Host "  [INFO] No recent documents found" -ForegroundColor Gray
            return $false
        }
    } catch {
        Write-Host "  [WARNING] Could not clear recent documents" -ForegroundColor Yellow
        return $false
    }
}

# ============================================================
# MAIN PRIVACY CLEANUP
# ============================================================
Write-Host ""
Write-Host "[+] STARTING PRIVACY CLEANUP" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

$TotalCleaned = 0

# 1. Clean Temp Files
$TotalCleaned += Clean-TempFiles

# 2. Clean Browsers
Write-Host ""
Write-Host "[+] CLEANING BROWSERS" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Gray

# Chrome
$ChromeCache = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache"
)
$ChromeHistory = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\History"
)
$TotalCleaned += Clean-BrowserCache -BrowserName "Chrome" -Paths $ChromeCache
Clear-BrowserHistory -BrowserName "Chrome" -HistoryPaths $ChromeHistory

# Edge
$EdgeCache = @(
    "$env:APPDATA\Microsoft\Edge\User Data\Default\Cache",
    "$env:APPDATA\Microsoft\Edge\User Data\Default\Code Cache"
)
$EdgeHistory = @(
    "$env:APPDATA\Microsoft\Edge\User Data\Default\History"
)
$TotalCleaned += Clean-BrowserCache -BrowserName "Edge" -Paths $EdgeCache
Clear-BrowserHistory -BrowserName "Edge" -HistoryPaths $EdgeHistory

# Firefox
$FirefoxCache = @(
    "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*\cache2"
)
$FirefoxHistory = @(
    "$env:APPDATA\Mozilla\Firefox\Profiles\*\places.sqlite"
)
$TotalCleaned += Clean-BrowserCache -BrowserName "Firefox" -Paths $FirefoxCache
Clear-BrowserHistory -BrowserName "Firefox" -HistoryPaths $FirefoxHistory

# 3. Empty Recycle Bin
Empty-RecycleBin

# 4. Clear DNS Cache
Clear-DNSCache

# 5. Clear Recent Documents
Clear-RecentDocuments

# ============================================================
# RESULTS
# ============================================================
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "                    PRIVACY CLEANUP COMPLETE!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Total space cleaned: $([math]::Round($TotalCleaned, 1)) MB" -ForegroundColor Green
Write-Host "  Privacy data cleared: Browser caches, history, temp files" -ForegroundColor White
Write-Host "============================================================" -ForegroundColor Cyan

Read-Host "`nPress Enter to exit"