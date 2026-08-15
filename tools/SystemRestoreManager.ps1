# ============================================================
# SHANECODES - SYSTEM RESTORE MANAGER v1.0
# ============================================================
# Create, manage, and restore system restore points
# Created by: Shane Nichael Obinguar (ShaneCodes)
# ============================================================
# (c) 2024-2025 ShaneCodes Technologies. All rights reserved.
# ============================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "ShaneCodes - System Restore Manager v1.0"

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
                                                              
         SYSTEM RESTORE MANAGER v1.0                         
           Created by: ShaneCodes Technologies              
        "Your System's Time Machine"                        
                                                              
============================================================

"@ -ForegroundColor Cyan

# ============================================================
# CHECK IF SYSTEM RESTORE IS ENABLED
# ============================================================
function Test-RestoreEnabled {
    try {
        $Protection = Get-WmiObject -Class Win32_SystemRestore -ErrorAction SilentlyContinue
        if ($Protection) {
            return $true
        }
        return $false
    } catch {
        return $false
    }
}

# ============================================================
# FUNCTION: CREATE RESTORE POINT
# ============================================================
function Create-RestorePoint {
    Write-Host ""
    Write-Host "[+] CREATE RESTORE POINT" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    $Desc = Read-Host "Enter description for restore point"
    
    if ($Desc -eq "") {
        $Desc = "ShaneCodes Manual Restore Point - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    }
    
    Write-Host ""
    Write-Host "  Creating restore point..." -ForegroundColor Gray
    
    try {
        Checkpoint-Computer -Description $Desc -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
        Write-Host "  [OK] Restore point created successfully!" -ForegroundColor Green
        Write-Host "  Description: $Desc" -ForegroundColor White
        Write-Host "  Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor White
    } catch {
        Write-Host "  [FAIL] Failed to create restore point!" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "  Possible reasons:" -ForegroundColor Yellow
        Write-Host "  - System Protection is disabled" -ForegroundColor White
        Write-Host "  - Not enough disk space" -ForegroundColor White
        Write-Host "  - Run as Administrator" -ForegroundColor White
    }
    
    Read-Host "`nPress Enter to continue"
}

# ============================================================
# FUNCTION: LIST RESTORE POINTS
# ============================================================
function List-RestorePoints {
    Write-Host ""
    Write-Host "[+] LIST RESTORE POINTS" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        $Points = Get-ComputerRestorePoint -ErrorAction Stop
        
        if ($Points -and $Points.Count -gt 0) {
            Write-Host ""
            Write-Host "  Found $($Points.Count) restore point(s):" -ForegroundColor Green
            Write-Host ""
            
            $i = 1
            foreach ($Point in $Points) {
                Write-Host "  [$i] Sequence: $($Point.SequenceNumber)" -ForegroundColor White
                Write-Host "      Date    : $($Point.CreationTime)" -ForegroundColor Gray
                Write-Host "      Desc    : $($Point.Description)" -ForegroundColor Gray
                Write-Host "      Type    : $($Point.RestorePointType)" -ForegroundColor Gray
                Write-Host ""
                $i++
            }
        } else {
            Write-Host ""
            Write-Host "  No restore points found." -ForegroundColor Yellow
            Write-Host "  Create one using Option 1." -ForegroundColor Gray
        }
    } catch {
        Write-Host ""
        Write-Host "  [FAIL] Failed to list restore points!" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "  Possible reasons:" -ForegroundColor Yellow
        Write-Host "  - System Protection is disabled" -ForegroundColor White
        Write-Host "  - No restore points exist" -ForegroundColor White
    }
    
    Read-Host "`nPress Enter to continue"
}

