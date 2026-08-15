# ============================================================
# SHANECODES - STARTUP MANAGER PRO v1.0
# ============================================================
# Manage startup programs with intelligent recommendations
# Created by: Shane Nichael Obinguar (ShaneCodes)
# ============================================================
# (c) 2024-2025 ShaneCodes Technologies. All rights reserved.
# ============================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "ShaneCodes - Startup Manager Pro v1.0"

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
                                                              
         STARTUP MANAGER PRO v1.0                         
           Created by: ShaneCodes Technologies              
        "Optimize Your Startup!"                            
                                                              
============================================================

"@ -ForegroundColor Cyan

# ============================================================
# FUNCTION: GET STARTUP ITEMS
# ============================================================
function Get-StartupItems {
    Write-Host ""
    Write-Host "[+] SCANNING STARTUP ITEMS" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        # Get startup items from multiple locations
        $StartupItems = @()
        
        # Current User Run
        $RunKeys = @(
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
        )
        
        foreach ($Key in $RunKeys) {
            if (Test-Path $Key) {
                $Items = Get-ItemProperty -Path $Key -ErrorAction SilentlyContinue
                foreach ($Property in $Items.PSObject.Properties) {
                    if ($Property.Name -notin @("PSPath", "PSParentPath", "PSChildName", "PSDrive", "PSProvider")) {
                        $StartupItems += [PSCustomObject]@{
                            Name = $Property.Name
                            Command = $Property.Value
                            Location = $Key
                            Type = "Registry"
                        }
                    }
                }
            }
        }
        
        # Startup Folder
        $StartupFolder = [Environment]::GetFolderPath("Startup")
        if (Test-Path $StartupFolder) {
            $Files = Get-ChildItem -Path $StartupFolder -File -ErrorAction SilentlyContinue
            foreach ($File in $Files) {
                $StartupItems += [PSCustomObject]@{
                    Name = $File.Name
                    Command = $File.FullName
                    Location = $StartupFolder
                    Type = "Folder"
                }
            }
        }
        
        return $StartupItems
    } catch {
        Write-Host ""
        Write-Host "  [FAIL] Failed to scan startup items!" -ForegroundColor Red
        return $null
    }
}

# ============================================================
# FUNCTION: DISPLAY STARTUP ITEMS
# ============================================================
function Display-StartupItems {
    param($Items)
    
    if (-not $Items -or $Items.Count -eq 0) {
        Write-Host ""
        Write-Host "  No startup items found." -ForegroundColor Yellow
        return
    }
    
    Write-Host ""
    Write-Host "  Found $($Items.Count) startup item(s):" -ForegroundColor Green
    Write-Host ""
    
    $i = 1
    foreach ($Item in $Items) {
        Write-Host "  [$i] $($Item.Name)" -ForegroundColor White
        Write-Host "      Command: $($Item.Command)" -ForegroundColor Gray
        Write-Host "      Location: $($Item.Location)" -ForegroundColor Gray
        Write-Host "      Type: $($Item.Type)" -ForegroundColor Gray
        Write-Host ""
        $i++
    }
}

