# ============================================================
# WINDOWS REPAIR TOOL v3.0
# ============================================================
# Automatically fixes common Windows issues
# ============================================================

# Check for admin rights
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: Administrator privileges required!" -ForegroundColor Red
    Write-Host "Please run as Administrator." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       WINDOWS REPAIR TOOL v3.0" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$LogFile = "WindowsRepair_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "HH:mm:ss"
    $entry = "[$timestamp] $Message"
    Write-Host $entry -ForegroundColor Green
    Add-Content -Path $LogFile -Value $entry
}

Write-Log "Starting Windows Repair..."

# ============================================================
# 1. DISM
# ============================================================
Write-Log "`n[1/5] Running DISM..." -ForegroundColor Yellow
Write-Log "DISM /Online /Cleanup-Image /RestoreHealth"
try {
    $result = DISM /Online /Cleanup-Image /RestoreHealth
    if ($LASTEXITCODE -eq 0) {
        Write-Log "[OK] DISM completed successfully" -ForegroundColor Green
    } else {
        Write-Log "[WARNING] DISM had issues, continuing..." -ForegroundColor Yellow
    }
} catch {
    Write-Log "[ERROR] DISM failed: $_" -ForegroundColor Red
}

# ============================================================
# 2. SFC
# ============================================================
Write-Log "`n[2/5] Running SFC /SCANNOW..." -ForegroundColor Yellow
try {
    $result = sfc /scannow
    if ($LASTEXITCODE -eq 0) {
        Write-Log "[OK] SFC completed successfully" -ForegroundColor Green
    } else {
        Write-Log "[WARNING] SFC found issues, continuing..." -ForegroundColor Yellow
    }
} catch {
    Write-Log "[ERROR] SFC failed: $_" -ForegroundColor Red
}

# ============================================================
# 3. Check Disk
# ============================================================
Write-Log "`n[3/5] Running CHKDSK..." -ForegroundColor Yellow
try {
    $result = chkdsk /f /r
    if ($LASTEXITCODE -eq 0) {
        Write-Log "[OK] CHKDSK completed successfully" -ForegroundColor Green
    } else {
        Write-Log "[WARNING] CHKDSK found issues, continuing..." -ForegroundColor Yellow
    }
} catch {
    Write-Log "[ERROR] CHKDSK failed: $_" -ForegroundColor Red
}

# ============================================================
# 4. Windows Update Reset
# ============================================================
Write-Log "`n[4/5] Resetting Windows Update..." -ForegroundColor Yellow
try {
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Stop-Service -Name bits -Force -ErrorAction SilentlyContinue
    Stop-Service -Name cryptSvc -Force -ErrorAction SilentlyContinue
    
    # Rename SoftwareDistribution
    if (Test-Path "C:\Windows\SoftwareDistribution") {
        Remove-Item "C:\Windows\SoftwareDistribution.old" -Recurse -Force -ErrorAction SilentlyContinue
        Rename-Item "C:\Windows\SoftwareDistribution" "SoftwareDistribution.old" -ErrorAction SilentlyContinue
        Write-Log "[OK] SoftwareDistribution reset" -ForegroundColor Green
    }
    
    Start-Service -Name wuauserv -ErrorAction SilentlyContinue
    Start-Service -Name bits -ErrorAction SilentlyContinue
    Start-Service -Name cryptSvc -ErrorAction SilentlyContinue
    Write-Log "[OK] Windows Update services reset" -ForegroundColor Green
} catch {
    Write-Log "[WARNING] Update reset had issues: $_" -ForegroundColor Yellow
}

# ============================================================
# 5. System Cleanup
# ============================================================
Write-Log "`n[5/5] Cleaning temporary files..." -ForegroundColor Yellow
$TempPaths = @(
    "$env:WINDIR\Temp",
    "$env:TEMP",
    "C:\Windows\Prefetch",
    "$env:APPDATA\Local\Temp"
)
$Cleaned = 0
foreach ($Path in $TempPaths) {
    if (Test-Path $Path) {
        try {
            $Files = Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue
            $Count = $Files.Count
            Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
            $Cleaned += $Count
            Write-Log "[OK] Cleaned $Path ($Count files)" -ForegroundColor Green
        } catch {
            Write-Log "[WARNING] Could not clean $Path" -ForegroundColor Yellow
        }
    }
}
Write-Log "[OK] Total files cleaned: $Cleaned" -ForegroundColor Green

# ============================================================
# Summary
# ============================================================
Write-Log "`n========================================"
Write-Log "REPAIR COMPLETED" -ForegroundColor Green
Write-Log "Log saved to: $LogFile" -ForegroundColor Cyan
Write-Log "========================================"

Write-Host "`n[✓] All repairs completed!" -ForegroundColor Green
Write-Host "[!] Restart recommended for best results." -ForegroundColor Yellow
Read-Host "`nPress Enter to exit"
