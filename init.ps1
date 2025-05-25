
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
        Write-Host "Scoop already installed."
    }
}

# -----------------------------
# Function: Install Scoop Apps
# -----------------------------
function Install-ScoopApps {
    scoop bucket add main extras
    scoop install `
        7zip `
        ani-cli `
        aria2 `
        fzf `
        yazi `
        main/superfile `
}

# -----------------------------
# Function: Install Winget Apps
# -----------------------------
function Install-WingetApps {
    $wingetPackages = @(
        "CoreyButler.NVMforWindows",
        "7zip.7zip",
        "Git.Git",
        "ImageMagick.ImageMagick",
        "RProject.R",
        "vim.vim",
        "Zen-Team.Zen-Browser",
        "HTTPie.HTTPie",
        "nepnep.neofetch-win",
        "Neovim.Neovim",
        "GitHub.cli",
        "Nushell.Nushell",
        "wez.wezterm",
        # "Microsoft.PowerShell",
        "OpenJS.NodeJS.LTS",
        "GoLang.Go",
        "Starship.Starship",
        "GnuWin32.Make",
        # "Posit.RStudio",
        "GnuWin32.UnZip",
        "Python.Launcher",
        "BurntSushi.ripgrep.MSVC",
        "Fastfetch-cli.Fastfetch",
        "GitHub.GitHubDesktop",
        # "Gyan.FFmpeg",
        "JernejSimoncic.Wget",
        "JesseDuffield.lazygit",
        "Rustlang.Rustup",
        "Schniz.fnm",
        "ajeetdsouza.zoxide",
        "astral-sh.uv",
        # "RedHat.Podman-Desktop",
        "jqlang.jq",
        "junegunn.fzf",
        "pnpm.pnpm",
        "sharkdp.fd",
        "sxyazi.yazi",
        "Warp.Warp",
        "Python.Python",
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
        # Optional: Append timestamp to avoid overwriting old backup
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backupPath = "$env:LOCALAPPDATA\nvim.bak-$timestamp"

        Write-Host "⚠️ Neovim config exists. Backing up to $backupPath..."
        Rename-Item -Path $configPath -NewName ("nvim.bak-" + $timestamp)
    }

    Write-Host "📥 Cloning latest Neovim config from GitHub..."
    git clone https://github.com/lubasinkal/nvim $configPath
}

# ------------------------
# Run Setup
# ------------------------
Write-Host "`n==> Running development environment setup..." -ForegroundColor Cyan

# Install-Scoop
# Install-ScoopApps
# Install-WingetApps
# Clone-NeovimConfig
Copy-ConfigFiles

Write-Host "`n==> Setup complete!" -ForegroundColor Green

