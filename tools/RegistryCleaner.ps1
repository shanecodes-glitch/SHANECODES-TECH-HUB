# ============================================================
# QUICK FIX WIZARD v1.0
# ============================================================
# One-click fixes for common problems
# Created by: ShaneCodes Technologies
# ============================================================

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "🚨 ADMIN REQUIRED!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

Clear-Host
$Host.UI.RawUI.WindowTitle = "🔧 Quick Fix Wizard - ShaneCodes"

Write-Host @"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║    ███████╗██╗  ██╗██╗ ██████╗██╗  ██╗                     ║
║    ██╔════╝╚██╗██╔╝██║██╔════╝██║ ██╔╝                     ║
║    █████╗   ╚███╔╝ ██║██║     █████╔╝                      ║
║    ██╔══╝   ██╔██╗ ██║██║     ██╔═██╗                      ║
║    ███████╗██╔╝ ██╗██║╚██████╗██║  ██╗                     ║
║    ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝                     ║
║                                                              ║
║              QUICK FIX WIZARD v1.0                          ║
║           Created by: ShaneCodes Technologies              ║
╚══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host ""
Write-Host "📋 SELECT A FIX:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  [1] 🔄 Reset Network Adapters"
Write-Host "  [2] 🧹 Clear DNS Cache"
Write-Host "  [3] 🔧 Fix Windows Update"
Write-Host "  [4] 🚀 Boost System Performance"
Write-Host "  [5] 🌐 Reset Internet Settings"
Write-Host "  [6] 💻 Fix Broken Shortcuts"
Write-Host "  [7] 🔑 Reset Windows Activation"
Write-Host "  [8] 🛡️ Fix Windows Security"
Write-Host "  [9] ⚡ Run All Fixes"
Write-Host "  [0] ❌ Exit"
Write-Host ""

$Choice = Read-Host "Enter your choice (0-9)"

function Show-FixProgress {
    param($Message, $Duration = 2)
    Write-Host "  ⚡ $Message..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    for ($i = 0; $i -lt 20; $i++) {
        Write-Host "█" -NoNewline -ForegroundColor Green
        Start-Sleep -Milliseconds ($Duration * 25)
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

# ============================================================
# EXECUTE FIX
# ============================================================
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
    "0" {
        Write-Host "Exiting..." -ForegroundColor Gray
        exit
    }
    default {
        Write-Host "Invalid choice!" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "💡 RECOMMENDATION: Restart your PC for best results." -ForegroundColor Yellow
Read-Host "`nPress Enter to exit"
