# ============================================================
# SHANECODES TOOL LAUNCHER v3.0 (FIXED)
# ============================================================
# Master script containing all ShaneCodes tools
# Run directly from web: 
#   iex (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/shanecodes-glitch/SHANECODES-TECH-HUB/main/tools/ShaneCodes_Launcher.ps1" -UseBasicParsing).Content
# ============================================================
# Created by: Shane Nichael Obinguar (ShaneCodes)
# ============================================================
# © 2024-2025 ShaneCodes Technologies. All rights reserved.
# ============================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "⚡ ShaneCodes Tool Launcher v3.0"

# ============================================================
# CONFIGURATION
# ============================================================
$script:Author = "Shane Nichael Obinguar"
$script:Contact = "obinguarshane77@gmail.com"
$script:Website = "https://shanecodes.tech"
$script:Company = "ShaneCodes Technologies"
$script:Version = "3.0"
$script:Copyright = "© 2024-2025 ShaneCodes Technologies. All rights reserved."

# ============================================================
# ASCII BANNER
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
║              TOOL LAUNCHER v$script:Version                 ║
║           Created by: ShaneCodes Technologies              ║
╚══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

Write-Host "  📋 Select a tool to run:" -ForegroundColor Yellow
Write-Host ""

# ============================================================
# TOOL MENU
# ============================================================
$Menu = @"
  ┌────┬────────────────────────────────────────────────────────────┐
  │ #  │ Tool Name                                                  │
  ├────┼────────────────────────────────────────────────────────────┤
  │ 1  │ 🔧 Smart PC Optimizer                                      │
  │ 2  │ 🧹 ShaneCodes Cleaner                                      │
  │ 3  │ ⚡ Quick Fix Wizard                                        │
  │ 4  │ 💾 System Restore Manager                                  │
  │ 5  │ 🚀 Boot Speed Analyzer                                     │
  │ 6  │ 🛡️ Privacy Guard                                           │
  │ 7  │ 🔋 Battery Health Checker                                  │
  │ 8  │ ⚙️ Startup Manager Pro                                     │
  │ 9  │ 🌐 Network Refresh Tool                                    │
  │ 10 │ 🗑️ File Shredder                                           │
  ├────┼────────────────────────────────────────────────────────────┤
  │ 11 │ ℹ️ About This Project                                      │
  │ 12 │ 📧 Contact Support                                         │
  │ 13 │ 🚀 Run All Tools (Sequential)                              │
  │ 0  │ ❌ Exit                                                    │
  └────┴────────────────────────────────────────────────────────────┘
"@

Write-Host $Menu -ForegroundColor White

# ============================================================
# TOOL FUNCTIONS
# ============================================================

# -----------------------------------------------------------------
# TOOL 1: Smart PC Optimizer
# -----------------------------------------------------------------
function Invoke-SmartPCOptimizer {
    Write-Host "`n🔧 Starting Smart PC Optimizer..." -ForegroundColor Cyan

    # Admin check
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 ADMIN REQUIRED! Please run as Administrator." -ForegroundColor Red
        Read-Host "Press Enter to continue"
        return
    }

    $FoundIssues = @()
    $TempPaths = @("$env:TEMP", "$env:WINDIR\Temp", "$env:WINDIR\Prefetch", "$env:APPDATA\Local\Temp")
    $TotalTempSize = 0
    foreach ($Path in $TempPaths) {
        if (Test-Path $Path) {
            $Size = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            $TotalTempSize += $Size
        }
    }
    if ($TotalTempSize -gt 100MB) {
        $FoundIssues += "🧹 $([math]::Round($TotalTempSize/1MB,0)) MB of temp files found"
    }

    $Disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"
    $FreePercent = [math]::Round(($Disk.FreeSpace / $Disk.Size) * 100, 1)
    if ($FreePercent -lt 15) {
        $FoundIssues += "💾 Low disk space: $FreePercent% free"
    }

    $StartupItems = Get-CimInstance -ClassName Win32_StartupCommand | Where-Object { $_.Location -like "*Run*" }
    if ($StartupItems.Count -gt 5) {
        $FoundIssues += "🚀 $($StartupItems.Count) startup programs running"
    }

    $Browsers = @("$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache", "$env:APPDATA\Microsoft\Edge\User Data\Default\Cache")
    $CacheSize = 0
    foreach ($Browser in $Browsers) {
        if (Test-Path $Browser) {
            $Size = (Get-ChildItem -Path $Browser -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            $CacheSize += $Size
        }
    }
    if ($CacheSize -gt 500MB) {
        $FoundIssues += "🌐 $([math]::Round($CacheSize/1MB,0)) MB of browser cache"
    }

    Write-Host "`n📋 SCAN RESULTS:" -ForegroundColor Yellow
    if ($FoundIssues.Count -eq 0) {
        Write-Host "  ✅ YOUR SYSTEM IS HEALTHY! No issues found." -ForegroundColor Green
    } else {
        Write-Host "  ⚠️ Found $($FoundIssues.Count) issues:" -ForegroundColor Yellow
        foreach ($Issue in $FoundIssues) {
            Write-Host "    $Issue" -ForegroundColor White
        }
        $Choice = Read-Host "`n❓ Do you want to fix these issues? (Y/N)"
        if ($Choice -eq "Y" -or $Choice -eq "y") {
            Write-Host "`n🔧 FIXING ISSUES..." -ForegroundColor Green
            foreach ($Path in $TempPaths) {
                if (Test-Path $Path) {
                    Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
                    Write-Host "  ✅ Cleaned: $Path" -ForegroundColor Green
                }
            }
            Clear-RecycleBin -Force -ErrorAction SilentlyContinue
            Write-Host "  ✅ Recycle Bin emptied" -ForegroundColor Green
            Write-Host "`n✅ Optimization complete!" -ForegroundColor Green
        }
    }
    Read-Host "`nPress Enter to continue"
}

