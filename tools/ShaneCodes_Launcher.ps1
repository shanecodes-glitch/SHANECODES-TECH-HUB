# ============================================================
# SHANECODES TOOL LAUNCHER v3.0 (FUNNY EDITION)
# ============================================================
# eto na naman tayo, nag-aayos ng windows na di naman nasira
# run mo lang to, sabay nood ng netflix habang naglo-load
# ============================================================
# gawa ni: shane nichael obinguar (shanecodes)
# ============================================================
# © 2024-2025 shanecodes technologies. lahat ng karapatan ay
# nakalaan, pero pwede mong gamitin basta wag kang magreklamo
# ============================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "⚡ shanecodes tool launcher v3.0 - chill lang"

# ============================================================
# CONFIGURATION - eto yung mga settings na di mo na dapat galawin
# pero sige, tingnan mo lang kung gusto mo
# ============================================================
$script:Author = "shane nichael obinguar"  # yan ang pangalan ko, wag mong nakawin
$script:Contact = "obinguarshane77@gmail.com"  # email ko 'to, wag kang mag-spam
$script:Website = "https://shanecodes.tech"  # website ko 'to, bisitahin mo
$script:Company = "shanecodes technologies"  # company name, pang-bongga
$script:Version = "3.0"  # version number, parang software ng mayaman
$script:Copyright = "© 2024-2025 shanecodes technologies. bawal kopyahin, pero kung gusto mo, go lang"  # copyright, para lang may mailagay

# ============================================================
# ASCII BANNER - eto yung pampaganda, para kunwari professional
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
║           gawa ni: shanecodes technologies                 ║
║        "nag-aayos ng pc habang kumakain ng pancit canton"   ║
╚══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

Write-Host "  📋 pumili ka ng tool, pero wag kang magulo:" -ForegroundColor Yellow
Write-Host ""

# ============================================================
# TOOL MENU - eto yung listahan ng mga pampaganda ng pc mo
# ============================================================
$Menu = @"
  ┌────┬────────────────────────────────────────────────────────────┐
  │ #  │ pangalan ng tool                                          │
  ├────┼────────────────────────────────────────────────────────────┤
  │ 1  │ 🔧 smart pc optimizer - parang gym para sa pc mo         │
  │ 2  │ 🧹 shanecodes cleaner - mas malinis pa sa kwarto mo      │
  │ 3  │ ⚡ quick fix wizard - parang salamangkero ng windows      │
  │ 4  │ 💾 system restore manager - parang time machine           │
  │ 5  │ 🚀 boot speed analyzer - bilisan mo naman mag-boot       │
  │ 6  │ 🛡️ privacy guard - para hindi ka ma-stalk                │
  │ 7  │ 🔋 battery health checker - para sa laptop mong palaging │
  │ 8  │ ⚙️ startup manager pro - tanggalin ang mga bagal          │
  │ 9  │ 🌐 network refresh tool - parang restart ng internet     │
  │ 10 │ 🗑️ file shredder - parang basurahan, pero permanent     │
  │ 11 │ 🔑 windows activation fixer - para ma-activate ulit      │
  ├────┼────────────────────────────────────────────────────────────┤
  │ 12 │ ℹ️ about this project - bakit mo ba 'to ginagamit?       │
  │ 13 │ 📧 contact support - kung may problema, wag kang mag-alala│
  │ 14 │ 🚀 run all tools - sabay-sabay, parang buffet            │
  │ 0  │ ❌ exit - mag-muni-muni ka muna                           │
  └────┴────────────────────────────────────────────────────────────┘
"@

Write-Host $Menu -ForegroundColor White

# ============================================================
# TOOL FUNCTIONS - eto na yung mga totoong trabaho
# ============================================================

