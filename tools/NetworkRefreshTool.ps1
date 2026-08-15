# ============================================================
# SHANECODES - NETWORK REFRESH TOOL v1.0
# ============================================================
# One-click network reset for connectivity issues
# Created by: Shane Nichael Obinguar (ShaneCodes)
# ============================================================
# (c) 2024-2025 ShaneCodes Technologies. All rights reserved.
# ============================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "ShaneCodes - Network Refresh Tool v1.0"

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
                                                              
         NETWORK REFRESH TOOL v1.0                         
           Created by: ShaneCodes Technologies              
        "Reset Your Connection!"                            
                                                              
============================================================

"@ -ForegroundColor Cyan

# ============================================================
# FUNCTION: RESET WINSOCK
# ============================================================
function Reset-Winsock {
    Write-Host ""
    Write-Host "[+] RESETTING WINSOCK" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        Write-Host "  Resetting Winsock..." -ForegroundColor Gray
        netsh winsock reset
        Write-Host "  [OK] Winsock reset completed" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "  [FAIL] Failed to reset Winsock!" -ForegroundColor Red
        return $false
    }
}

# ============================================================
# FUNCTION: RESET IP STACK
# ============================================================
function Reset-IPStack {
    Write-Host ""
    Write-Host "[+] RESETTING IP STACK" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        Write-Host "  Resetting IP Stack..." -ForegroundColor Gray
        netsh int ip reset
        Write-Host "  [OK] IP Stack reset completed" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "  [FAIL] Failed to reset IP Stack!" -ForegroundColor Red
        return $false
    }
}

# ============================================================
# FUNCTION: FLUSH DNS CACHE
# ============================================================
function Flush-DNSCache {
    Write-Host ""
    Write-Host "[+] FLUSHING DNS CACHE" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        Write-Host "  Flushing DNS Cache..." -ForegroundColor Gray
        ipconfig /flushdns
        Write-Host "  [OK] DNS Cache flushed" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "  [FAIL] Failed to flush DNS Cache!" -ForegroundColor Red
        return $false
    }
}

# ============================================================
# FUNCTION: RELEASE IP
# ============================================================
function Release-IP {
    Write-Host ""
    Write-Host "[+] RELEASING IP" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        Write-Host "  Releasing IP..." -ForegroundColor Gray
        ipconfig /release
        Write-Host "  [OK] IP released" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "  [FAIL] Failed to release IP!" -ForegroundColor Red
        return $false
    }
}

# ============================================================
# FUNCTION: RENEW IP
# ============================================================
function Renew-IP {
    Write-Host ""
    Write-Host "[+] RENEWING IP" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        Write-Host "  Renewing IP..." -ForegroundColor Gray
        ipconfig /renew
        Write-Host "  [OK] IP renewed" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "  [FAIL] Failed to renew IP!" -ForegroundColor Red
        return $false
    }
}

# ============================================================
# FUNCTION: REGISTER DNS
# ============================================================
function Register-DNS {
    Write-Host ""
    Write-Host "[+] REGISTERING DNS" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        Write-Host "  Registering DNS..." -ForegroundColor Gray
        ipconfig /registerdns
        Write-Host "  [OK] DNS registered" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "  [FAIL] Failed to register DNS!" -ForegroundColor Red
        return $false
    }
}

# ============================================================
# FUNCTION: RESET PROXY
# ============================================================
function Reset-Proxy {
    Write-Host ""
    Write-Host "[+] RESETTING PROXY" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        Write-Host "  Resetting Proxy..." -ForegroundColor Gray
        netsh winhttp reset proxy
        Write-Host "  [OK] Proxy reset completed" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "  [FAIL] Failed to reset Proxy!" -ForegroundColor Red
        return $false
    }
}