# ============================================================
# FUNCTION: RESTORE SYSTEM
# ============================================================
function Restore-System {
    Write-Host ""
    Write-Host "[+] RESTORE SYSTEM" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  WARNING: This will restart your computer!" -ForegroundColor Red
    Write-Host "  Make sure to save all your work." -ForegroundColor Red
    Write-Host ""
    
    $Confirm = Read-Host "Continue? (YES/NO)"
    if ($Confirm -ne "YES") {
        Write-Host "  Operation cancelled." -ForegroundColor Yellow
        Read-Host "Press Enter to continue"
        return
    }
    
    try {
        $Points = Get-ComputerRestorePoint -ErrorAction Stop
        
        if ($Points -and $Points.Count -gt 0) {
            Write-Host ""
            Write-Host "  Available restore points:" -ForegroundColor Cyan
            Write-Host ""
            
            $i = 1
            foreach ($Point in $Points) {
                Write-Host "  [$i] $($Point.CreationTime) - $($Point.Description)" -ForegroundColor White
                $i++
            }
            
            Write-Host ""
            $Choice = Read-Host "Enter number to restore (1-$($Points.Count))"
            
            $Index = [int]$Choice - 1
            if ($Index -ge 0 -and $Index -lt $Points.Count) {
                $Selected = $Points[$Index]
                Write-Host ""
                Write-Host "  Restoring to: $($Selected.CreationTime)" -ForegroundColor Yellow
                Write-Host "  Description: $($Selected.Description)" -ForegroundColor Yellow
                Write-Host ""
                
                $FinalConfirm = Read-Host "Confirm restore? (YES/NO)"
                if ($FinalConfirm -eq "YES") {
                    Write-Host ""
                    Write-Host "  Restoring system..." -ForegroundColor Gray
                    Restore-Computer -RestorePoint $Selected.SequenceNumber -Force
                    Write-Host "  [OK] Restore initiated. System will restart." -ForegroundColor Green
                } else {
                    Write-Host "  Restore cancelled." -ForegroundColor Yellow
                }
            } else {
                Write-Host "  Invalid selection!" -ForegroundColor Red
            }
        } else {
            Write-Host "  No restore points available." -ForegroundColor Yellow
        }
    } catch {
        Write-Host ""
        Write-Host "  [FAIL] Failed to restore system!" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

# ============================================================
# FUNCTION: SYSTEM RESTORE STATUS
# ============================================================
function Show-RestoreStatus {
    Write-Host ""
    Write-Host "[+] SYSTEM RESTORE STATUS" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        $Protection = Get-WmiObject -Class Win32_SystemRestore -ErrorAction SilentlyContinue
        
        if ($Protection) {
            Write-Host ""
            Write-Host "  [OK] System Restore is available" -ForegroundColor Green
            
            # Check disk space
            $Disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" -ErrorAction SilentlyContinue
            if ($Disk) {
                $FreeSpace = [math]::Round($Disk.FreeSpace / 1GB, 2)
                $TotalSpace = [math]::Round($Disk.Size / 1GB, 2)
                Write-Host "  C: Drive: $FreeSpace GB free / $TotalSpace GB total" -ForegroundColor White
                
                if ($FreeSpace -lt 5) {
                    Write-Host "  [WARNING] Low disk space! Restore points may fail." -ForegroundColor Yellow
                }
            }
        } else {
            Write-Host ""
            Write-Host "  [FAIL] System Restore is not available" -ForegroundColor Red
            Write-Host ""
            Write-Host "  To enable System Restore:" -ForegroundColor Yellow
            Write-Host "  1. Open Control Panel" -ForegroundColor White
            Write-Host "  2. Go to System and Security > System" -ForegroundColor White
            Write-Host "  3. Click System Protection" -ForegroundColor White
            Write-Host "  4. Select C: drive and click Configure" -ForegroundColor White
            Write-Host "  5. Select 'Turn on system protection'" -ForegroundColor White
        }
    } catch {
        Write-Host ""
        Write-Host "  [FAIL] Failed to check restore status!" -ForegroundColor Red
    }
    
    Read-Host "`nPress Enter to continue"
}

# ============================================================
# MAIN MENU
# ============================================================
do {
    Clear-Host
    Write-Host @"

============================================================
     SYSTEM RESTORE MANAGER v1.0
============================================================

  [1] CREATE RESTORE POINT
  [2] LIST RESTORE POINTS
  [3] RESTORE SYSTEM
  [4] SYSTEM RESTORE STATUS
  [0] EXIT

"@ -ForegroundColor Cyan

    $Choice = Read-Host "  Enter your choice (0-4)"

    switch ($Choice) {
        "1" { Create-RestorePoint }
        "2" { List-RestorePoints }
        "3" { Restore-System }
        "4" { Show-RestoreStatus }
        "0" {
            Write-Host ""
            Write-Host "Thank you for using ShaneCodes System Restore Manager!" -ForegroundColor Green
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