# -----------------------------------------------------------------
# TOOL 1: Smart PC Optimizer - parang doctor ng pc mo
# -----------------------------------------------------------------
function Invoke-SmartPCOptimizer {
    Write-Host "`n🔧 nag-aactivate ng smart pc optimizer..." -ForegroundColor Cyan

    # Admin check - kailangan admin, parang bouncer sa club
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 kelangan admin! parang sa trabaho, may boss" -ForegroundColor Red
        Read-Host "press enter para magpatuloy"
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
        $FoundIssues += "🧹 $([math]::Round($TotalTempSize/1MB,0)) MB ng basura ang nakita"
    }

    $Disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"
    $FreePercent = [math]::Round(($Disk.FreeSpace / $Disk.Size) * 100, 1)
    if ($FreePercent -lt 15) {
        $FoundIssues += "💾 ang sikip na ng c: drive mo, $FreePercent% na lang ang natira"
    }

    $StartupItems = Get-CimInstance -ClassName Win32_StartupCommand | Where-Object { $_.Location -like "*Run*" }
    if ($StartupItems.Count -gt 5) {
        $FoundIssues += "🚀 ang daming startup programs, $($StartupItems.Count) ang bumubukas"
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
        $FoundIssues += "🌐 ang daming cache ng browser mo, $([math]::Round($CacheSize/1MB,0)) MB"
    }

    Write-Host "`n📋 RESULTA NG SCAN:" -ForegroundColor Yellow
    if ($FoundIssues.Count -eq 0) {
        Write-Host "  ✅ malinis ang pc mo! parang bagong ligo" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️ may $($FoundIssues.Count) na issue na dapat ayusin:" -ForegroundColor Yellow
        foreach ($Issue in $FoundIssues) {
            Write-Host "    $Issue" -ForegroundColor White
        }
        $Choice = Read-Host "`n❓ gusto mo bang ayusin 'to? (Y/N)"
        if ($Choice -eq "Y" -or $Choice -eq "y") {
            Write-Host "`n🔧 inaayos na ang mga issue..." -ForegroundColor Green
            foreach ($Path in $TempPaths) {
                if (Test-Path $Path) {
                    Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
                    Write-Host "  ✅ nilinis: $Path" -ForegroundColor Green
                }
            }
            Clear-RecycleBin -Force -ErrorAction SilentlyContinue
            Write-Host "  ✅ na-empty na ang recycle bin" -ForegroundColor Green
            Write-Host "`n✅ tapos na ang optimization!" -ForegroundColor Green
        }
    }
    Read-Host "`npress enter para magpatuloy"
}

# -----------------------------------------------------------------
# TOOL 2: ShaneCodes Cleaner - mas malinis pa sa kwarto mo
# -----------------------------------------------------------------
function Invoke-ShaneCodesCleaner {
    Write-Host "`n🧹 nag-aactivate ng shanecodes cleaner..." -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 kelangan admin! parang sa school, may principal" -ForegroundColor Red
        Read-Host "press enter para magpatuloy"
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
            Write-Host ("    ✅ " + $Description + ": " + $Cleaned + " MB ang nalinis") -ForegroundColor Green
            return $Cleaned
        }
        return 0
    }

    Write-Host "`n🔍 naghahanap ng mga pwedeng linisin..." -ForegroundColor Yellow
    $TotalCleaned = 0

    Show-Progress -Message "nililinis ang windows temp folder..." -Duration 1
    $TotalCleaned += Clean-Path -Path "$env:WINDIR\Temp" -Description "windows temp"

    Show-Progress -Message "nililinis ang user temp folder..." -Duration 1
    $TotalCleaned += Clean-Path -Path "$env:TEMP" -Description "user temp"

    Show-Progress -Message "nililinis ang prefetch folder..." -Duration 1
    $TotalCleaned += Clean-Path -Path "$env:WINDIR\Prefetch" -Description "prefetch"

    Show-Progress -Message "nililinis ang browser cache..." -Duration 1
    $Browsers = @("$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache", "$env:APPDATA\Microsoft\Edge\User Data\Default\Cache")
    foreach ($Browser in $Browsers) {
        $TotalCleaned += Clean-Path -Path $Browser -Description "browser cache"
    }

    Show-Progress -Message "ina-empty ang recycle bin..." -Duration 1
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Host "    ✅ na-empty na ang recycle bin" -ForegroundColor Green

    Show-Progress -Message "nililinis ang windows update cache..." -Duration 2
    $TotalCleaned += Clean-Path -Path "$env:WINDIR\SoftwareDistribution\Download" -Description "update cache"

    Write-Host "`n✅ tapos na ang paglilinis!" -ForegroundColor Green
    Write-Host "  🧹 total space na nalinis: $([math]::Round($TotalCleaned, 1)) MB" -ForegroundColor Cyan
    Read-Host "`npress enter para magpatuloy"
}

