# ============================================================
# SHANECODES - FILE SHREDDER v1.0
# ============================================================
# Securely delete files with military-grade overwrite
# Created by: Shane Nichael Obinguar (ShaneCodes)
# ============================================================
# (c) 2024-2025 ShaneCodes Technologies. All rights reserved.
# ============================================================

Clear-Host
$Host.UI.RawUI.WindowTitle = "ShaneCodes - File Shredder v1.0"

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
                                                              
         FILE SHREDDER v1.0                         
           Created by: ShaneCodes Technologies              
        "Permanently Delete with Confidence!"                            
                                                              
============================================================

"@ -ForegroundColor Cyan

Write-Host ""
Write-Host "  ⚠️  WARNING: This tool PERMANENTLY deletes files!" -ForegroundColor Red
Write-Host "  NO RECOVERY IS POSSIBLE!" -ForegroundColor Red
Write-Host ""

# ============================================================
# FUNCTION: SHRED FILE (7-PASS OVERWRITE)
# ============================================================
function Shred-File {
    param(
        [string]$FilePath,
        [int]$Passes = 7
    )
    
    try {
        if (-not (Test-Path $FilePath)) {
            Write-Host "  [FAIL] File not found: $FilePath" -ForegroundColor Red
            return $false
        }
        
        $FileInfo = Get-Item -Path $FilePath
        $Length = $FileInfo.Length
        $BufferSize = 4096
        $Buffer = New-Object byte[] $BufferSize
        $Random = New-Object System.Random
        
        Write-Host "  Shredding: $($FileInfo.Name) ($([math]::Round($Length/1KB, 2)) KB)" -ForegroundColor Gray
        
        for ($i = 0; $i -lt $Passes; $i++) {
            Write-Host "    Pass $($i+1)/$Passes..." -NoNewline -ForegroundColor Gray
            
            $Stream = [System.IO.File]::OpenWrite($FilePath)
            $Position = 0
            
            while ($Position -lt $Length) {
                $Random.NextBytes($Buffer)
                $WriteSize = [Math]::Min($Buffer.Length, $Length - $Position)
                $Stream.Write($Buffer, 0, $WriteSize)
                $Position += $WriteSize
            }
            
            $Stream.Close()
            Write-Host " [OK]" -ForegroundColor Green
        }
        
        # Final delete
        Remove-Item -Path $FilePath -Force
        Write-Host "  [OK] File permanently deleted: $($FileInfo.Name)" -ForegroundColor Green
        return $true
        
    } catch {
        Write-Host "  [FAIL] Failed to shred: $FilePath" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Red
        return $false
    }
}

# ============================================================
# FUNCTION: SHRED FOLDER
# ============================================================
function Shred-Folder {
    param(
        [string]$FolderPath,
        [int]$Passes = 7
    )
    
    try {
        if (-not (Test-Path $FolderPath)) {
            Write-Host "  [FAIL] Folder not found: $FolderPath" -ForegroundColor Red
            return $false
        }
        
        Write-Host ""
        Write-Host "  Processing folder: $FolderPath" -ForegroundColor Yellow
        
        # Get all files
        $Files = Get-ChildItem -Path $FolderPath -Recurse -File -ErrorAction SilentlyContinue
        $FileCount = $Files.Count
        
        if ($FileCount -eq 0) {
            Write-Host "  [INFO] No files found in folder." -ForegroundColor Yellow
            Remove-Item -Path $FolderPath -Force -ErrorAction SilentlyContinue
            Write-Host "  [OK] Empty folder removed." -ForegroundColor Green
            return $true
        }
        
        Write-Host "  Found $FileCount file(s) to shred..." -ForegroundColor Gray
        
        $SuccessCount = 0
        foreach ($File in $Files) {
            if (Shred-File -FilePath $File.FullName -Passes $Passes) {
                $SuccessCount++
            }
        }
        
        # Remove empty folders
        Remove-Item -Path $FolderPath -Force -ErrorAction SilentlyContinue
        
        Write-Host ""
        Write-Host "  [OK] Shredded $SuccessCount/$FileCount files" -ForegroundColor Green
        Write-Host "  [OK] Folder removed: $FolderPath" -ForegroundColor Green
        return $true
        
    } catch {
        Write-Host "  [FAIL] Failed to shred folder: $FolderPath" -ForegroundColor Red
        return $false
    }
}

