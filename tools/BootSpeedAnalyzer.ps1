# ============================================================
# SHANECODES - BOOT SPEED ANALYZER v1.0
# ============================================================
# Measures boot time and provides optimization recommendations
# Created by: Shane Nichael Obinguar (ShaneCodes)
# ============================================================
# (c) 2024-2025 ShaneCodes Technologies. All rights reserved.
# ============================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "ShaneCodes - Boot Speed Analyzer v1.0"

# ============================================================
# ADMIN CHECK
# ============================================================
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host ""
    Write-Host "[ERROR] Administrator privileges required!" -ForegroundColor Red
    Write-Host "Some features may not work without admin rights." -ForegroundColor Yellow
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
                                                              
         BOOT SPEED ANALYZER v1.0                         
           Created by: ShaneCodes Technologies              
        "Speed Up Your Startup!"                            
                                                              
============================================================

"@ -ForegroundColor Cyan

# ============================================================
# FUNCTION: GET BOOT TIME
# ============================================================
function Get-BootTime {
    Write-Host ""
    Write-Host "[+] BOOT TIME ANALYSIS" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        # Get last boot time
        $BootTime = (Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction SilentlyContinue).LastBootUpTime
        $Now = Get-Date
        $Uptime = $Now - $BootTime
        
        Write-Host ""
        Write-Host "  Last Boot: $BootTime" -ForegroundColor White
        Write-Host "  Uptime: $($Uptime.Days)d $($Uptime.Hours)h $($Uptime.Minutes)m $($Uptime.Seconds)s" -ForegroundColor White
        
        # Calculate boot time estimate
        $BootSeconds = $Uptime.TotalSeconds
        if ($BootSeconds -lt 60) {
            $BootTimeDisplay = "$([math]::Round($BootSeconds, 1)) seconds"
            $Rating = "Excellent"
            $Color = "Green"
        } elseif ($BootSeconds -lt 120) {
            $BootTimeDisplay = "$([math]::Round($BootSeconds, 1)) seconds"
            $Rating = "Good"
            $Color = "Green"
        } elseif ($BootSeconds -lt 180) {
            $BootTimeDisplay = "$([math]::Round($BootSeconds, 1)) seconds"
            $Rating = "Fair"
            $Color = "Yellow"
        } elseif ($BootSeconds -lt 300) {
            $BootTimeDisplay = "$([math]::Round($BootSeconds, 1)) seconds"
            $Rating = "Slow"
            $Color = "Yellow"
        } else {
            $BootTimeDisplay = "$([math]::Round($BootSeconds, 1)) seconds"
            $Rating = "Very Slow"
            $Color = "Red"
        }
        
        Write-Host ""
        Write-Host "  Boot Time: $BootTimeDisplay" -ForegroundColor $Color
        Write-Host "  Rating: $Rating" -ForegroundColor $Color
        
        return @{
            BootTime = $BootTime
            Uptime = $Uptime
            Rating = $Rating
            Seconds = $BootSeconds
        }
    } catch {
        Write-Host ""
        Write-Host "  [FAIL] Failed to get boot time!" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Red
        return $null
    }
}

# ============================================================
# FUNCTION: ANALYZE STARTUP PROGRAMS
# ============================================================
function Analyze-Startup {
    Write-Host ""
    Write-Host "[+] STARTUP PROGRAMS ANALYSIS" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        $StartupItems = Get-CimInstance -ClassName Win32_StartupCommand -ErrorAction SilentlyContinue
        
        if ($StartupItems -and $StartupItems.Count -gt 0) {
            $Count = $StartupItems.Count
            Write-Host ""
            Write-Host "  Total startup items: $Count" -ForegroundColor White
            
            if ($Count -gt 10) {
                Write-Host "  [WARNING] Too many startup items!" -ForegroundColor Red
                Write-Host "  Consider disabling unnecessary programs." -ForegroundColor Yellow
            } elseif ($Count -gt 5) {
                Write-Host "  [INFO] Moderate number of startup items." -ForegroundColor Yellow
                Write-Host "  You can still optimize for faster boot." -ForegroundColor Gray
            } else {
                Write-Host "  [OK] Low number of startup items." -ForegroundColor Green
            }
            
            Write-Host ""
            Write-Host "  Top startup items:" -ForegroundColor Cyan
            $StartupItems | Select-Object -First 5 | Format-Table Name, Command, Location -AutoSize
            
            if ($Count -gt 5) {
                Write-Host "  ... and $($Count - 5) more items" -ForegroundColor Gray
            }
        } else {
            Write-Host ""
            Write-Host "  No startup items found." -ForegroundColor Gray
        }
    } catch {
        Write-Host ""
        Write-Host "  [FAIL] Failed to analyze startup!" -ForegroundColor Red
    }
}