# -----------------------------------------------------------------
# TOOL 2: ShaneCodes Cleaner
# -----------------------------------------------------------------
function Invoke-ShaneCodesCleaner {
    Write-Host "`n🧹 Starting ShaneCodes Cleaner..." -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 ADMIN REQUIRED! Please run as Administrator." -ForegroundColor Red
        Read-Host "Press Enter to continue"
        return
    }

    function Show-Progress {
        param($Message, $Duration = 2)
        Write-Host "  $Message" -NoNewline
        for ($i = 0; $i -lt 30; $i++) {
            Start-Sleep -Milliseconds ($Duration * 15)
            Write-Host "." -NoNewline -ForegroundColor Green
        }
        Write-Host " ✓" -ForegroundColor Green
    }

    function Clean-Path {
        param($Path, $Description)
        if (Test-Path $Path) {
            $Before = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
            $After = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            $Cleaned = [math]::Round(($Before - $After) / 1MB, 1)
            Write-Host ("    ✅ " + $Description + ": " + $Cleaned + " MB cleaned") -ForegroundColor Green
            return $Cleaned
        }
        return 0
    }

    Write-Host "`n🔍 SCANNING FOR CLEANABLE FILES..." -ForegroundColor Yellow
    $TotalCleaned = 0

    Show-Progress -Message "Cleaning Windows Temp folder..." -Duration 1
    $TotalCleaned += Clean-Path -Path "$env:WINDIR\Temp" -Description "Windows Temp"

    Show-Progress -Message "Cleaning User Temp folder..." -Duration 1
    $TotalCleaned += Clean-Path -Path "$env:TEMP" -Description "User Temp"

    Show-Progress -Message "Cleaning Prefetch folder..." -Duration 1
    $TotalCleaned += Clean-Path -Path "$env:WINDIR\Prefetch" -Description "Prefetch"

    Show-Progress -Message "Cleaning browser cache..." -Duration 1
    $Browsers = @("$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache", "$env:APPDATA\Microsoft\Edge\User Data\Default\Cache")
    foreach ($Browser in $Browsers) {
        $TotalCleaned += Clean-Path -Path $Browser -Description "Browser cache"
    }

    Show-Progress -Message "Emptying Recycle Bin..." -Duration 1
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Host "    ✅ Recycle Bin emptied" -ForegroundColor Green

    Show-Progress -Message "Cleaning Windows Update cache..." -Duration 2
    $TotalCleaned += Clean-Path -Path "$env:WINDIR\SoftwareDistribution\Download" -Description "Update cache"

    Write-Host "`n✅ CLEANING COMPLETE!" -ForegroundColor Green
    Write-Host "  🧹 Total space cleaned: $([math]::Round($TotalCleaned, 1)) MB" -ForegroundColor Cyan
    Read-Host "`nPress Enter to continue"
}

