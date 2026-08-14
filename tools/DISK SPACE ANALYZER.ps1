# ============================================================
# DISK SPACE ANALYZER v2.0
# ============================================================
# Shows disk usage with visual breakdown
# ============================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "      DISK SPACE ANALYZER v2.0" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

function Show-DiskUsage {
    param(
        [string]$Path,
        [int]$Depth = 0,
        [int]$MaxDepth = 2
    )
    
    if ($Depth -gt $MaxDepth) { return }
    
    try {
        $Items = Get-ChildItem -Path $Path -Directory -ErrorAction SilentlyContinue
        $TotalSize = 0
        
        # Calculate total size
        foreach ($Item in $Items) {
            try {
                $Size = (Get-ChildItem -Path $Item.FullName -Recurse -File -ErrorAction SilentlyContinue | 
                         Measure-Object -Property Length -Sum).Sum
                $TotalSize += $Size
            } catch {}
        }
        
        $TotalSizeGB = [math]::Round($TotalSize / 1GB, 2)
        $Indent = "  " * $Depth
        
        if ($TotalSizeGB -gt 1) {
            Write-Host "$Indent📁 $($Items.Count) folders" -ForegroundColor Yellow
            Write-Host "$Indent   Total: $TotalSizeGB GB" -ForegroundColor White
            
            # Show top folders
            $TopFolders = @()
            foreach ($Item in $Items) {
                try {
                    $Size = (Get-ChildItem -Path $Item.FullName -Recurse -File -ErrorAction SilentlyContinue | 
                             Measure-Object -Property Length -Sum).Sum
                    if ($Size -gt 0) {
                        $TopFolders += [PSCustomObject]@{
                            Name = $Item.Name
                            Size = $Size
                            SizeGB = [math]::Round($Size / 1GB, 2)
                        }
                    }
                } catch {}
            }
            
            $TopFolders = $TopFolders | Sort-Object Size -Descending | Select-Object -First 5
            foreach ($Folder in $TopFolders) {
                Write-Host "$Indent   📂 $($Folder.Name): $($Folder.SizeGB) GB" -ForegroundColor Gray
            }
        }
    } catch {}
}

# Get all drives
$Drives = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"
$TotalSpace = 0
$UsedSpace = 0
$FreeSpace = 0

Write-Host "[DRIVE OVERVIEW]" -ForegroundColor Yellow
Write-Host ""

foreach ($Drive in $Drives) {
    $Total = [math]::Round($Drive.Size / 1GB, 2)
    $Free = [math]::Round($Drive.FreeSpace / 1GB, 2)
    $Used = $Total - $Free
    $Percent = [math]::Round(($Used / $Total) * 100, 0)
    
    $TotalSpace += $Total
    $UsedSpace += $Used
    $FreeSpace += $Free
    
    # Visual bar
    $BarLength = 40
    $Filled = [math]::Round(($Percent / 100) * $BarLength)
    $Empty = $BarLength - $Filled
    $Bar = "█" * $Filled + "░" * $Empty
    
    if ($Percent -gt 90) { $Color = "Red" }
    elseif ($Percent -gt 70) { $Color = "Yellow" }
    else { $Color = "Green" }
    
    Write-Host "  $($Drive.DeviceID)  $Bar  $Percent% - $($Used) GB / $($Total) GB" -ForegroundColor $Color
    
    # Show top folders if C: drive
    if ($Drive.DeviceID -eq "C:") {
        Write-Host "`n  [Top folders in C:]" -ForegroundColor Cyan
        Show-DiskUsage -Path "C:\" -Depth 0 -MaxDepth 1
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Total: $([math]::Round($TotalSpace, 2)) GB"
Write-Host "  Used : $([math]::Round($UsedSpace, 2)) GB"
Write-Host "  Free : $([math]::Round($FreeSpace, 2)) GB"
Write-Host "========================================" -ForegroundColor Cyan

Read-Host "`nPress Enter to exit"