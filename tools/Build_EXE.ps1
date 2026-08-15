# ============================================================
# SHANECODES - BUILD EXE SCRIPT
# ============================================================
# Isang run lang, EXE na agad!
# ============================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SHANECODES - EXE BUILDER" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Download ps2exe if not exists
if (!(Test-Path "ps2exe.ps1")) {
    Write-Host "⬇️ Downloading ps2exe..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri "https://github.com/MScholtes/PS2EXE/raw/master/ps2exe.ps1" -OutFile "ps2exe.ps1"
}

# Check if launcher exists
if (!(Test-Path "tools\ShaneCodes_Launcher.ps1")) {
    Write-Host "❌ ShaneCodes_Launcher.ps1 not found!" -ForegroundColor Red
    exit
}

# Create assets folder if not exists
if (!(Test-Path "assets")) {
    New-Item -ItemType Directory -Path "assets" -Force | Out-Null
}

# Create icon (optional)
Write-Host "🎨 Creating icon..." -ForegroundColor Yellow
$IconBase64 = @"
iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAOxAAADsQBlSsOGwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANZSURBVFiF7ZdNSFRRGMd/587MKKWg2aJ9UARZGlL0ARVU0EcYBUH0ARpEBbWpRREt2rQwgmjXogoRrAhaCG1q0ypFiHZBIRlRwYeR0ihjS31PZ849HXdGp2HmzOjeB/7P4jz3d/6/97z3nDvmHg4LCwvLQuAhcAPoA+JAdRvWVuDFwMdtk7mSACJADNANjC/ZzmDgEPDw/xKQSMRr3n0/3twF5sfjKmqFbMrrBx3ABLAHOEyhOymKGhT/jwA7gFvAIFUGKBQqL0pCVBrgsWiZqBP4AlwuC9DJSh6wKZv3AFgH9gGzf2RFN/DsX4r3A/fKNuEUEZ8H3gB95Rb9tP1Z9YrdiJYHe7r6Vh1Z+4C5MkPmiKtVwGXgZg7wy2sAhjvy+wAfl8PUp91XClRYBMSEaL2cYDXQBDwE3lCmbjXQgzLhNdD3h4BzAup0ALgHvKFMS7kVuAHcLwBuLyLgP6wHcAXolhR/QsIUqSpPRPypiLkSRAeIFUfLkRAjD+kYjK3S3sUkgwP0F1o3SHu3NMAO4GqhcB1EriVAQbSAoCUxORXqIDBtUpKXAVwC3D+KHxWmI8X7cjpoAe4Al4FTpC1cSUSjbaIpFfEPkrya4rHA+GrgIqooVgwR5SXpQxboJn1lrMEmaW9RBB0VxH4Bscfw9hxIG9y1fHmh++YIcKfYPgHQJYPPFbp3iPgYcW1gPMm2ZMMgAcWryf2QOq9S84dUxLUZz7zCb0sDCDOQdQ14C+zLCSLAnZzrGmCk2JU4DwxLygfl70cA6KPyxZysN1fCtmTDIH1dYjJgM4v9MjD/Y4BcK6KLY9KWjBoB+rkAS9T/JwDsLbaFkaR6sk4RBe0e0ueFFmZskKSCiUwQZ4+Ib5a8W4CFtwA9lPkZYjy6TATDRY6GgBqF60UJp6QEN5H2vR7eSkjiUCpOo7U2E51GmHblKQDjYgJbXk0eBqZxV2ibk6QVAMhTTSGIPsRd4B4GMFtNxe46hXJ2J3AO+FhFAID9wH5gfjHrzUoh7iwwWNz5Blb1Au9qIQB2AaeBayUWXShmUwcwlG+JiLXVxq9m7lNtc2s23S6LwN1Skl0irrIsrTuBqZIEtCI3Wldac8vCwsLCwsLCohr8BJZELcOQir9+AAAAAElFTkSuQmCC
"@
$IconBytes = [Convert]::FromBase64String($IconBase64)
[System.IO.File]::WriteAllBytes("assets\icon.ico", $IconBytes)

# Convert to EXE
Write-Host "🔧 Converting to EXE..." -ForegroundColor Yellow
.\ps2exe.ps1 -inputFile "tools\ShaneCodes_Launcher.ps1" -outputFile "ShaneCodes_Launcher.exe" -iconFile "assets\icon.ico" -title "ShaneCodes Tool Launcher" -description "Windows Repair & Optimization Tools" -company "ShaneCodes Technologies" -product "ShaneCodes Tech Hub" -copyright "© 2024-2025 ShaneCodes Technologies" -verbose

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ EXE CREATED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "📁 File: ShaneCodes_Launcher.exe" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Read-Host "Press Enter to exit"