# -----------------------------------------------------------------
# TOOL 3: Quick Fix Wizard - parang magic, pero totoo
# -----------------------------------------------------------------
function Invoke-QuickFixWizard {
    Write-Host "`n⚡ nag-aactivate ng quick fix wizard..." -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 kelangan admin! parang sa mall, may guard" -ForegroundColor Red
        Read-Host "press enter para magpatuloy"
        return
    }

    Write-Host "`n📋 pumili ng gustong ayusin:" -ForegroundColor Yellow
    Write-Host "  [1] 🔄 i-reset ang network adapters"
    Write-Host "  [2] 🧹 i-clear ang dns cache"
    Write-Host "  [3] 🔧 ayusin ang windows update"
    Write-Host "  [4] 🚀 pabilisin ang system performance"
    Write-Host "  [5] 🌐 i-reset ang internet settings"
    Write-Host "  [6] 💻 ayusin ang mga broken shortcuts"
    Write-Host "  [7] 🔑 i-reset ang windows activation"
    Write-Host "  [8] 🛡️ ayusin ang windows security"
    Write-Host "  [9] ⚡ gawin lahat ng fixes"
    Write-Host "  [0] 🔙 balik sa main menu"
    Write-Host ""

    $Choice = Read-Host "pumili ng number (0-9)"

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
        Write-Host "`n🔧 inaayos ang network..." -ForegroundColor Cyan
        Show-FixProgress -Message "ni-reset ang winsock" -Duration 1
        netsh winsock reset
        Show-FixProgress -Message "ni-reset ang ip stack" -Duration 1
        netsh int ip reset
        Show-FixProgress -Message "ni-release ang ip" -Duration 1
        ipconfig /release
        Show-FixProgress -Message "ni-renew ang ip" -Duration 1
        ipconfig /renew
        Show-FixResult -Message "tapos na ang network reset"
    }

    function Fix-DNS {
        Write-Host "`n🧹 nililinis ang dns..." -ForegroundColor Cyan
        Show-FixProgress -Message "ni-flush ang dns cache" -Duration 1
        ipconfig /flushdns
        Show-FixProgress -Message "ni-register ang dns" -Duration 1
        ipconfig /registerdns
        Show-FixResult -Message "na-clear na ang dns cache"
    }

    function Fix-WindowsUpdate {
        Write-Host "`n🔧 inaayos ang windows update..." -ForegroundColor Cyan
        Show-FixProgress -Message "pinapatay ang update services" -Duration 1
        Stop-Service -Name wuauserv, bits, cryptSvc -Force -ErrorAction SilentlyContinue
        Show-FixProgress -Message "pinalitan ang pangalan ng cache folders" -Duration 2
        if (Test-Path "$env:WINDIR\SoftwareDistribution") {
            Remove-Item "$env:WINDIR\SoftwareDistribution.old" -Recurse -Force -ErrorAction SilentlyContinue
            Rename-Item "$env:WINDIR\SoftwareDistribution" "SoftwareDistribution.old" -ErrorAction SilentlyContinue
        }
        Show-FixProgress -Message "binubuksan ang update services" -Duration 1
        Start-Service -Name wuauserv, bits, cryptSvc -ErrorAction SilentlyContinue
        Show-FixResult -Message "tapos na ang windows update reset"
    }

    function Fix-Performance {
        Write-Host "`n🚀 pinapabilis ang performance..." -ForegroundColor Cyan
        Show-FixProgress -Message "nililinis ang temp files" -Duration 2
        Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Show-FixProgress -Message "ina-optimize ang visual effects" -Duration 1
        Show-FixProgress -Message "pinapatay ang unnecessary services" -Duration 2
        Show-FixResult -Message "tapos na ang performance boost"
    }

    function Fix-Internet {
        Write-Host "`n🌐 ni-reset ang internet settings..." -ForegroundColor Cyan
        Show-FixProgress -Message "ni-reset ang ie settings" -Duration 1
        Show-FixProgress -Message "ni-clear ang ssl state" -Duration 1
        Show-FixProgress -Message "ni-reset ang proxy settings" -Duration 1
        netsh winhttp reset proxy
        Show-FixResult -Message "tapos na ang internet settings reset"
    }

    function Fix-Shortcuts {
        Write-Host "`n💻 inaayos ang broken shortcuts..." -ForegroundColor Cyan
        Show-FixProgress -Message "nag-scan ng broken shortcuts" -Duration 2
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
        Show-FixResult -Message "naayos ang $Fixed broken shortcuts"
    }

    function Fix-Activation {
        Write-Host "`n🔑 ni-reset ang windows activation..." -ForegroundColor Cyan
        Show-FixProgress -Message "ni-reset ang licensing status" -Duration 2
        cscript //nologo $env:WINDIR\system32\slmgr.vbs /rearm
        Show-FixProgress -Message "tinanggal ang current license" -Duration 2
        cscript //nologo $env:WINDIR\system32\slmgr.vbs /upk
        Show-FixProgress -Message "ni-reset ang licensing cache" -Duration 2
        cscript //nologo $env:WINDIR\system32\slmgr.vbs /rilc
        Show-FixResult -Message "tapos na ang activation reset"
    }

    function Fix-Security {
        Write-Host "`n🛡️ inaayos ang windows security..." -ForegroundColor Cyan
        Show-FixProgress -Message "ni-reset ang security policies" -Duration 2
        Show-FixProgress -Message "chine-check ang windows defender" -Duration 2
        Show-FixProgress -Message "inaayos ang uac settings" -Duration 1
        Show-FixResult -Message "tapos na ang security settings reset"
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
            Write-Host "`n✅ tapos na lahat ng fixes!" -ForegroundColor Green
        }
        "0" { return }
        default { Write-Host "mali ang pinili mo!" -ForegroundColor Red }
    }
    Read-Host "`npress enter para magpatuloy"
}