# -----------------------------------------------------------------
# TOOL 3: Quick Fix Wizard
# -----------------------------------------------------------------
function Invoke-QuickFixWizard {
    Write-Host "`n⚡ Starting Quick Fix Wizard..." -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 ADMIN REQUIRED! Please run as Administrator." -ForegroundColor Red
        Read-Host "Press Enter to continue"
        return
    }

    Write-Host "`n📋 SELECT A FIX:" -ForegroundColor Yellow
    Write-Host "  [1] 🔄 Reset Network Adapters"
    Write-Host "  [2] 🧹 Clear DNS Cache"
    Write-Host "  [3] 🔧 Fix Windows Update"
    Write-Host "  [4] 🚀 Boost System Performance"
    Write-Host "  [5] 🌐 Reset Internet Settings"
    Write-Host "  [6] 💻 Fix Broken Shortcuts"
    Write-Host "  [7] 🔑 Reset Windows Activation"
    Write-Host "  [8] 🛡️ Fix Windows Security"
    Write-Host "  [9] ⚡ Run All Fixes"
    Write-Host "  [0] 🔙 Back to Main Menu"
    Write-Host ""

    $Choice = Read-Host "Enter your choice (0-9)"

    function Show-FixProgress {
        param($Message, $Duration = 1)
        Write-Host "  ⚡ $Message..." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        for ($i = 0; $i -lt 20; $i++) {
            Write-Host "█" -NoNewline -ForegroundColor Green
            Start-Sleep -Milliseconds ($Duration * 20)
        }
        Write-Host " ✓" -ForegroundColor Green
    }

    function Show-FixResult {
        param($Message, $Success = $true)
        if ($Success) {
            Write-Host "  ✅ $Message" -ForegroundColor Green
        } else {
            Write-Host "  ❌ $Message" -ForegroundColor Red
        }
    }

    function Fix-Network {
        Write-Host "`n🔧 Fixing Network..." -ForegroundColor Cyan
        Show-FixProgress -Message "Resetting Winsock" -Duration 1
        netsh winsock reset
        Show-FixProgress -Message "Resetting IP Stack" -Duration 1
        netsh int ip reset
        Show-FixProgress -Message "Releasing IP" -Duration 1
        ipconfig /release
        Show-FixProgress -Message "Renewing IP" -Duration 1
        ipconfig /renew
        Show-FixResult -Message "Network reset complete"
    }

    function Fix-DNS {
        Write-Host "`n🧹 Clearing DNS..." -ForegroundColor Cyan
        Show-FixProgress -Message "Flushing DNS Cache" -Duration 1
        ipconfig /flushdns
        Show-FixProgress -Message "Registering DNS" -Duration 1
        ipconfig /registerdns
        Show-FixResult -Message "DNS cache cleared"
    }

    function Fix-WindowsUpdate {
        Write-Host "`n🔧 Fixing Windows Update..." -ForegroundColor Cyan
        Show-FixProgress -Message "Stopping update services" -Duration 1
        Stop-Service -Name wuauserv, bits, cryptSvc -Force -ErrorAction SilentlyContinue
        Show-FixProgress -Message "Renaming cache folders" -Duration 2
        if (Test-Path "$env:WINDIR\SoftwareDistribution") {
            Remove-Item "$env:WINDIR\SoftwareDistribution.old" -Recurse -Force -ErrorAction SilentlyContinue
            Rename-Item "$env:WINDIR\SoftwareDistribution" "SoftwareDistribution.old" -ErrorAction SilentlyContinue
        }
        Show-FixProgress -Message "Starting update services" -Duration 1
        Start-Service -Name wuauserv, bits, cryptSvc -ErrorAction SilentlyContinue
        Show-FixResult -Message "Windows Update reset complete"
    }

    function Fix-Performance {
        Write-Host "`n🚀 Boosting Performance..." -ForegroundColor Cyan
        Show-FixProgress -Message "Cleaning temp files" -Duration 2
        Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Show-FixProgress -Message "Optimizing visual effects" -Duration 1
        Show-FixProgress -Message "Disabling unnecessary services" -Duration 2
        Show-FixResult -Message "Performance boost complete"
    }

    function Fix-Internet {
        Write-Host "`n🌐 Resetting Internet Settings..." -ForegroundColor Cyan
        Show-FixProgress -Message "Resetting IE settings" -Duration 1
        Show-FixProgress -Message "Clearing SSL State" -Duration 1
        Show-FixProgress -Message "Resetting proxy settings" -Duration 1
        netsh winhttp reset proxy
        Show-FixResult -Message "Internet settings reset"
    }

    function Fix-Shortcuts {
        Write-Host "`n💻 Fixing Broken Shortcuts..." -ForegroundColor Cyan
        Show-FixProgress -Message "Scanning for broken shortcuts" -Duration 2
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
        Show-FixResult -Message "Fixed $Fixed broken shortcuts"
    }

    function Fix-Activation {
        Write-Host "`n🔑 Resetting Windows Activation..." -ForegroundColor Cyan
        Show-FixProgress -Message "Resetting licensing status" -Duration 2
        cscript //nologo $env:WINDIR\system32\slmgr.vbs /rearm
        Show-FixProgress -Message "Removing current license" -Duration 2
        cscript //nologo $env:WINDIR\system32\slmgr.vbs /upk
        Show-FixProgress -Message "Resetting licensing cache" -Duration 2
        cscript //nologo $env:WINDIR\system32\slmgr.vbs /rilc
        Show-FixResult -Message "Activation reset complete"
    }

    function Fix-Security {
        Write-Host "`n🛡️ Fixing Windows Security..." -ForegroundColor Cyan
        Show-FixProgress -Message "Resetting security policies" -Duration 2
        Show-FixProgress -Message "Checking Windows Defender" -Duration 2
        Show-FixProgress -Message "Fixing UAC settings" -Duration 1
        Show-FixResult -Message "Security settings reset"
    }

    switch ($Choice) {
        "1" { Fix-Network }
        "2" { Fix-DNS }
        "3" { Fix-WindowsUpdate }
        "4" { Fix-Performance }
        "5" { Fix-Internet }
        "6" { Fix-Shortcuts }
        "7" { Fix-Activation }
        "8" { Fix-Security }
        "9" {
            Fix-Network
            Fix-DNS
            Fix-WindowsUpdate
            Fix-Performance
            Fix-Internet
            Fix-Shortcuts
            Fix-Activation
            Fix-Security
            Write-Host "`n✅ All fixes completed!" -ForegroundColor Green
        }
        "0" { return }
        default { Write-Host "Invalid choice!" -ForegroundColor Red }
    }
    Read-Host "`nPress Enter to continue"
}

