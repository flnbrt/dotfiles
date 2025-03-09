Write-Host ""
Write-Host "#########################################"
Write-Host "# Windows PowerShell Dotfiles Installer #"
Write-Host "#########################################"
Write-Host ""

#######################
# Dotfiles Repository #
#######################

Write-Host "----------------------------------"
Write-Host "Installing Dotfiles Repository..."

$dotfilesDir = [Environment]::GetFolderPath("MyDocuments") + "\Github\dotfiles"
if (!(Test-Path $dotfilesDir)) {
    git clone https://github.com/flnbrt/dotfiles.git $dotfilesDir
} else {
    git -C $dotfilesDir pull
}

######################
# PowerShell Profile #
######################

Write-Host ""
Write-Host "----------------------------------------"
Write-Host "Installing Windows PowerShell Profile..."

$profileDir = Split-Path -Parent $PROFILE
if (!(Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

try {
    $url = "https://raw.githubusercontent.com/flnbrt/dotfiles/main/windows/Microsoft.PowerShell_profile.ps1"
    Invoke-WebRequest -Uri $url -OutFile $PROFILE -UseBasicParsing
    Write-Host "Profile Installation Successfully!"
} catch {
    Write-Host "Failed to install PowerShell Profile: $_"
}

########################
# Neovim Configuration #
########################

Write-Host ""
Write-Host "----------------------------------"
Write-Host "Installing Neovim Configuration..."

# install NeoVim with WinGet, if not already present on system
if (!$(Get-Command nvim -ErrorAction SilentlyContinue)) {
    Write-Host "Neovim Not found, installing with WinGet..."
    winget install Neovim.Neovim
}

# create nvim directory if not already present
$nvimDir = "$env:LOCALAPPDATA\nvim"
if (!(Test-Path $nvimDir)) {
    Write-Host "Creating nvim directory..."
    New-Item -ItemType Directory -Path $nvimDir -Force | Out-Null
}

# Link nvim configuration files
$localNvimConfig = Join-Path $env:LOCALAPPDATA "nvim"
$dotfilesNvimConfig = Join-Path $dotfilesDir ".config" "nvim"

Write-Host "Creating Symbolic Link to nvim configuration..."
New-Item -Path $localNvimConfig -ItemType SymbolicLink -Value $dotfilesNvimConfig -Force