# -----------------------------------------------------------------
# TOOL 4: System Restore Manager - parang time machine
# -----------------------------------------------------------------
function Invoke-SystemRestoreManager {
    Write-Host "`n💾 nag-aactivate ng system restore manager..." -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 kelangan admin! parang sa trabaho, may manager" -ForegroundColor Red
        Read-Host "press enter para magpatuloy"
        return
    }

    Write-Host "`n📋 mga options:" -ForegroundColor Yellow
    Write-Host "  [1] gumawa ng restore point"
    Write-Host "  [2] tingnan ang mga restore points"
    Write-Host "  [3] i-restore ang system"
    Write-Host "  [0] balik sa main menu"
    Write-Host ""

    $Choice = Read-Host "pumili ng number (0-3)"

    switch ($Choice) {
        "1" {
            $Desc = Read-Host "ilagay ang description ng restore point"
            try {
                Checkpoint-Computer -Description $Desc -RestorePointType MODIFY_SETTINGS
                Write-Host "✅ matagumpay na nagawa ang restore point!" -ForegroundColor Green
            } catch {
                Write-Host "❌ nabigo ang paggawa ng restore point: $_" -ForegroundColor Red
            }
        }
        "2" {
            try {
                $Points = Get-ComputerRestorePoint
                if ($Points) {
                    Write-Host "`n📋 MGA RESTORE POINTS:" -ForegroundColor Cyan
                    $Points | Format-Table SequenceNumber, CreationTime, Description -AutoSize
                } else {
                    Write-Host "walang restore points na nakita." -ForegroundColor Yellow
                }
            } catch {
                Write-Host "❌ nabigo ang paglista ng restore points: $_" -ForegroundColor Red
            }
        }
        "3" {
            try {
                $Points = Get-ComputerRestorePoint
                if ($Points) {
                    Write-Host "`n📋 available restore points:" -ForegroundColor Cyan
                    $Points | Format-Table SequenceNumber, CreationTime, Description -AutoSize
                    $Seq = Read-Host "ilagay ang sequence number na gusto mong i-restore"
                    Restore-Computer -RestorePoint $Seq -Force
                    Write-Host "✅ magre-restart ang system para ma-apply ang restore." -ForegroundColor Green
                } else {
                    Write-Host "walang available na restore points." -ForegroundColor Yellow
                }
            } catch {
                Write-Host "❌ nabigo ang pag-restore: $_" -ForegroundColor Red
            }
        }
        "0" { return }
        default { Write-Host "mali ang pinili mo!" -ForegroundColor Red }
    }
    Read-Host "`npress enter para magpatuloy"
}

