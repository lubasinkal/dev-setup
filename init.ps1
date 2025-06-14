# Set script to stop on errors
$ErrorActionPreference = 'Stop'

# -----------------------------------
# Function: Copy Config Files (WezTerm & Starship from ./configs)
# -----------------------------------
function Copy-ConfigFiles {
    $repoRoot = $PSScriptRoot
    $configSourceDir = Join-Path $repoRoot "configs"

    # WezTerm
    $sourceWezterm = Join-Path $configSourceDir ".wezterm.lua"
    $targetWeztermDir = "$env:USERPROFILE"
    $targetWezterm = Join-Path $targetWeztermDir ".wezterm.lua"

    if (Test-Path $sourceWezterm) {
        if (-Not (Test-Path $targetWeztermDir)) {
            New-Item -ItemType Directory -Path $targetWeztermDir | Out-Null
        }
        Copy-Item $sourceWezterm -Destination $targetWezterm -Force
        Write-Host "✅ WezTerm config copied to $targetWezterm"
    } else {
        Write-Host "❌ WezTerm config not found in $sourceWezterm"
    }

    # Starship
    $sourceStarship = Join-Path $configSourceDir "starship.toml"
    $targetStarshipDir = "$env:USERPROFILE\.config\starship"
    $targetStarship = Join-Path $targetStarshipDir "starship.toml"

    if (Test-Path $sourceStarship) {
        if (-Not (Test-Path $targetStarshipDir)) {
            New-Item -ItemType Directory -Path $targetStarshipDir | Out-Null
        }
        Copy-Item $sourceStarship -Destination $targetStarship -Force
        Write-Host "✅ Starship config copied to $targetStarship"
    } else {
        Write-Host "❌ Starship config not found in $sourceStarship"
    }
   
    # gitconfig
    $sourcegitconfig = Join-Path $configSourceDir ".gitconfig"
    $targetgitconfigDir = "$env:USERPROFILE"
    $targetgitconfig = Join-Path $targetStarshipDir ".gitconfig"

    if (Test-Path $sourcegitconfig) {
        if (-Not (Test-Path $targetgitconfigDir)) {
            New-Item -ItemType Directory -Path $targetgitconfigDir | Out-Null
        }
        Copy-Item $sourcegitconfig -Destination $targetStarship -Force
        Write-Host "✅ gitconfig config copied to $targetgitconfig"
    } else {
        Write-Host "❌ gitconfig config not found in $sourcegitconfig"
    }

}

# ------------------------
# Function: Install Scoop
# ------------------------
function Install-Scoop {
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Scoop..."
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod get.scoop.sh | Invoke-Expression
    } else {
        Write-Host "✅ Scoop already installed"
    }
}

# -----------------------------
# Function: Install Scoop Apps
# -----------------------------
function Install-ScoopApps {

    scoop update
    scoop install `
        7zip `
        ani-cli `
        aria2 `
        bat `
        delta `
        eza `
        fd `
        fzf `
        jq `
        lazygit `
        pnpm `
        ripgrep `
        yazi `
        zig `
        zoxide `
}

# -----------------------------
# Function: Install Winget Apps
# -----------------------------
function Install-WingetApps {
    $wingetPackages = @(
        "Git.Git",
        "ImageMagick.ImageMagick",
        "HTTPie.HTTPie",
        "nepnep.neofetch-win",
        "Neovim.Neovim",
        "GitHub.cli",
        "Nushell.Nushell",
        "wez.wezterm",
        "GoLang.Go",
        "Starship.Starship",
        "GnuWin32.Make",
        "GnuWin32.UnZip",
        "Fastfetch-cli.Fastfetch",
        "GitHub.GitHubDesktop",
        "Schniz.fnm",
        "astral-sh.uv",
        "Warp.Warp",
        "Python.Python.3.13",
        "Microsoft.VisualStudioCode"
    )

    foreach ($pkg in $wingetPackages) {
        Write-Host "Installing $pkg via winget..."
        winget install --id=$pkg --accept-package-agreements --accept-source-agreements --silent
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
# Function: Setup Development Directories
# -------------------------------
function Setup-DevDirectories {
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
            New-Item -ItemType Directory -Path $dir | Out-Null
            Write-Host "✅ Created directory: $dir"
        }
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
    Clone-NeovimConfig
    Copy-ConfigFiles
    Configure-Git

    Write-Host "`n==> Setup complete!" -ForegroundColor Green
    Write-Host "`nNext steps:"
    Write-Host "1. Restart your terminal"
    Write-Host "2. Configure Git if prompted above"
    Write-Host "3. Run 'fastfetch' to test your setup"
    Write-Host "4. Configure fnm, exa, fzf, zoxide and starship script in your terminal profile (e.g., PowerShell, cmd, etc.)"
    Write-Host "5. Enjoy your new development environment! 🎉"
}

# ------------------------
# Run Setup
# ------------------------
Start-DevSetup
