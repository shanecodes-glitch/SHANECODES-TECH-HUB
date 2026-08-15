# ============================================================
# FILE ORGANIZER v2.0
# ============================================================
# Organizes files by type and date
# ============================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "        FILE ORGANIZER v2.0" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# File type categories
$Categories = @{
    "Documents" = @(".doc", ".docx", ".pdf", ".txt", ".rtf", ".odt", ".xls", ".xlsx", ".ppt", ".pptx")
    "Images" = @(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg", ".tiff", ".webp")
    "Videos" = @(".mp4", ".avi", ".mkv", ".mov", ".wmv", ".flv", ".webm")
    "Audio" = @(".mp3", ".wav", ".flac", ".aac", ".ogg", ".wma")
    "Archives" = @(".zip", ".rar", ".7z", ".tar", ".gz", ".bz2")
    "Programs" = @(".exe", ".msi", ".bat", ".cmd", ".ps1", ".vbs")
    "Code" = @(".js", ".html", ".css", ".php", ".py", ".java", ".cpp", ".c", ".cs", ".json", ".xml")
}

$Path = Read-Host "Enter folder path to organize"
if (-not (Test-Path $Path)) {
    Write-Host "Path does not exist!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "`nOrganizing: $Path" -ForegroundColor Yellow
$Files = Get-ChildItem -Path $Path -File

if ($Files.Count -eq 0) {
    Write-Host "No files found." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "Found $($Files.Count) files." -ForegroundColor Green
Write-Host ""

$Moved = 0
foreach ($File in $Files) {
    $Ext = $File.Extension.ToLower()
    $Category = "Other"
    
    foreach ($Cat in $Categories.Keys) {
        if ($Ext -in $Categories[$Cat]) {
            $Category = $Cat
            break
        }
    }
    
    $DestPath = Join-Path -Path $Path -ChildPath $Category
    if (-not (Test-Path $DestPath)) {
        New-Item -ItemType Directory -Path $DestPath -Force | Out-Null
    }
    
    $DestFile = Join-Path -Path $DestPath -ChildPath $File.Name
    Move-Item -Path $File.FullName -Destination $DestFile -Force -ErrorAction SilentlyContinue
    if ($?) {
        $Moved++
        Write-Host "  Moved: $($File.Name) -> $Category" -ForegroundColor Green
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Files organized: $Moved" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Read-Host "`nPress Enter to exit"