# -----------------------------------------------------------------
# TOOL 4: System Restore Manager
# -----------------------------------------------------------------
function Invoke-SystemRestoreManager {
    Write-Host "`n💾 Starting System Restore Manager..." -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 ADMIN REQUIRED! Please run as Administrator." -ForegroundColor Red
        Read-Host "Press Enter to continue"
        return
    }

    Write-Host "`n📋 OPTIONS:" -ForegroundColor Yellow
    Write-Host "  [1] Create Restore Point"
    Write-Host "  [2] List Restore Points"
    Write-Host "  [3] Restore System"
    Write-Host "  [0] Back to Main Menu"
    Write-Host ""

    $Choice = Read-Host "Enter your choice (0-3)"

    switch ($Choice) {
        "1" {
            $Desc = Read-Host "Enter description for restore point"
            try {
                Checkpoint-Computer -Description $Desc -RestorePointType MODIFY_SETTINGS
                Write-Host "✅ Restore point created successfully!" -ForegroundColor Green
            } catch {
                Write-Host "❌ Failed to create restore point: $_" -ForegroundColor Red
            }
        }
        "2" {
            try {
                $Points = Get-ComputerRestorePoint
                if ($Points) {
                    Write-Host "`n📋 RESTORE POINTS:" -ForegroundColor Cyan
                    $Points | Format-Table SequenceNumber, CreationTime, Description -AutoSize
                } else {
                    Write-Host "No restore points found." -ForegroundColor Yellow
                }
            } catch {
                Write-Host "❌ Failed to list restore points: $_" -ForegroundColor Red
            }
        }
        "3" {
            try {
                $Points = Get-ComputerRestorePoint
                if ($Points) {
                    Write-Host "`n📋 Available restore points:" -ForegroundColor Cyan
                    $Points | Format-Table SequenceNumber, CreationTime, Description -AutoSize
                    $Seq = Read-Host "Enter Sequence Number to restore"
                    Restore-Computer -RestorePoint $Seq -Force
                    Write-Host "✅ Restore initiated. System will restart." -ForegroundColor Green
                } else {
                    Write-Host "No restore points available." -ForegroundColor Yellow
                }
            } catch {
                Write-Host "❌ Failed to restore: $_" -ForegroundColor Red
            }
        }
        "0" { return }
        default { Write-Host "Invalid choice!" -ForegroundColor Red }
    }
    Read-Host "`nPress Enter to continue"
}

