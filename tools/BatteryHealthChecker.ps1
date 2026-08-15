# ============================================================
# SHANECODES - BATTERY HEALTH CHECKER v1.0
# ============================================================
# Diagnoses laptop battery health and provides usage reports
# Created by: Shane Nichael Obinguar (ShaneCodes)
# ============================================================
# (c) 2024-2025 ShaneCodes Technologies. All rights reserved.
# ============================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "ShaneCodes - Battery Health Checker v1.0"

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
                                                              
         BATTERY HEALTH CHECKER v1.0                         
           Created by: ShaneCodes Technologies              
        "Keep Your Battery Healthy!"                            
                                                              
============================================================

"@ -ForegroundColor Cyan

# ============================================================
# CHECK IF BATTERY EXISTS
# ============================================================
function Test-BatteryExists {
    try {
        $Battery = Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue
        if ($Battery) {
            return $true
        }
        return $false
    } catch {
        return $false
    }
}

# ============================================================
# GET BATTERY INFORMATION
# ============================================================
function Get-BatteryInfo {
    Write-Host ""
    Write-Host "[+] BATTERY INFORMATION" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        $Battery = Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue
        
        if ($Battery) {
            Write-Host ""
            Write-Host "  Name            : $($Battery.Name)" -ForegroundColor White
            Write-Host "  Manufacturer    : $($Battery.Manufacturer)" -ForegroundColor White
            Write-Host "  Chemistry       : $($Battery.Chemistry)" -ForegroundColor White
            Write-Host "  Design Capacity : $($Battery.DesignCapacity) mWh" -ForegroundColor White
            Write-Host "  Full Charge     : $($Battery.FullChargeCapacity) mWh" -ForegroundColor White
            
            # Calculate health
            if ($Battery.DesignCapacity -gt 0) {
                $Health = [math]::Round(($Battery.FullChargeCapacity / $Battery.DesignCapacity) * 100, 1)
                
                Write-Host ""
                Write-Host "  Battery Health  : $Health%" -ForegroundColor $(if ($Health -gt 80) { "Green" } elseif ($Health -gt 60) { "Yellow" } else { "Red" })
                
                if ($Health -gt 80) {
                    Write-Host "  Status          : Excellent" -ForegroundColor Green
                } elseif ($Health -gt 60) {
                    Write-Host "  Status          : Good" -ForegroundColor Yellow
                } elseif ($Health -gt 40) {
                    Write-Host "  Status          : Fair" -ForegroundColor Yellow
                } else {
                    Write-Host "  Status          : Poor - Consider replacing battery" -ForegroundColor Red
                }
            }
            
            # Battery status
            Write-Host ""
            Write-Host "  Battery Status  : $($Battery.BatteryStatus)" -ForegroundColor White
            Write-Host "  Estimated Life  : $([math]::Round($Battery.EstimatedRunTime / 60, 1)) minutes" -ForegroundColor White
            Write-Host "  Time to Full    : $([math]::Round($Battery.TimeToFullCharge / 60, 1)) minutes" -ForegroundColor White
            
            return @{
                Name = $Battery.Name
                Manufacturer = $Battery.Manufacturer
                Chemistry = $Battery.Chemistry
                DesignCapacity = $Battery.DesignCapacity
                FullChargeCapacity = $Battery.FullChargeCapacity
                Health = $Health
                Status = $Battery.BatteryStatus
                EstimatedRunTime = $Battery.EstimatedRunTime
            }
        } else {
            Write-Host ""
            Write-Host "  [INFO] No battery found." -ForegroundColor Yellow
            Write-Host "  Are you on a laptop?" -ForegroundColor Gray
            return $null
        }
    } catch {
        Write-Host ""
        Write-Host "  [FAIL] Failed to get battery info!" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Red
        return $null
    }
}

# ============================================================
# GENERATE BATTERY REPORT
# ============================================================
function Generate-BatteryReport {
    Write-Host ""
    Write-Host "[+] GENERATING BATTERY REPORT" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        $ReportPath = "$env:TEMP\battery-report.html"
        powercfg /batteryreport /output "$ReportPath" 2>$null
        
        if (Test-Path $ReportPath) {
            Write-Host ""
            Write-Host "  [OK] Battery report generated!" -ForegroundColor Green
            Write-Host "  Report saved to: $ReportPath" -ForegroundColor White
            
            $Choice = Read-Host "`n  Open report now? (Y/N)"
            if ($Choice -eq "Y" -or $Choice -eq "y") {
                Start-Process $ReportPath
                Write-Host "  Opening report..." -ForegroundColor Gray
            }
            return $true
        } else {
            Write-Host ""
            Write-Host "  [WARNING] Failed to generate battery report." -ForegroundColor Yellow
            Write-Host "  Make sure you have administrative privileges." -ForegroundColor Gray
            return $false
        }
    } catch {
        Write-Host ""
        Write-Host "  [FAIL] Failed to generate battery report!" -ForegroundColor Red
        return $false
    }
}

# ============================================================
# BATTERY TIPS
# ============================================================
function Show-BatteryTips {
    Write-Host ""
    Write-Host "[+] BATTERY CARE TIPS" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    Write-Host ""
    
    $Tips = @(
        "  1. Keep battery between 20% and 80% for optimal health",
        "  2. Avoid exposing battery to extreme temperatures",
        "  3. Unplug charger when battery is fully charged",
        "  4. Calibrate battery once a month",
        "  5. Use battery saver mode when possible",
        "  6. Close unused applications to save power",
        "  7. Reduce screen brightness when not needed",
        "  8. Disable Bluetooth and Wi-Fi when not in use"
    )
    
    foreach ($Tip in $Tips) {
        Write-Host $Tip -ForegroundColor White
    }
}

# ============================================================
# MAIN EXECUTION
# ============================================================
if (Test-BatteryExists) {
    $BatteryData = Get-BatteryInfo
    Generate-BatteryReport
    Show-BatteryTips
} else {
    Write-Host ""
    Write-Host "  [INFO] No battery detected." -ForegroundColor Yellow
    Write-Host "  This tool is designed for laptops." -ForegroundColor Gray
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "                    ANALYSIS COMPLETE!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Read-Host "`nPress Enter to exit"