# ============================================================
# FUNCTION: SHRED WITH CONFIRMATION
# ============================================================
function Shred-WithConfirmation {
    param($Path)
    
    if (-not (Test-Path $Path)) {
        Write-Host ""
        Write-Host "  [FAIL] Path does not exist!" -ForegroundColor Red
        return $false
    }
    
    $Item = Get-Item -Path $Path
    $IsFolder = Test-Path -Path $Path -PathType Container
    
    Write-Host ""
    Write-Host "  Target: $Path" -ForegroundColor Yellow
    if ($IsFolder) {
        $FileCount = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue).Count
        Write-Host "  Type: Folder ($FileCount files)" -ForegroundColor Gray
    } else {
        $Size = [math]::Round((Get-Item -Path $Path).Length / 1KB, 2)
        Write-Host "  Type: File ($Size KB)" -ForegroundColor Gray
    }
    Write-Host ""
    
    $Confirm = Read-Host "  Permanently shred this item? (YES/NO)"
    if ($Confirm -ne "YES") {
        Write-Host ""
        Write-Host "  Operation cancelled." -ForegroundColor Yellow
        return $false
    }
    
    $FinalConfirm = Read-Host "  ARE YOU ABSOLUTELY SURE? Type 'SHRED' to confirm"
    if ($FinalConfirm -ne "SHRED") {
        Write-Host ""
        Write-Host "  Operation cancelled." -ForegroundColor Yellow
        return $false
    }
    
    Write-Host ""
    Write-Host "  Shredding in progress..." -ForegroundColor Red
    
    if ($IsFolder) {
        return Shred-Folder -FolderPath $Path -Passes 7
    } else {
        return Shred-File -FilePath $Path -Passes 7
    }
}

# ============================================================
# FUNCTION: SHRED FREE SPACE
# ============================================================
function Shred-FreeSpace {
    Write-Host ""
    Write-Host "[+] SHREDDING FREE SPACE" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    Write-Host ""
    Write-Host "  This will overwrite all free space on drive C:"
    Write-Host "  This may take a long time depending on disk size." -ForegroundColor Yellow
    Write-Host ""
    
    $Confirm = Read-Host "  Continue? (YES/NO)"
    if ($Confirm -ne "YES") {
        Write-Host ""
        Write-Host "  Operation cancelled." -ForegroundColor Yellow
        return
    }
    
    try {
        Write-Host ""
        Write-Host "  Creating temporary file to fill free space..." -ForegroundColor Gray
        
        $TempFile = "$env:TEMP\shred_temp.dat"
        $Drive = Get-PSDrive -Name C
        $FreeSpace = $Drive.Free
        
        if ($FreeSpace -gt 0) {
            Write-Host "  Free space: $([math]::Round($FreeSpace/1GB, 2)) GB" -ForegroundColor Gray
            
            # Create file to fill free space
            $Stream = [System.IO.File]::OpenWrite($TempFile)
            $Buffer = New-Object byte[] 65536
            $Random = New-Object System.Random
            $Written = 0
            
            Write-Host "  Writing random data to free space..." -ForegroundColor Gray
            
            while ($Written -lt $FreeSpace) {
                $Random.NextBytes($Buffer)
                $Stream.Write($Buffer, 0, $Buffer.Length)
                $Written += $Buffer.Length
            }
            
            $Stream.Close()
            Remove-Item -Path $TempFile -Force
            
            Write-Host "  [OK] Free space shredded!" -ForegroundColor Green
        } else {
            Write-Host "  [INFO] No free space to shred." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  [FAIL] Failed to shred free space!" -ForegroundColor Red
    }
}

# ============================================================
# MAIN MENU
# ============================================================
do {
    Clear-Host
    Write-Host @"

============================================================
     FILE SHREDDER v1.0
============================================================

  ⚠️  WARNING: This tool PERMANENTLY deletes files!
  NO RECOVERY IS POSSIBLE!

  [1] SHRED FILE
  [2] SHRED FOLDER
  [3] SHRED FREE SPACE (Wipe entire drive free space)
  [0] EXIT

"@ -ForegroundColor Cyan

    $Choice = Read-Host "  Enter your choice (0-3)"
    
    switch ($Choice) {
        "1" {
            Write-Host ""
            Write-Host "[+] SHRED FILE" -ForegroundColor Yellow
            Write-Host "----------------------------------------" -ForegroundColor Gray
            $FilePath = Read-Host "`n  Enter full file path"
            Shred-WithConfirmation -Path $FilePath
            Read-Host "`nPress Enter to continue"
        }
        "2" {
            Write-Host ""
            Write-Host "[+] SHRED FOLDER" -ForegroundColor Yellow
            Write-Host "----------------------------------------" -ForegroundColor Gray
            $FolderPath = Read-Host "`n  Enter full folder path"
            Shred-WithConfirmation -Path $FolderPath
            Read-Host "`nPress Enter to continue"
        }
        "3" {
            Shred-FreeSpace
            Read-Host "`nPress Enter to continue"
        }
        "0" {
            Write-Host ""
            Write-Host "Thank you for using ShaneCodes File Shredder!" -ForegroundColor Green
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