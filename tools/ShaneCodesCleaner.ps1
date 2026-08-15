# ============================================================
# SHANECODES CLEANER v1.0
# ============================================================
# Deep clean with animated progress bar
# Created by: ShaneCodes Technologies
# ============================================================

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "🚨 ADMIN REQUIRED!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

Clear-Host
$Host.UI.RawUI.WindowTitle = "🧹 ShaneCodes Cleaner - Professional"
Write-Host @"

    ███████╗██╗  ██╗ █████╗ ███╗   ██╗███████╗ ██████╗ ██████╗ ██████╗ ███████╗
    ██╔════╝██║  ██║██╔══██╗████╗  ██║██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ███████╗███████║███████║██╔██╗ ██║█████╗  ██║     ██║   ██║██████╔╝███████╗
    ╚════██║██╔══██║██╔══██║██║╚██╗██║██╔══╝  ██║     ██║   ██║██╔══██╗╚════██║
    ███████║██║  ██║██║  ██║██║ ╚████║███████╗╚██████╗╚██████╔╝██║  ██║███████║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
    
"@ -ForegroundColor Cyan

Write-Host "                    🧹 DEEP CLEANER v1.0" -ForegroundColor Yellow
Write-Host ""

# ============================================================
# ANIMATED PROGRESS
# ============================================================
function Show-Progress {
    param($Message, $Duration = 2)
    
    Write-Host "  $Message" -ForegroundColor White
    Write-Host "  " -NoNewline
    
    $Chars = @('▓', '▒', '░')
    $Colors = @('Red', 'Yellow', 'Green', 'Cyan', 'Magenta')
    
    for ($i = 0; $i -lt 40; $i++) {
        $Color = $Colors[$i % $Colors.Length]
        $Char = $Chars[$i % $Chars.Length]
        Write-Host $Char -NoNewline -ForegroundColor $Color
        Start-Sleep -Milliseconds ($Duration * 20)
    }
    Write-Host " ✓" -ForegroundColor Green
}

# ============================================================
# CLEANING FUNCTION
# ============================================================
function Clean-Path {
    param($Path, $Description)
    
    if (Test-Path $Path) {
        $Before = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | 
                   Measure-Object -Property Length -Sum).Sum
        Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
        $After = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | 
                  Measure-Object -Property Length -Sum).Sum
        $Cleaned = [math]::Round(($Before - $After) / 1MB, 1)
        Write-Host "    ✅ $Description: $Cleaned MB cleaned" -ForegroundColor Green
        return $Cleaned
    }
    return 0
}

# ============================================================
# MAIN CLEANING PROCESS
# ============================================================
Write-Host "🔍 SCANNING FOR CLEANABLE FILES..." -ForegroundColor Yellow
Write-Host ""

$TotalCleaned = 0

# 1. Windows Temp
Show-Progress -Message "Cleaning Windows Temp folder..." -Duration 1
$TotalCleaned += Clean-Path -Path "$env:WINDIR\Temp" -Description "Windows Temp"

# 2. User Temp
Show-Progress -Message "Cleaning User Temp folder..." -Duration 1
$TotalCleaned += Clean-Path -Path "$env:TEMP" -Description "User Temp"

# 3. Prefetch
Show-Progress -Message "Cleaning Prefetch folder..." -Duration 1
$TotalCleaned += Clean-Path -Path "$env:WINDIR\Prefetch" -Description "Prefetch"

# 4. Browser Cache
Show-Progress -Message "Cleaning browser cache..." -Duration 1
$Browsers = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache",
    "$env:APPDATA\Microsoft\Edge\User Data\Default\Cache",
    "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*\cache2"
)
foreach ($Browser in $Browsers) {
    $TotalCleaned += Clean-Path -Path $Browser -Description "Browser cache"
}

# 5. Recycle Bin
Show-Progress -Message "Emptying Recycle Bin..." -Duration 1
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Host "    ✅ Recycle Bin emptied" -ForegroundColor Green

# 6. Windows Update Cache
Show-Progress -Message "Cleaning Windows Update cache..." -Duration 2
$TotalCleaned += Clean-Path -Path "$env:WINDIR\SoftwareDistribution\Download" -Description "Update cache"

# ============================================================
# RESULTS
# ============================================================
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                     CLEANING COMPLETE!                      ║" -ForegroundColor Cyan
Write-Host "╠══════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
Write-Host "║  🧹 Total space cleaned: $([math]::Round($TotalCleaned, 1)) MB           ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Read-Host "`nPress Enter to exit"