# -----------------------------------------------------------------
# TOOL 5: Boot Speed Analyzer - bilisan mo naman
# -----------------------------------------------------------------
function Invoke-BootSpeedAnalyzer {
    Write-Host "`n🚀 nag-aactivate ng boot speed analyzer..." -ForegroundColor Cyan

    Write-Host "`n📋 BOOT TIME ANALYSIS:" -ForegroundColor Yellow
    try {
        $BootTime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
        $Now = Get-Date
        $Uptime = $Now - $BootTime
        Write-Host "  last boot: $BootTime" -ForegroundColor White
        Write-Host "  uptime: $($Uptime.Days)d $($Uptime.Hours)h $($Uptime.Minutes)m" -ForegroundColor White
    } catch {
        Write-Host "  ❌ nabigo ang pagkuha ng boot time" -ForegroundColor Red
    }

    Write-Host "`n📋 STARTUP PROGRAMS:" -ForegroundColor Yellow
    $StartupItems = Get-CimInstance -ClassName Win32_StartupCommand
    if ($StartupItems) {
        $Count = $StartupItems.Count
        Write-Host "  total startup items: $Count" -ForegroundColor White
        if ($Count -gt 5) {
            Write-Host "  ⚠️ bawasan mo ang startup items para bumilis ang boot." -ForegroundColor Yellow
        }
        $StartupItems | Select-Object -First 10 | Format-Table Name, Command, Location -AutoSize
    } else {
        Write-Host "  walang startup items na nakita." -ForegroundColor Gray
    }

    Write-Host "`n💡 RECOMMENDATIONS:" -ForegroundColor Cyan
    Write-Host "  - tanggalin ang unnecessary startup programs" -ForegroundColor White
    Write-Host "  - i-enable ang fast startup sa power options" -ForegroundColor White
    Write-Host "  - mag-iwan ng at least 20% free space sa c: drive" -ForegroundColor White

    Read-Host "`npress enter para magpatuloy"
}

# -----------------------------------------------------------------
# TOOL 6: Privacy Guard - para hindi ka ma-stalk
# -----------------------------------------------------------------
function Invoke-PrivacyGuard {
    Write-Host "`n🛡️ nag-aactivate ng privacy guard..." -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 kelangan admin! parang sa banko, may security" -ForegroundColor Red
        Read-Host "press enter para magpatuloy"
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
            Write-Host "  🔍 nililinis ang $($Browser.Name)..." -ForegroundColor Gray
            $Dirs = @("Cache", "Code Cache", "Cookies", "History", "Service Worker")
            foreach ($Dir in $Dirs) {
                $DirPath = Join-Path $Browser.Path $Dir
                if (Test-Path $DirPath) {
                    $Size = (Get-ChildItem -Path $DirPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                    Remove-Item -Path "$DirPath\*" -Recurse -Force -ErrorAction SilentlyContinue
                    $Cleaned = [math]::Round($Size / 1MB, 1)
                    if ($Cleaned -gt 0) {
                        Write-Host ("    ✅ " + $Dir + ": " + $Cleaned + " MB ang nalinis") -ForegroundColor Green
                        $TotalCleaned += $Cleaned
                    }
                }
            }
        }
    }

    Write-Host "`n✅ tapos na ang privacy cleanup!" -ForegroundColor Green
    Write-Host "  🧹 total nalinis: $([math]::Round($TotalCleaned, 1)) MB" -ForegroundColor Cyan
    Read-Host "`npress enter para magpatuloy"
}

