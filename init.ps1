# Set script to stop on errors
$ErrorActionPreference = 'Stop'

# -----------------------------------
# Function: Backup Existing Config Files
# -----------------------------------
function Backup-ConfigFiles {
    try {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backupDir = Join-Path $env:USERPROFILE "config-backups-$timestamp"
        
        Write-Host "Creating backup directory: $backupDir"
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        
        $configsToBackup = @(
            @{ Source = "$env:USERPROFILE\.wezterm.lua"; Dest = Join-Path $backupDir ".wezterm.lua" },
            @{ Source = "$env:USERPROFILE\.config\starship\starship.toml"; Dest = Join-Path $backupDir "starship.toml" },
            @{ Source = "$env:USERPROFILE\.gitconfig"; Dest = Join-Path $backupDir ".gitconfig" },
            @{ Source = "$env:USERPROFILE\.bashrc"; Dest = Join-Path $backupDir ".bashrc" }
        )
        
        foreach ($config in $configsToBackup) {
            if (Test-Path $config.Source) {
                Copy-Item $config.Source $config.Dest -Force
                Write-Host "✅ Backed up: $($config.Source)"
            }
        }
        
        Write-Host "✅ Config files backed up to: $backupDir"
        return $backupDir
    }
    catch {
        Write-Host "❌ Failed to backup config files: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# -----------------------------------
# Function: Copy Config Files (WezTerm & Starship from ./configs)
# -----------------------------------
function Copy-ConfigFiles {
    try {
        $repoRoot = $PSScriptRoot
        $configSourceDir = Join-Path $repoRoot "configs"
        
        # Validate source directory exists
        if (-not (Test-Path $configSourceDir)) {
            throw "Config source directory not found: $configSourceDir"
        }

        # Backup existing configs first
        Backup-ConfigFiles

        # WezTerm
        $sourceWezterm = Join-Path $configSourceDir ".wezterm.lua"
        $targetWeztermDir = "$env:USERPROFILE"
        $targetWezterm = Join-Path $targetWeztermDir ".wezterm.lua"

        if (Test-Path $sourceWezterm) {
            if (-Not (Test-Path $targetWeztermDir)) {
                New-Item -ItemType Directory -Path $targetWeztermDir -Force | Out-Null
            }
            Copy-Item $sourceWezterm -Destination $targetWezterm -Force -ErrorAction Stop
            Write-Host "✅ WezTerm config copied to $targetWezterm"
        } else {
            Write-Host "❌ WezTerm config not found in $sourceWezterm" -ForegroundColor Yellow
        }

# Starship
        $sourceStarship = Join-Path $configSourceDir "starship.toml"
        $targetStarshipDir = "$env:USERPROFILE\.config\starship"
        $targetStarship = Join-Path $targetStarshipDir "starship.toml"

        if (Test-Path $sourceStarship) {
            if (-Not (Test-Path $targetStarshipDir)) {
                New-Item -ItemType Directory -Path $targetStarshipDir -Force | Out-Null
            }
            Copy-Item $sourceStarship -Destination $targetStarship -Force -ErrorAction Stop
            Write-Host "✅ Starship config copied to $targetStarship"
        } else {
            Write-Host "❌ Starship config not found in $sourceStarship" -ForegroundColor Yellow
        }
    
        # gitconfig
        $sourcegitconfig = Join-Path $configSourceDir ".gitconfig"
        $targetgitconfigDir = "$env:USERPROFILE"
        $targetgitconfig = Join-Path $targetgitconfigDir ".gitconfig"

        if (Test-Path $sourcegitconfig) {
            if (-Not (Test-Path $targetgitconfigDir)) {
                New-Item -ItemType Directory -Path $targetgitconfigDir -Force | Out-Null
            }
            Copy-Item $sourcegitconfig -Destination $targetgitconfig -Force -ErrorAction Stop
            Write-Host "✅ gitconfig config copied to $targetgitconfig"
        } else {
            Write-Host "❌ gitconfig config not found in $sourcegitconfig" -ForegroundColor Yellow
        }

        # bashrc
        $sourcebashrc = Join-Path $configSourceDir ".bashrc"
        $targetbashrcDir = "$env:USERPROFILE"
        $targetbashrc = Join-Path $targetbashrcDir ".bashrc"
        if (Test-Path $sourcebashrc) {
            if (-Not (Test-Path $targetbashrcDir)) {
                New-Item -ItemType Directory -Path $targetbashrcDir -Force | Out-Null
            }
            Copy-Item $sourcebashrc -Destination $targetbashrc -Force -ErrorAction Stop
            Write-Host "✅ bashrc config copied to $targetbashrc"
        } else {
            Write-Host "❌ bashrc config not found in $sourcebashrc" -ForegroundColor Yellow
        }
        
        Write-Host "✅ Configuration files copied successfully"
    }
    catch {
        Write-Host "❌ Failed to copy config files: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# ------------------------
# Function: Install Scoop
# ------------------------
function Install-Scoop {
    try {
        if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
            Write-Host "Installing Scoop..."
            # Use more secure execution policy
            $currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
            if ($currentPolicy -eq "Restricted") {
                Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            }
            Invoke-RestMethod get.scoop.sh | Invoke-Expression
            Write-Host "✅ Scoop installed successfully"
        } else {
            Write-Host "✅ Scoop already installed"
        }
    }
    catch {
        Write-Host "❌ Failed to install Scoop: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# -----------------------------
# Function: Install Scoop Apps
# -----------------------------
function Install-ScoopApps {
    try {
        Write-Host "Updating Scoop..."
        scoop update
        
        Write-Host "Installing Scoop packages..."
        scoop install `
        7zip `
        ani-cli `
        aria2 `
        bat `
        delta `
        eza `
        fd `
        python `
        fzf `
        lazygit `
        pnpm `
        ripgrep `
        yazi `
        zig `
        zoxide `
        imagemagick `
        neofetch `
        neovim `
        gh `
        wezterm `
        go `
rustup `
        starship `
        make `
        unzip `
        fastfetch `
        fnm `
uv `
        nodejs
        
        Write-Host "✅ All Scoop packages installed successfully"
    }
    catch {
        Write-Host "❌ Failed to install Scoop packages: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}
# -----------------------------
# Function: Install Winget Apps
# -----------------------------
function Install-WingetApps {
    try {
        $wingetPackages = @(
            "HTTPie.HTTPie",
            "Git.Git"
        )

        foreach ($pkg in $wingetPackages) {
            Write-Host "Installing $pkg via winget..."
            $result = winget install --id=$pkg --accept-package-agreements --accept-source-agreements --silent
            if ($LASTEXITCODE -ne 0) {
                Write-Host "⚠️ Failed to install $pkg (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
            } else {
                Write-Host "✅ Successfully installed $pkg"
            }
        }
        Write-Host "✅ Winget package installation completed"
    }
    catch {
        Write-Host "❌ Failed to install Winget packages: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# -------------------------------
# Function: Clone Neovim Config
# -------------------------------
function Clone-NeovimConfig {
    $configPath = "$env:LOCALAPPDATA\nvim"
    $backupPath = "$env:LOCALAPPDATA\nvim.bak"

    if (Test-Path $configPath) {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backupPath = "$env:LOCALAPPDATA\nvim.bak-$timestamp"
        Write-Host "⚠️ Neovim config exists. Backing up to $backupPath..."
        Rename-Item -Path $configPath -NewName ("nvim.bak-" + $timestamp)
    }

    Write-Host "📥 Cloning latest Neovim config from GitHub..."
    git clone https://github.com/lubasinkal/nvim $configPath
}

# -------------------------------
# Function: Setup PowerShell Profile
# -------------------------------
function Setup-PowerShellProfile {
    try {
        $profilePath = $PROFILE.CurrentUserAllHosts
        $sourceProfile = Join-Path $PSScriptRoot "configs\Microsoft.PowerShell_profile.ps1"
        
        if (Test-Path $sourceProfile) {
            # Backup existing profile
            if (Test-Path $profilePath) {
                $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
                $backupPath = "$profilePath.bak-$timestamp"
                Copy-Item $profilePath $backupPath
                Write-Host "✅ Existing PowerShell profile backed up to: $backupPath"
            }
            
            # Copy new profile
            Copy-Item $sourceProfile $profilePath -Force
            Write-Host "✅ PowerShell profile installed to: $profilePath"
        } else {
            Write-Host "❌ PowerShell profile source not found: $sourceProfile" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "❌ Failed to setup PowerShell profile: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# -------------------------------
# Function: Setup Environment Variables
# -------------------------------
function Setup-EnvironmentVariables {
    try {
        $envTemplate = Join-Path $PSScriptRoot ".env.template"
        $envFile = Join-Path $PSScriptRoot ".env"
        
        if ((Test-Path $envTemplate) -and (-not (Test-Path $envFile))) {
            Copy-Item $envTemplate $envFile
            Write-Host "✅ Environment template copied to: $envFile"
            Write-Host "⚠️ Please customize the .env file with your actual values" -ForegroundColor Yellow
        } elseif (Test-Path $envFile) {
            Write-Host "ℹ️ Environment file already exists: $envFile"
        }
    }
    catch {
        Write-Host "❌ Failed to setup environment variables: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# -------------------------------
# Function: Setup Development Directories
# -------------------------------
function Setup-DevDirectories {
    try {
        $devDirs = @(
            "$env:USERPROFILE\dev",
            "$env:USERPROFILE\dev\personal",
            "$env:USERPROFILE\dev\work",
            "$env:USERPROFILE\dev\open-source",
            "$env:USERPROFILE\dev\experiments",
            "$env:USERPROFILE\dev\tutorials",
            "$env:USERPROFILE\dev\archives"
        )
        
        foreach ($dir in $devDirs) {
            if (-not (Test-Path $dir)) {
                New-Item -ItemType Directory -Path $dir -ErrorAction Stop | Out-Null
                Write-Host "✅ Created directory: $dir"
            } else {
                Write-Host "ℹ️ Directory already exists: $dir"
            }
        }
        Write-Host "✅ Development directories setup completed"
    }
    catch {
        Write-Host "❌ Failed to setup development directories: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# -------------------------------
# Function: Configure Git
# -------------------------------
function Configure-Git {
    $gitUser = git config --global user.name 2>$null
    $gitEmail = git config --global user.email 2>$null
    
    if (-not $gitUser -or -not $gitEmail) {
        Write-Host "⚠️ Git not configured. Please run the following commands manually:"
        Write-Host "   git config --global user.name `"Your Name`""
        Write-Host "   git config --global user.email `"your.email@example.com`""
    } else {
        Write-Host "✅ Git already configured for $gitUser ($gitEmail)"
    }
    
    git config --global init.defaultBranch main 2>$null
    git config --global pull.rebase false 2>$null
    git config --global core.autocrlf true 2>$null
}

# ------------------------
# Main Setup Function
# ------------------------
function Start-DevSetup {
    Write-Host "`n==> Running development environment setup..." -ForegroundColor Cyan

    Install-Scoop
    Install-ScoopApps
    Install-WingetApps
    Setup-DevDirectories
    Setup-PowerShellProfile
    Setup-EnvironmentVariables
    Clone-NeovimConfig
    Copy-ConfigFiles
    Configure-Git

    Write-Host "`n==> Setup complete!" -ForegroundColor Green
    Write-Host "`nNext steps:"
    Write-Host "1. Restart your terminal (or run: . `$PROFILE)"
    Write-Host "2. Configure Git if prompted above"
    Write-Host "3. Customize your .env file with actual values"
    Write-Host "4. Run 'fastfetch' to test your setup"
    Write-Host "5. Try commands: 'sysinfo', 'dev', 'proj <name>', 'y'"
    Write-Host "6. Enjoy your new development environment! 🎉"
}

# ------------------------
# Run Setup
# ------------------------
Start-DevSetup
