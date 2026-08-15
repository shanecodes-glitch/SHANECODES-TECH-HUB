# ============================================================
# NETWORK SPEED TEST v2.0
# ============================================================
# Tests internet speed and latency
# ============================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "      NETWORK SPEED TEST v2.0" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$TestFiles = @(
    "https://speedtest.tele2.net/1MB.zip",
    "https://speedtest.tele2.net/10MB.zip",
    "https://speedtest.tele2.net/100MB.zip"
)

function Test-DownloadSpeed {
    param([string]$Url, [string]$Name)
    
    Write-Host "Testing: $Name..." -ForegroundColor Yellow
    
    try {
        $StartTime = Get-Date
        $WebClient = New-Object System.Net.WebClient
        $Data = $WebClient.DownloadData($Url)
        $EndTime = Get-Date
        
        $Duration = ($EndTime - $StartTime).TotalSeconds
        $SizeMB = [math]::Round($Data.Length / 1MB, 2)
        $SpeedMbps = [math]::Round(($SizeMB * 8) / $Duration, 2)
        
        Write-Host "  Size: $SizeMB MB, Time: $Duration sec" -ForegroundColor Gray
        Write-Host "  Speed: $SpeedMbps Mbps" -ForegroundColor Green
        Write-Host ""
        
        return $SpeedMbps
    } catch {
        Write-Host "  [ERROR] Failed to download $Name" -ForegroundColor Red
        return 0
    }
}

function Test-Latency {
    param([string]$HostName)
    
    try {
        $Ping = Test-Connection -ComputerName $HostName -Count 4 -ErrorAction SilentlyContinue
        $AvgLatency = [math]::Round(($Ping | Measure-Object -Property ResponseTime -Average).Average, 1)
        $MinLatency = [math]::Round(($Ping | Measure-Object -Property ResponseTime -Minimum).Minimum, 1)
        $MaxLatency = [math]::Round(($Ping | Measure-Object -Property ResponseTime -Maximum).Maximum, 1)
        
        Write-Host "  $HostName: $AvgLatency ms (min: $MinLatency ms, max: $MaxLatency ms)" -ForegroundColor Green
        return $AvgLatency
    } catch {
        Write-Host "  $HostName: [ERROR] Failed to ping" -ForegroundColor Red
        return 0
    }
}

# Test latency
Write-Host "[LATENCY TEST]" -ForegroundColor Yellow
Write-Host ""
$PingResults = @()
$Hosts = @("google.com", "1.1.1.1", "8.8.8.8")
foreach ($Host in $Hosts) {
    $Result = Test-Latency -HostName $Host
    $PingResults += $Result
}
$AvgPing = [math]::Round(($PingResults | Where-Object { $_ -gt 0 } | Measure-Object -Average).Average, 1)
Write-Host "`n  Average Latency: $AvgPing ms" -ForegroundColor Cyan

# Test download speed
Write-Host "`n[SPEED TEST]" -ForegroundColor Yellow
Write-Host ""
$Speeds = @()
$Speeds += Test-DownloadSpeed -Url $TestFiles[0] -Name "1MB File"
$Speeds += Test-DownloadSpeed -Url $TestFiles[1] -Name "10MB File"
$Speeds += Test-DownloadSpeed -Url $TestFiles[2] -Name "100MB File"

$AvgSpeed = [math]::Round(($Speeds | Where-Object { $_ -gt 0 } | Measure-Object -Average).Average, 2)
Write-Host "  Average Speed: $AvgSpeed Mbps" -ForegroundColor Cyan

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "         TEST COMPLETE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Read-Host "`nPress Enter to exit"