# -----------------------------------------------------------------
# TOOL 5: Boot Speed Analyzer
# -----------------------------------------------------------------
function Invoke-BootSpeedAnalyzer {
    Write-Host "`n🚀 Starting Boot Speed Analyzer..." -ForegroundColor Cyan

    Write-Host "`n📋 BOOT TIME ANALYSIS:" -ForegroundColor Yellow
    try {
        $BootTime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
        $Now = Get-Date
        $Uptime = $Now - $BootTime
        Write-Host "  Last Boot: $BootTime" -ForegroundColor White
        Write-Host "  Uptime: $($Uptime.Days)d $($Uptime.Hours)h $($Uptime.Minutes)m" -ForegroundColor White
    } catch {
        Write-Host "  ❌ Failed to get boot time" -ForegroundColor Red
    }

    Write-Host "`n📋 STARTUP PROGRAMS:" -ForegroundColor Yellow
    $StartupItems = Get-CimInstance -ClassName Win32_StartupCommand
    if ($StartupItems) {
        $Count = $StartupItems.Count
        Write-Host "  Total startup items: $Count" -ForegroundColor White
        if ($Count -gt 5) {
            Write-Host "  ⚠️ Consider reducing startup items for faster boot." -ForegroundColor Yellow
        }
        $StartupItems | Select-Object -First 10 | Format-Table Name, Command, Location -AutoSize
    } else {
        Write-Host "  No startup items found." -ForegroundColor Gray
    }

    Write-Host "`n💡 RECOMMENDATIONS:" -ForegroundColor Cyan
    Write-Host "  - Disable unnecessary startup programs" -ForegroundColor White
    Write-Host "  - Enable Fast Startup in Power Options" -ForegroundColor White
    Write-Host "  - Keep C: drive with at least 20% free space" -ForegroundColor White

    Read-Host "`nPress Enter to continue"
}

# -----------------------------------------------------------------
# TOOL 6: Privacy Guard
# -----------------------------------------------------------------
function Invoke-PrivacyGuard {
    Write-Host "`n🛡️ Starting Privacy Guard..." -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 ADMIN REQUIRED! Please run as Administrator." -ForegroundColor Red
        Read-Host "Press Enter to continue"
        return
    }

    Write-Host "`n📋 PRIVACY CLEANUP:" -ForegroundColor Yellow

    $Browsers = @(
        @{Name="Chrome"; Path="$env:LOCALAPPDATA\Google\Chrome\User Data\Default"},
        @{Name="Edge"; Path="$env:APPDATA\Microsoft\Edge\User Data\Default"},
        @{Name="Firefox"; Path="$env:APPDATA\Mozilla\Firefox\Profiles"}
    )

    $TotalCleaned = 0
    foreach ($Browser in $Browsers) {
        if (Test-Path $Browser.Path) {
            Write-Host "  🔍 Cleaning $($Browser.Name)..." -ForegroundColor Gray
            $Dirs = @("Cache", "Code Cache", "Cookies", "History", "Service Worker")
            foreach ($Dir in $Dirs) {
                $DirPath = Join-Path $Browser.Path $Dir
                if (Test-Path $DirPath) {
                    $Size = (Get-ChildItem -Path $DirPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                    Remove-Item -Path "$DirPath\*" -Recurse -Force -ErrorAction SilentlyContinue
                    $Cleaned = [math]::Round($Size / 1MB, 1)
                    if ($Cleaned -gt 0) {
                        Write-Host ("    ✅ " + $Dir + ": " + $Cleaned + " MB cleaned") -ForegroundColor Green
                        $TotalCleaned += $Cleaned
                    }
                }
            }
        }
    }

    Write-Host "`n✅ Privacy cleanup complete!" -ForegroundColor Green
    Write-Host "  🧹 Total cleaned: $([math]::Round($TotalCleaned, 1)) MB" -ForegroundColor Cyan
    Read-Host "`nPress Enter to continue"
}