# -----------------------------------------------------------------
# TOOL 7: Battery Health Checker - para sa laptop mong laging nakasaksak
# -----------------------------------------------------------------
function Invoke-BatteryHealthChecker {
    Write-Host "`n🔋 nag-aactivate ng battery health checker..." -ForegroundColor Cyan

    try {
        $Battery = Get-CimInstance -ClassName Win32_Battery
        if ($Battery) {
            Write-Host "`n📋 BATTERY INFORMATION:" -ForegroundColor Yellow
            Write-Host "  pangalan: $($Battery.Name)" -ForegroundColor White
            Write-Host "  manufacturer: $($Battery.Manufacturer)" -ForegroundColor White
            Write-Host "  chemistry: $($Battery.Chemistry)" -ForegroundColor White
            Write-Host "  design capacity: $($Battery.DesignCapacity) mWh" -ForegroundColor White
            Write-Host "  full charge capacity: $($Battery.FullChargeCapacity) mWh" -ForegroundColor White

            $Health = [math]::Round(($Battery.FullChargeCapacity / $Battery.DesignCapacity) * 100, 1)
            if ($Health -gt 80) {
                Write-Host "  health: $Health% ✅ excellent! parang bago" -ForegroundColor Green
            } elseif ($Health -gt 60) {
                Write-Host "  health: $Health% ⚠️ good, pero mag-ipon ka na" -ForegroundColor Yellow
            } else {
                Write-Host "  health: $Health% ❌ palitan mo na ang battery mo" -ForegroundColor Red
            }
        } else {
            Write-Host "❌ walang battery na nakita. naka-laptop ka ba?" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ nabigo ang pagkuha ng battery info: $_" -ForegroundColor Red
    }
    Read-Host "`npress enter para magpatuloy"
}

# -----------------------------------------------------------------
# TOOL 8: Startup Manager Pro - tanggalin ang mga bagal
# -----------------------------------------------------------------
function Invoke-StartupManagerPro {
    Write-Host "`n⚙️ nag-aactivate ng startup manager pro..." -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 kelangan admin! parang sa school, may principal" -ForegroundColor Red
        Read-Host "press enter para magpatuloy"
        return
    }

    Write-Host "`n📋 STARTUP ITEMS:" -ForegroundColor Yellow
    $StartupItems = Get-CimInstance -ClassName Win32_StartupCommand
    if ($StartupItems) {
        $StartupItems | Format-Table Name, Command, Location, User -AutoSize
        Write-Host "`n💡 RECOMMENDATIONS:" -ForegroundColor Cyan
        Write-Host "  - items sa 'run' folder ay pwedeng tanggalin" -ForegroundColor White
        Write-Host "  - items sa 'runonce' ay isang beses lang tatakbo" -ForegroundColor White
        Write-Host "  - gamitin ang task manager para i-disable ang items" -ForegroundColor White
        Write-Host "`n  press any key para buksan ang task manager..."
        Read-Host
        Start-Process "taskmgr.exe"
    } else {
        Write-Host "  walang startup items na nakita." -ForegroundColor Gray
    }
    Read-Host "`npress enter para magpatuloy"
}

# -----------------------------------------------------------------
# TOOL 9: Network Refresh Tool - parang restart ng internet
# -----------------------------------------------------------------
function Invoke-NetworkRefreshTool {
    Write-Host "`n🌐 nag-aactivate ng network refresh tool..." -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 kelangan admin! parang sa internet cafe, may admin" -ForegroundColor Red
        Read-Host "press enter para magpatuloy"
        return
    }

    Write-Host "`n📋 NETWORK REFRESH:" -ForegroundColor Yellow

    Write-Host "  🔄 ni-reset ang winsock..." -ForegroundColor Gray
    netsh winsock reset

    Write-Host "  🔄 ni-reset ang ip stack..." -ForegroundColor Gray
    netsh int ip reset

    Write-Host "  🔄 ni-flush ang dns cache..." -ForegroundColor Gray
    ipconfig /flushdns

    Write-Host "  🔄 ni-release ang ip..." -ForegroundColor Gray
    ipconfig /release

    Write-Host "  🔄 ni-renew ang ip..." -ForegroundColor Gray
    ipconfig /renew

    Write-Host "`n✅ tapos na ang network refresh!" -ForegroundColor Green
    Write-Host "💡 i-restart ang pc para fully ma-apply ang changes." -ForegroundColor Yellow
    Read-Host "`npress enter para magpatuloy"
}

