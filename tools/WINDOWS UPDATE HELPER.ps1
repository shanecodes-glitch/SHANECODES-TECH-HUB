# ============================================================
# WINDOWS UPDATE HELPER v2.0
# ============================================================
# Checks and installs Windows updates
# ============================================================

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: Administrator privileges required!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "      WINDOWS UPDATE HELPER v2.0" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()

Write-Host "Checking for updates..." -ForegroundColor Yellow
$SearchResult = $UpdateSearcher.Search("IsInstalled=0")

if ($SearchResult.Updates.Count -eq 0) {
    Write-Host "No pending updates found." -ForegroundColor Green
    Read-Host "`nPress Enter to exit"
    exit
}

Write-Host "Found $($SearchResult.Updates.Count) pending updates:" -ForegroundColor Cyan
Write-Host ""

$i = 1
foreach ($Update in $SearchResult.Updates) {
    Write-Host "  $i. $($Update.Title)" -ForegroundColor White
    Write-Host "     Size: $([math]::Round($Update.MaxDownloadSize / 1MB, 2)) MB" -ForegroundColor Gray
    Write-Host "     Type: $($Update.UpdateType)" -ForegroundColor Gray
    $i++
}

Write-Host "`n[OPTIONS]" -ForegroundColor Yellow
Write-Host "  1. Download and install all updates"
Write-Host "  2. View update details"
Write-Host "  3. Cancel"
Write-Host ""

$Choice = Read-Host "Select option (1-3)"

switch ($Choice) {
    "1" {
        Write-Host "`nDownloading and installing updates..." -ForegroundColor Yellow
        
        $Downloader = $UpdateSession.CreateUpdateDownloader()
        $Downloader.Updates = $SearchResult.Updates
        $DownloadResult = $Downloader.Download()
        
        if ($DownloadResult.ResultCode -eq 2) {
            $Installer = $UpdateSession.CreateUpdateInstaller()
            $Installer.Updates = $SearchResult.Updates
            $InstallResult = $Installer.Install()
            
            if ($InstallResult.ResultCode -eq 2) {
                Write-Host "Updates installed successfully!" -ForegroundColor Green
                Write-Host "Installed: $($InstallResult.InstalledCount)" -ForegroundColor Green
                Write-Host "`n[!] Restart required to complete installation." -ForegroundColor Yellow
                
                $Restart = Read-Host "Restart now? (Y/N)"
                if ($Restart -eq "Y" -or $Restart -eq "y") {
                    Restart-Computer -Force
                }
            } else {
                Write-Host "Installation failed." -ForegroundColor Red
            }
        } else {
            Write-Host "Download failed." -ForegroundColor Red
        }
    }
    "2" {
        Write-Host "`n[UPDATE DETAILS]" -ForegroundColor Cyan
        $SearchResult.Updates | Format-Table Title, MaxDownloadSize, UpdateType, IsHidden -AutoSize
        Read-Host "`nPress Enter to continue"
    }
    "3" {
        Write-Host "Cancelled." -ForegroundColor Gray
    }
    default {
        Write-Host "Invalid option." -ForegroundColor Red
    }
}