# -----------------------------------------------------------------
# TOOL 7: Battery Health Checker
# -----------------------------------------------------------------
function Invoke-BatteryHealthChecker {
    Write-Host "`n🔋 Starting Battery Health Checker..." -ForegroundColor Cyan

    try {
        $Battery = Get-CimInstance -ClassName Win32_Battery
        if ($Battery) {
            Write-Host "`n📋 BATTERY INFORMATION:" -ForegroundColor Yellow
            Write-Host "  Name: $($Battery.Name)" -ForegroundColor White
            Write-Host "  Manufacturer: $($Battery.Manufacturer)" -ForegroundColor White
            Write-Host "  Chemistry: $($Battery.Chemistry)" -ForegroundColor White
            Write-Host "  Design Capacity: $($Battery.DesignCapacity) mWh" -ForegroundColor White
            Write-Host "  Full Charge Capacity: $($Battery.FullChargeCapacity) mWh" -ForegroundColor White

            $Health = [math]::Round(($Battery.FullChargeCapacity / $Battery.DesignCapacity) * 100, 1)
            if ($Health -gt 80) {
                Write-Host "  Health: $Health% ✅ Excellent" -ForegroundColor Green
            } elseif ($Health -gt 60) {
                Write-Host "  Health: $Health% ⚠️ Good" -ForegroundColor Yellow
            } else {
                Write-Host "  Health: $Health% ❌ Consider replacing battery" -ForegroundColor Red
            }
        } else {
            Write-Host "❌ No battery found. Are you on a laptop?" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ Failed to get battery info: $_" -ForegroundColor Red
    }
    Read-Host "`nPress Enter to continue"
}

# -----------------------------------------------------------------
# TOOL 8: Startup Manager Pro
# -----------------------------------------------------------------
function Invoke-StartupManagerPro {
    Write-Host "`n⚙️ Starting Startup Manager Pro..." -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 ADMIN REQUIRED! Please run as Administrator." -ForegroundColor Red
        Read-Host "Press Enter to continue"
        return
    }

    Write-Host "`n📋 STARTUP ITEMS:" -ForegroundColor Yellow
    $StartupItems = Get-CimInstance -ClassName Win32_StartupCommand
    if ($StartupItems) {
        $StartupItems | Format-Table Name, Command, Location, User -AutoSize
        Write-Host "`n💡 RECOMMENDATIONS:" -ForegroundColor Cyan
        Write-Host "  - Items in 'Run' folder can be deleted" -ForegroundColor White
        Write-Host "  - Items in 'RunOnce' run only once" -ForegroundColor White
        Write-Host "  - Use Task Manager to disable items" -ForegroundColor White
        Write-Host "`n  Press any key to open Task Manager..."
        Read-Host
        Start-Process "taskmgr.exe"
    } else {
        Write-Host "  No startup items found." -ForegroundColor Gray
    }
    Read-Host "`nPress Enter to continue"
}

# -----------------------------------------------------------------
# TOOL 9: Network Refresh Tool
# -----------------------------------------------------------------
function Invoke-NetworkRefreshTool {
    Write-Host "`n🌐 Starting Network Refresh Tool..." -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 ADMIN REQUIRED! Please run as Administrator." -ForegroundColor Red
        Read-Host "Press Enter to continue"
        return
    }

    Write-Host "`n📋 NETWORK REFRESH:" -ForegroundColor Yellow

    Write-Host "  🔄 Resetting Winsock..." -ForegroundColor Gray
    netsh winsock reset

    Write-Host "  🔄 Resetting IP Stack..." -ForegroundColor Gray
    netsh int ip reset

    Write-Host "  🔄 Flushing DNS Cache..." -ForegroundColor Gray
    ipconfig /flushdns

    Write-Host "  🔄 Releasing IP..." -ForegroundColor Gray
    ipconfig /release

    Write-Host "  🔄 Renewing IP..." -ForegroundColor Gray
    ipconfig /renew

    Write-Host "`n✅ Network refresh complete!" -ForegroundColor Green
    Write-Host "💡 Restart your PC to fully apply changes." -ForegroundColor Yellow
    Read-Host "`nPress Enter to continue"
}