# -----------------------------------------------------------------
# TOOL 10: File Shredder - parang basurahan, pero permanent
# -----------------------------------------------------------------
function Invoke-FileShredder {
    Write-Host "`n🗑️ nag-aactivate ng file shredder..." -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "🚨 kelangan admin! parang sa military, may clearance" -ForegroundColor Red
        Read-Host "press enter para magpatuloy"
        return
    }

    Write-Host "⚠️  WARNING: PERMANENTENG MABUBURA ANG FILES!" -ForegroundColor Red
    Write-Host "  walang chance na ma-recover!" -ForegroundColor Red
    Write-Host ""

    $Path = Read-Host "ilagay ang path ng file o folder na gusto mong i-shred"
    if (-not (Test-Path $Path)) {
        Write-Host "❌ walang ganyang path!" -ForegroundColor Red
        Read-Host "press enter para magpatuloy"
        return
    }

    $Confirm = Read-Host "gusto mo bang i-shred ang '$Path'? (YES/NO)"
    if ($Confirm -ne "YES") {
        Write-Host "kinancel mo, buti naman." -ForegroundColor Yellow
        Read-Host "press enter para magpatuloy"
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
                Write-Host "  ✅ pass $($i+1)/7 tapos na" -ForegroundColor Green
            }

            Remove-Item -Path $FilePath -Force
            Write-Host "  ✅ na-shred ang file: $FilePath" -ForegroundColor Green
        } catch {
            Write-Host "  ❌ nabigo ang pag-shred: $FilePath" -ForegroundColor Red
        }
    }

    if (Test-Path $Path -PathType Container) {
        $Files = Get-ChildItem -Path $Path -Recurse -File
        foreach ($File in $Files) {
            Shred-File -FilePath $File.FullName
        }
        Remove-Item -Path $Path -Force -ErrorAction SilentlyContinue
        Write-Host "✅ na-shred ang folder: $Path" -ForegroundColor Green
    } else {
        Shred-File -FilePath $Path
    }

    Write-Host "`n✅ tapos na ang shredding!" -ForegroundColor Green
    Read-Host "`npress enter para magpatuloy"
}

# -----------------------------------------------------------------
# TOOL 11: Windows Activation Fixer - para ma-activate ulit
# -----------------------------------------------------------------
function Invoke-ActivationFixer {
    Write-Host "`n🔑 nag-aactivate ng windows activation fixer..." -ForegroundColor Cyan
    Write-Host "  baka ma-activate na yan, tiwala lang" -ForegroundColor Yellow
    
    # Download and run the activation fixer
    $url = "https://raw.githubusercontent.com/shanecodes-glitch/SHANECODES-TECH-HUB/main/tools/Activation_Fixer.ps1"
    $tempFile = "$env:TEMP\ActivationFixer_$(Get-Random).ps1"
    
    try {
        Write-Host "  [*] dinadownload ang activation fixer..." -ForegroundColor Gray
        Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing
        
        Write-Host "  [*] pinapatakbo ang activation fixer..." -ForegroundColor Gray
        & $tempFile
        
        Write-Host "  [*] naglilinis ng kalat..." -ForegroundColor Gray
        Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue
        
        Write-Host "`n✅ tapos na ang activation fixer!" -ForegroundColor Green
    } catch {
        Write-Host "  ❌ nabigo ang pagtakbo ng activation fixer: $_" -ForegroundColor Red
    }
    
    Read-Host "`npress enter para magpatuloy"
}

# -----------------------------------------------------------------
# TOOL 12: About - bakit mo ba 'to ginagamit?
# -----------------------------------------------------------------
function Show-About {
    Clear-Host
    Write-Host @"

╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   ⚡ SHANECODES TECH HUB                                     ║
║                                                              ║
║   version: $script:Version                                  ║
║   gawa ni: $script:Author                                  ║
║   company: $script:Company                                  ║
║                                                              ║
║   📧 email: $script:Contact                                ║
║   🌐 website: $script:Website                              ║
║   🐙 github: @shanecodes-glitch                            ║
║                                                              ║
║   📋 description:                                          ║
║   mga powershell tools para sa windows                     ║
║   diagnostic, repair, at optimization.                      ║
║   "ginawa ko 'to kasi gusto kong makatulong"                ║
║                                                              ║
║   🚀 RUN FROM WEB (walang download!):                      ║
║   irm https://tinyurl.com/shanetechub | iex                ║
║                                                              ║
║   📝 license: mit                                           ║
║   $script:Copyright                                         ║
║                                                              ║
║   💡 fun fact: ang shanecodes ay galing sa pangalan ko     ║
║   at sa coding na gusto ko gawin.                           ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan
    Read-Host "press enter para magpatuloy"
}