# ============================================================
# FUNCTION: CHECK NETWORK STATUS
# ============================================================
function Check-NetworkStatus {
    Write-Host ""
    Write-Host "[+] CHECKING NETWORK STATUS" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        # Check IP configuration
        $IPConfig = ipconfig | Select-String "IPv4 Address"
        if ($IPConfig) {
            Write-Host ""
            Write-Host "  IP Addresses found:" -ForegroundColor Green
            foreach ($Line in $IPConfig) {
                Write-Host "    $Line" -ForegroundColor White
            }
        } else {
            Write-Host ""
            Write-Host "  [WARNING] No IPv4 Address found!" -ForegroundColor Yellow
        }
        
        # Check connectivity
        Write-Host ""
        Write-Host "  Testing connectivity..." -ForegroundColor Gray
        $TestHosts = @("8.8.8.8", "1.1.1.1", "google.com")
        $Connected = 0
        
        foreach ($Host in $TestHosts) {
            $Result = Test-Connection -ComputerName $Host -Count 1 -Quiet -ErrorAction SilentlyContinue
            if ($Result) {
                Write-Host "    [OK] $Host - Connected" -ForegroundColor Green
                $Connected++
            } else {
                Write-Host "    [FAIL] $Host - Not Connected" -ForegroundColor Red
            }
        }
        
        if ($Connected -gt 0) {
            Write-Host ""
            Write-Host "  [OK] Network is connected ($Connected/$($TestHosts.Count) hosts reachable)" -ForegroundColor Green
        } else {
            Write-Host ""
            Write-Host "  [FAIL] Network is not connected!" -ForegroundColor Red
        }
        
        return $true
    } catch {
        Write-Host ""
        Write-Host "  [FAIL] Failed to check network status!" -ForegroundColor Red
        return $false
    }
}

# ============================================================
# FUNCTION: SHOW IP CONFIG
# ============================================================
function Show-IPConfig {
    Write-Host ""
    Write-Host "[+] IP CONFIGURATION" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        ipconfig /all
        return $true
    } catch {
        Write-Host ""
        Write-Host "  [FAIL] Failed to get IP configuration!" -ForegroundColor Red
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
     NETWORK REFRESH TOOL v1.0
============================================================

  [1] RUN FULL NETWORK REFRESH (All Steps)
  [2] RESET WINSOCK
  [3] FLUSH DNS CACHE
  [4] RELEASE & RENEW IP
  [5] CHECK NETWORK STATUS
  [6] SHOW IP CONFIGURATION
  [0] EXIT

"@ -ForegroundColor Cyan

    $Choice = Read-Host "  Enter your choice (0-6)"
    
    switch ($Choice) {
        "1" {
            Write-Host ""
            Write-Host "============================================================" -ForegroundColor Cyan
            Write-Host "           RUNNING FULL NETWORK REFRESH" -ForegroundColor Yellow
            Write-Host "============================================================" -ForegroundColor Cyan
            
            Reset-Winsock
            Reset-IPStack
            Flush-DNSCache
            Release-IP
            Renew-IP
            Register-DNS
            Reset-Proxy
            
            Write-Host ""
            Write-Host "============================================================" -ForegroundColor Cyan
            Write-Host "           NETWORK REFRESH COMPLETE!" -ForegroundColor Green
            Write-Host "============================================================" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "  [INFO] It is recommended to restart your PC." -ForegroundColor Yellow
            
            Read-Host "`nPress Enter to continue"
        }
        "2" {
            Reset-Winsock
            Read-Host "`nPress Enter to continue"
        }
        "3" {
            Flush-DNSCache
            Read-Host "`nPress Enter to continue"
        }
        "4" {
            Release-IP
            Renew-IP
            Read-Host "`nPress Enter to continue"
        }
        "5" {
            Check-NetworkStatus
            Read-Host "`nPress Enter to continue"
        }
        "6" {
            Show-IPConfig
            Read-Host "`nPress Enter to continue"
        }
        "0" {
            Write-Host ""
            Write-Host "Thank you for using ShaneCodes Network Refresh Tool!" -ForegroundColor Green
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