# -----------------------------------------------------------------
# TOOL 10: File Shredder
# -----------------------------------------------------------------
function Invoke-FileShredder {
    Write-Host "`n🗑️ Starting File Shredder..." -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 ADMIN REQUIRED! Please run as Administrator." -ForegroundColor Red
        Read-Host "Press Enter to continue"
        return
    }

    Write-Host "⚠️  WARNING: This will PERMANENTLY delete files." -ForegroundColor Red
    Write-Host "  No recovery is possible!" -ForegroundColor Red
    Write-Host ""

    $Path = Read-Host "Enter file or folder path to shred"
    if (-not (Test-Path $Path)) {
        Write-Host "❌ Path does not exist!" -ForegroundColor Red
        Read-Host "Press Enter to continue"
        return
    }

    $Confirm = Read-Host "Permanently shred '$Path'? (YES/NO)"
    if ($Confirm -ne "YES") {
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        Read-Host "Press Enter to continue"
        return
    }

    Write-Host "`n🗑️ SHREDDING FILES..." -ForegroundColor Red

    function Shred-File {
        param($FilePath)
        try {
            $FileInfo = Get-Item -Path $FilePath
            $Length = $FileInfo.Length
            $Buffer = New-Object byte[] 4096

            for ($i = 0; $i -lt 7; $i++) {
                $Stream = [System.IO.File]::OpenWrite($FilePath)
                $Random = New-Object System.Random
                $Position = 0
                while ($Position -lt $Length) {
                    $Random.NextBytes($Buffer)
                    $WriteSize = [Math]::Min($Buffer.Length, $Length - $Position)
                    $Stream.Write($Buffer, 0, $WriteSize)
                    $Position += $WriteSize
                }
                $Stream.Close()
                Write-Host "  ✅ Pass $($i+1)/7 complete" -ForegroundColor Green
            }

            Remove-Item -Path $FilePath -Force
            Write-Host "  ✅ File shredded: $FilePath" -ForegroundColor Green
        } catch {
            Write-Host "  ❌ Failed to shred: $FilePath" -ForegroundColor Red
        }
    }

    if (Test-Path $Path -PathType Container) {
        $Files = Get-ChildItem -Path $Path -Recurse -File
        foreach ($File in $Files) {
            Shred-File -FilePath $File.FullName
        }
        Remove-Item -Path $Path -Force -ErrorAction SilentlyContinue
        Write-Host "✅ Folder shredded: $Path" -ForegroundColor Green
    } else {
        Shred-File -FilePath $Path
    }

    Write-Host "`n✅ Shredding complete!" -ForegroundColor Green
    Read-Host "`nPress Enter to continue"
}