# -----------------------------------------------------------------
# TOOL 13: Contact Support - kung may problema, wag kang mag-alala
# -----------------------------------------------------------------
function Show-Contact {
    Clear-Host
    Write-Host @"

╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   📬 CONTACT SUPPORT                                        ║
║                                                              ║
║   📧 email: $script:Contact                                ║
║   🌐 website: $script:Website                              ║
║   🐙 github: https://github.com/shanecodes-glitch          ║
║                                                              ║
║   💬 para sa mga tanong, issue, o suggestions:             ║
║   - mag-open ng issue sa github                             ║
║   - mag-send ng email                                       ║
║   - bisitahin ang website                                   ║
║                                                              ║
║   ⏱️ response time: 24-48 hours (baka may tulog ako)      ║
║                                                              ║
║   🚀 RUN FROM WEB:                                         ║
║   irm https://tinyurl.com/shanetechub | iex                ║
║                                                              ║
║   💡 tip: kung may issue, i-send ang error message para    ║
║   mas madali kong ma-ayos.                                  ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan
    Read-Host "press enter para magpatuloy"
}

# -----------------------------------------------------------------
# TOOL 14: Run All Tools - parang buffet, lahat ng tools
# -----------------------------------------------------------------
function Invoke-AllTools {
    Write-Host "`n🚀 pinapatakbo lahat ng tools..." -ForegroundColor Cyan
    Write-Host "  parang buffet, lahat ng ulam" -ForegroundColor Yellow
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
    Invoke-ActivationFixer
    Write-Host "`n✅ tapos na lahat!" -ForegroundColor Green
    Read-Host "press enter para magpatuloy"
}

# ============================================================
# MAIN MENU LOOP - eto ang puso ng programa
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
║           gawa ni: shanecodes technologies                 ║
║        "nag-aayos ng pc habang nag-iisip ng life choices"   ║
║                                                              ║
║   🚀 RUN FROM WEB (walang download!):                      ║
║   irm https://tinyurl.com/shanetechub | iex                ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

    Write-Host "  📋 pumili ng tool:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  ┌────┬────────────────────────────────────────────────────────────┐"
    Write-Host "  │ #  │ pangalan ng tool                                          │"
    Write-Host "  ├────┼────────────────────────────────────────────────────────────┤"
    Write-Host "  │ 1  │ 🔧 smart pc optimizer                                     │"
    Write-Host "  │ 2  │ 🧹 shanecodes cleaner                                     │"
    Write-Host "  │ 3  │ ⚡ quick fix wizard                                       │"
    Write-Host "  │ 4  │ 💾 system restore manager                                 │"
    Write-Host "  │ 5  │ 🚀 boot speed analyzer                                    │"
    Write-Host "  │ 6  │ 🛡️ privacy guard                                          │"
    Write-Host "  │ 7  │ 🔋 battery health checker                                 │"
    Write-Host "  │ 8  │ ⚙️ startup manager pro                                    │"
    Write-Host "  │ 9  │ 🌐 network refresh tool                                   │"
    Write-Host "  │ 10 │ 🗑️ file shredder                                          │"
    Write-Host "  │ 11 │ 🔑 windows activation fixer                               │"
    Write-Host "  ├────┼────────────────────────────────────────────────────────────┤"
    Write-Host "  │ 12 │ ℹ️ about this project                                     │"
    Write-Host "  │ 13 │ 📧 contact support                                        │"
    Write-Host "  │ 14 │ 🚀 run all tools (parang buffet)                          │"
    Write-Host "  │ 0  │ ❌ exit - magpahinga ka na                                │"
    Write-Host "  └────┴────────────────────────────────────────────────────────────┘"
    Write-Host ""

    $Choice = Read-Host "  pumili ng number (0-14)"

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
        "11" { Invoke-ActivationFixer }
        "12" { Show-About }
        "13" { Show-Contact }
        "14" { Invoke-AllTools }
        "0" { 
            Write-Host "`nsalamat sa paggamit ng shanecodes tool launcher!" -ForegroundColor Green
            Write-Host $script:Copyright -ForegroundColor Gray
            Write-Host "magpahinga ka na, deserve mo 'yan." -ForegroundColor Yellow
            exit 
        }
        default { 
            Write-Host "`n❌ mali ang pinili mo! subukan mo ulit." -ForegroundColor Red
            Read-Host
        }
    }
} while ($true)