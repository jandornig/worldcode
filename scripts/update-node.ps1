# PowerShell script to update Node.js to v22
$ErrorActionPreference = "Stop"

Write-Host "Starting Node.js update process..." -ForegroundColor Green

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Please run this script as Administrator" -ForegroundColor Red
    exit 1
}

# Check if NVM is installed
$nvmPath = "$env:APPDATA\nvm"
if (-not (Test-Path $nvmPath)) {
    Write-Host "Installing NVM for Windows..." -ForegroundColor Yellow
    $nvmInstaller = "https://github.com/coreybutler/nvm-windows/releases/download/1.1.11/nvm-setup.exe"
    $installerPath = "$env:TEMP\nvm-setup.exe"
    
    Invoke-WebRequest -Uri $nvmInstaller -OutFile $installerPath
    Start-Process -FilePath $installerPath -ArgumentList "/SILENT" -Wait
    
    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Install Node.js v22
Write-Host "Installing Node.js v22..." -ForegroundColor Yellow
nvm install 22
nvm use 22

# Verify installation
$nodeVersion = node --version
if ($nodeVersion -match "v22") {
    Write-Host "Node.js v22 installed successfully!" -ForegroundColor Green
    
    # Reinstall Codex CLI
    Write-Host "Reinstalling Codex CLI..." -ForegroundColor Yellow
    npm uninstall -g codex-cli
    npm install -g codex-cli
    
    Write-Host "Update complete! You can now use the Codex CLI." -ForegroundColor Green
} else {
    Write-Host "Failed to install Node.js v22. Current version: $nodeVersion" -ForegroundColor Red
    exit 1
} 