# ============================================================
# FUNCTION: CHECK DISK HEALTH
# ============================================================
function Check-DiskHealth {
    Write-Host ""
    Write-Host "[+] DISK HEALTH CHECK" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        $Disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" -ErrorAction SilentlyContinue
        
        if ($Disk) {
            $TotalGB = [math]::Round($Disk.Size / 1GB, 2)
            $FreeGB = [math]::Round($Disk.FreeSpace / 1GB, 2)
            $UsedGB = $TotalGB - $FreeGB
            $UsedPercent = [math]::Round(($UsedGB / $TotalGB) * 100, 1)
            
            Write-Host ""
            Write-Host "  C: Drive Space:" -ForegroundColor White
            Write-Host "  Total: $TotalGB GB" -ForegroundColor White
            Write-Host "  Used: $UsedGB GB ($UsedPercent%)" -ForegroundColor White
            Write-Host "  Free: $FreeGB GB" -ForegroundColor White
            
            if ($FreeGB -lt 20) {
                Write-Host "  [WARNING] Low disk space! ($FreeGB GB free)" -ForegroundColor Red
                Write-Host "  Consider freeing up space for better performance." -ForegroundColor Yellow
            } elseif ($FreeGB -lt 50) {
                Write-Host "  [INFO] Moderate disk space available." -ForegroundColor Yellow
            } else {
                Write-Host "  [OK] Ample disk space available." -ForegroundColor Green
            }
        } else {
            Write-Host ""
            Write-Host "  [FAIL] Failed to check disk health!" -ForegroundColor Red
        }
    } catch {
        Write-Host ""
        Write-Host "  [FAIL] Failed to check disk health!" -ForegroundColor Red
    }
}

# ============================================================
# FUNCTION: CHECK FAST STARTUP
# ============================================================
function Check-FastStartup {
    Write-Host ""
    Write-Host "[+] FAST STARTUP STATUS" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        $FastStartup = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -ErrorAction SilentlyContinue
        
        Write-Host ""
        if ($FastStartup -and $FastStartup.HiberbootEnabled -eq 1) {
            Write-Host "  [OK] Fast Startup is ENABLED" -ForegroundColor Green
            Write-Host "  This helps reduce boot time." -ForegroundColor Gray
        } else {
            Write-Host "  [INFO] Fast Startup is DISABLED" -ForegroundColor Yellow
            Write-Host "  Enabling Fast Startup can improve boot time." -ForegroundColor Gray
            Write-Host ""
            Write-Host "  To enable Fast Startup:" -ForegroundColor Cyan
            Write-Host "  1. Open Control Panel" -ForegroundColor White
            Write-Host "  2. Go to Power Options" -ForegroundColor White
            Write-Host "  3. Click 'Choose what the power buttons do'" -ForegroundColor White
            Write-Host "  4. Click 'Change settings that are currently unavailable'" -ForegroundColor White
            Write-Host "  5. Check 'Turn on fast startup'" -ForegroundColor White
        }
    } catch {
        Write-Host ""
        Write-Host "  [INFO] Unable to check Fast Startup status." -ForegroundColor Yellow
    }
}

# ============================================================
# FUNCTION: BOOT PERFORMANCE RECOMMENDATIONS
# ============================================================
function Show-Recommendations {
    param($BootData)
    
    Write-Host ""
    Write-Host "[+] RECOMMENDATIONS" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    Write-Host ""
    
    $Recommendations = @()
    
    # Based on boot time
    if ($BootData -and $BootData.Seconds -gt 180) {
        $Recommendations += "Your boot time is slow ($([math]::Round($BootData.Seconds, 1)) seconds). Consider the following:"
    } elseif ($BootData -and $BootData.Seconds -gt 120) {
        $Recommendations += "Your boot time is moderate. Here are some tips to improve it:"
    } else {
        $Recommendations += "Your boot time is good! Keep it up with these tips:"
    }
    
    $Recommendations += ""
    $Recommendations += "  1. Disable unnecessary startup programs"
    $Recommendations += "     - Open Task Manager (Ctrl+Shift+Esc)"
    $Recommendations += "     - Go to Startup tab"
    $Recommendations += "     - Disable high-impact programs"
    $Recommendations += ""
    $Recommendations += "  2. Enable Fast Startup"
    $Recommendations += "     - Control Panel > Power Options"
    $Recommendations += "     - Choose what the power buttons do"
    $Recommendations += "     - Enable Fast Startup"
    $Recommendations += ""
    $Recommendations += "  3. Keep C: drive with at least 20% free space"
    $Recommendations += "  4. Run Disk Cleanup regularly"
    $Recommendations += "  5. Update Windows and drivers"
    $Recommendations += "  6. Defragment HDD (not SSD)"
    
    foreach ($Rec in $Recommendations) {
        Write-Host $Rec -ForegroundColor White
    }
}

# ============================================================
# MAIN EXECUTION
# ============================================================
$BootData = Get-BootTime
Analyze-Startup
Check-DiskHealth
Check-FastStartup
Show-Recommendations -BootData $BootData

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "                    ANALYSIS COMPLETE!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Read-Host "`nPress Enter to exit"