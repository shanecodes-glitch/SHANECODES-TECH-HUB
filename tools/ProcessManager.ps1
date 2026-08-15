# ============================================================
# PROCESS MANAGER v2.0
# ============================================================
# Lists and manages running processes
# ============================================================

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "WARNING: Some features require administrator privileges." -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "        PROCESS MANAGER v2.0" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get all processes
$Processes = Get-Process | Sort-Object -Property CPU -Descending

Write-Host "[TOP 20 PROCESSES BY CPU]" -ForegroundColor Yellow
Write-Host ""
Write-Host "  PID  CPU%   Memory   Name" -ForegroundColor Gray
Write-Host "  ---  ----   ------   ----" -ForegroundColor Gray

$Count = 0
foreach ($Proc in $Processes) {
    if ($Count -ge 20) { break }
    $CPU = [math]::Round($Proc.CPU, 1)
    $Memory = [math]::Round($Proc.WorkingSet64 / 1MB, 1)
    Write-Host "  $($Proc.Id)  $CPU%    $Memory MB   $($Proc.ProcessName)" -ForegroundColor White
    $Count++
}

Write-Host "`n[PROCESS SUMMARY]" -ForegroundColor Yellow
Write-Host "  Total Processes: $($Processes.Count)" -ForegroundColor White
Write-Host "  System Processes: $(($Processes | Where-Object { $_.ProcessName -like "*svchost*" }).Count)" -ForegroundColor White
Write-Host "  User Processes: $(($Processes | Where-Object { $_.ProcessName -notlike "*svchost*" -and $_.ProcessName -notlike "*system*" }).Count)" -ForegroundColor White

Write-Host "`n[OPTIONS]" -ForegroundColor Yellow
Write-Host "  1. Show all processes"
Write-Host "  2. Search for a process"
Write-Host "  3. Kill a process"
Write-Host "  4. Exit"
Write-Host ""

$Choice = Read-Host "Select option (1-4)"

switch ($Choice) {
    "1" {
        Clear-Host
        Write-Host "ALL PROCESSES" -ForegroundColor Cyan
        Get-Process | Format-Table -AutoSize
        Read-Host "`nPress Enter to continue"
    }
    "2" {
        $Search = Read-Host "Enter process name to search"
        $Results = Get-Process -Name "*$Search*" -ErrorAction SilentlyContinue
        if ($Results) {
            $Results | Format-Table -AutoSize
        } else {
            Write-Host "No processes found." -ForegroundColor Red
        }
        Read-Host "`nPress Enter to continue"
    }
    "3" {
        $PID = Read-Host "Enter Process ID to kill"
        try {
            Stop-Process -Id $PID -Force
            Write-Host "Process $PID killed." -ForegroundColor Green
        } catch {
            Write-Host "Failed to kill process: $_" -ForegroundColor Red
        }
        Read-Host "`nPress Enter to continue"
    }
    "4" {
        Write-Host "Exiting..." -ForegroundColor Gray
    }
    default {
        Write-Host "Invalid option." -ForegroundColor Red
    }
}