# ============================================================
# FUNCTION: ANALYZE STARTUP IMPACT
# ============================================================
function Analyze-StartupImpact {
    param($Items)
    
    Write-Host ""
    Write-Host "[+] STARTUP IMPACT ANALYSIS" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    if (-not $Items -or $Items.Count -eq 0) {
        Write-Host ""
        Write-Host "  No startup items to analyze." -ForegroundColor Yellow
        return
    }
    
    $TotalItems = $Items.Count
    $HighImpact = 0
    $MediumImpact = 0
    $LowImpact = 0
    
    foreach ($Item in $Items) {
        $Name = $Item.Name.ToLower()
        if ($Name -match "chrome|firefox|edge|opera|brave|browser") {
            $HighImpact++
        } elseif ($Name -match "adobe|java|update|helper|launcher") {
            $MediumImpact++
        } else {
            $LowImpact++
        }
    }
    
    Write-Host ""
    Write-Host "  Total Startup Items: $TotalItems" -ForegroundColor White
    Write-Host "  High Impact Items: $HighImpact (Consider disabling)" -ForegroundColor Red
    Write-Host "  Medium Impact Items: $MediumImpact" -ForegroundColor Yellow
    Write-Host "  Low Impact Items: $LowImpact" -ForegroundColor Green
    
    if ($TotalItems -gt 10) {
        Write-Host ""
        Write-Host "  [WARNING] Too many startup items ($TotalItems)!" -ForegroundColor Red
        Write-Host "  This can significantly slow down your boot time." -ForegroundColor Yellow
    } elseif ($TotalItems -gt 5) {
        Write-Host ""
        Write-Host "  [INFO] Moderate number of startup items." -ForegroundColor Yellow
        Write-Host "  Consider removing unnecessary programs." -ForegroundColor Gray
    } else {
        Write-Host ""
        Write-Host "  [OK] Low number of startup items." -ForegroundColor Green
    }
}

# ============================================================
# FUNCTION: RECOMMENDATIONS
# ============================================================
function Show-StartupRecommendations {
    Write-Host ""
    Write-Host "[+] RECOMMENDATIONS" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    Write-Host ""
    
    $Recommendations = @(
        "  1. Disable programs you don't need at startup",
        "  2. Use Task Manager to manage startup items",
        "  3. Uninstall unused applications",
        "  4. Use 'msconfig' for advanced startup options",
        "  5. Consider using a startup manager tool",
        "  6. Regularly review your startup items"
    )
    
    foreach ($Rec in $Recommendations) {
        Write-Host $Rec -ForegroundColor White
    }
    
    Write-Host ""
    Write-Host "  How to open Task Manager:" -ForegroundColor Cyan
    Write-Host "  Press Ctrl+Shift+Esc" -ForegroundColor White
    Write-Host "  Go to Startup tab" -ForegroundColor White
    Write-Host "  Right-click and disable unwanted items" -ForegroundColor White
}

# ============================================================
# FUNCTION: OPEN TASK MANAGER
# ============================================================
function Open-TaskManager {
    Write-Host ""
    Write-Host "[+] OPENING TASK MANAGER" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        Start-Process "taskmgr.exe"
        Write-Host ""
        Write-Host "  [OK] Task Manager opened." -ForegroundColor Green
        Write-Host "  Go to Startup tab to manage startup items." -ForegroundColor White
        return $true
    } catch {
        Write-Host ""
        Write-Host "  [FAIL] Failed to open Task Manager!" -ForegroundColor Red
        return $false
    }
}

# ============================================================
# MAIN MENU
# ============================================================
do {
    Clear-Host
    Write-Host @"

============================================================
     STARTUP MANAGER PRO v1.0
============================================================

  [1] SCAN STARTUP ITEMS
  [2] ANALYZE STARTUP IMPACT
  [3] OPEN TASK MANAGER
  [4] RECOMMENDATIONS
  [0] EXIT

"@ -ForegroundColor Cyan

    $Choice = Read-Host "  Enter your choice (0-4)"
    
    switch ($Choice) {
        "1" {
            $Items = Get-StartupItems
            Display-StartupItems -Items $Items
            Read-Host "`nPress Enter to continue"
        }
        "2" {
            $Items = Get-StartupItems
            Analyze-StartupImpact -Items $Items
            Read-Host "`nPress Enter to continue"
        }
        "3" {
            Open-TaskManager
            Read-Host "`nPress Enter to continue"
        }
        "4" {
            Show-StartupRecommendations
            Read-Host "`nPress Enter to continue"
        }
        "0" {
            Write-Host ""
            Write-Host "Thank you for using ShaneCodes Startup Manager Pro!" -ForegroundColor Green
            Write-Host "(c) 2024-2025 ShaneCodes Technologies" -ForegroundColor Gray
            exit
        }
        default {
            Write-Host ""
            Write-Host "Invalid choice! Please try again." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
} while ($true)