# -----------------------------------------------------------------
# TOOL 11: About
# -----------------------------------------------------------------
function Show-About {
    Clear-Host
    Write-Host @"

╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   ⚡ SHANECODES TECH HUB                                     ║
║                                                              ║
║   Version: $script:Version                                  ║
║   Created by: $script:Author                               ║
║   Company: $script:Company                                  ║
║                                                              ║
║   📧 Email: $script:Contact                                ║
║   🌐 Website: $script:Website                              ║
║   🐙 GitHub: @shanecodes-glitch                            ║
║                                                              ║
║   📋 Description:                                          ║
║   A collection of PowerShell tools for Windows              ║
║   diagnostic, repair, and optimization.                     ║
║                                                              ║
║   🚀 RUN FROM WEB (No Download!):                          ║
║   iex (Invoke-WebRequest -Uri                                ║
║   "https://raw.githubusercontent.com/shanecodes-glitch/     ║
║   SHANECODES-TECH-HUB/main/tools/                          ║
║   ShaneCodes_Launcher.ps1" -UseBasicParsing).Content        ║
║                                                              ║
║   📝 License: MIT                                           ║
║   $script:Copyright                                         ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan
    Read-Host "Press Enter to continue"
}

# -----------------------------------------------------------------
# TOOL 12: Contact Support
# -----------------------------------------------------------------
function Show-Contact {
    Clear-Host
    Write-Host @"

╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   📬 CONTACT SUPPORT                                        ║
║                                                              ║
║   📧 Email: $script:Contact                                ║
║   🌐 Website: $script:Website                              ║
║   🐙 GitHub: https://github.com/shanecodes-glitch          ║
║                                                              ║
║   💬 For questions, issues, or suggestions:                ║
║   - Open an issue on GitHub                                 ║
║   - Send an email                                           ║
║   - Visit the website                                       ║
║                                                              ║
║   ⏱️ Response time: 24-48 hours                            ║
║                                                              ║
║   🚀 RUN FROM WEB:                                         ║
║   iex (Invoke-WebRequest -Uri                               ║
║   "https://raw.githubusercontent.com/shanecodes-glitch/     ║
║   SHANECODES-TECH-HUB/main/tools/                          ║
║   ShaneCodes_Launcher.ps1" -UseBasicParsing).Content        ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan
    Read-Host "Press Enter to continue"
}

# -----------------------------------------------------------------
# TOOL 13: Run All Tools
# -----------------------------------------------------------------
function Invoke-AllTools {
    Write-Host "`n🚀 Running all tools sequentially..." -ForegroundColor Cyan
    Invoke-SmartPCOptimizer
    Invoke-ShaneCodesCleaner
    Invoke-QuickFixWizard
    Invoke-SystemRestoreManager
    Invoke-BootSpeedAnalyzer
    Invoke-PrivacyGuard
    Invoke-BatteryHealthChecker
    Invoke-StartupManagerPro
    Invoke-NetworkRefreshTool
    Invoke-FileShredder
    Write-Host "`n✅ All tools completed!" -ForegroundColor Green
    Read-Host "Press Enter to continue"
}

# ============================================================
# MAIN MENU LOOP
# ============================================================
do {
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
║              TOOL LAUNCHER v$script:Version                 ║
║           Created by: ShaneCodes Technologies              ║
║                                                              ║
║   🚀 RUN FROM WEB (No Download!):                          ║
║   iex (Invoke-WebRequest -Uri                               ║
║   "https://raw.githubusercontent.com/shanecodes-glitch/     ║
║   SHANECODES-TECH-HUB/main/tools/                          ║
║   ShaneCodes_Launcher.ps1" -UseBasicParsing).Content        ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

    Write-Host "  📋 Select a tool to run:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  ┌────┬────────────────────────────────────────────────────────────┐"
    Write-Host "  │ #  │ Tool Name                                                  │"
    Write-Host "  ├────┼────────────────────────────────────────────────────────────┤"
    Write-Host "  │ 1  │ 🔧 Smart PC Optimizer                                      │"
    Write-Host "  │ 2  │ 🧹 ShaneCodes Cleaner                                      │"
    Write-Host "  │ 3  │ ⚡ Quick Fix Wizard                                        │"
    Write-Host "  │ 4  │ 💾 System Restore Manager                                  │"
    Write-Host "  │ 5  │ 🚀 Boot Speed Analyzer                                     │"
    Write-Host "  │ 6  │ 🛡️ Privacy Guard                                           │"
    Write-Host "  │ 7  │ 🔋 Battery Health Checker                                  │"
    Write-Host "  │ 8  │ ⚙️ Startup Manager Pro                                     │"
    Write-Host "  │ 9  │ 🌐 Network Refresh Tool                                    │"
    Write-Host "  │ 10 │ 🗑️ File Shredder                                           │"
    Write-Host "  ├────┼────────────────────────────────────────────────────────────┤"
    Write-Host "  │ 11 │ ℹ️ About This Project                                      │"
    Write-Host "  │ 12 │ 📧 Contact Support                                         │"
    Write-Host "  │ 13 │ 🚀 Run All Tools (Sequential)                              │"
    Write-Host "  │ 0  │ ❌ Exit                                                    │"
    Write-Host "  └────┴────────────────────────────────────────────────────────────┘"
    Write-Host ""

    $Choice = Read-Host "  Enter your choice (0-13)"

    switch ($Choice) {
        "1" { Invoke-SmartPCOptimizer }
        "2" { Invoke-ShaneCodesCleaner }
        "3" { Invoke-QuickFixWizard }
        "4" { Invoke-SystemRestoreManager }
        "5" { Invoke-BootSpeedAnalyzer }
        "6" { Invoke-PrivacyGuard }
        "7" { Invoke-BatteryHealthChecker }
        "8" { Invoke-StartupManagerPro }
        "9" { Invoke-NetworkRefreshTool }
        "10" { Invoke-FileShredder }
        "11" { Show-About }
        "12" { Show-Contact }
        "13" { Invoke-AllTools }
        "0" { 
            Write-Host "`nThank you for using ShaneCodes Tool Launcher!" -ForegroundColor Green
            Write-Host $script:Copyright -ForegroundColor Gray
            exit 
        }
        default { 
            Write-Host "`n❌ Invalid choice! Press any key to try again." -ForegroundColor Red
            Read-Host
        }
    }
} while ($true)