# PowerShell Profile - Enhanced Development Environment

$ErrorActionPreference = 'Stop'

$env:EDITOR = 'nvim'
$env:GIT_EDITOR = 'code --wait'

# Development paths
$env:DEV_ROOT = Join-Path $env:USERPROFILE 'dev'
$env:PERSONAL_DEV = Join-Path $env:DEV_ROOT 'personal'
$env:WORK_DEV = Join-Path $env:DEV_ROOT 'work'

# Tool configurations
$env:STARSHIP_CONFIG = Join-Path $env:USERPROFILE '.config\starship\starship.toml'
$env:YAZI_CONFIG_HOME = Join-Path $env:USERPROFILE '.config\yazi'

## Enhanced Directory Functions (eza)
function ll { eza $args -a -l -F --icons --group-directories-first --header }
function la { eza $args -A --icons --group-directories-first --header }
function l { eza $args --icons --group-directories-first --header }
function lt { eza $args -T --icons --group-directories-first --header }
function lg { eza $args --git --icons --group-directories-first --header }

## Development Functions
function c { clear }
function reload { . $PROFILE }function reload { . $PROFILE }
function ps { Get-Process $args } # Converted to function for argument passing# ================

# Enhanced cd with zoxide integration
function cd {
    param([string]$Path)
    if ($Path) {
        Set-Location $Path
        # Update zoxide database
        if (Get-Command zoxide -ErrorAction SilentlyContinue) {
            zoxide add $Path
        }
    }
}

# Make directory and cd into it
function mkcd {
    param([string]$Path)
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location $Path
    if (Get-Command zoxide -ErrorAction SilentlyContinue) {
        zoxide add $Path
    }
}

# Quick navigation to dev directories
function dev {
    param([string]$SubDir = '')
    $baseDir = $env:DEV_ROOT
    if ($SubDir) {
        $targetDir = Join-Path $baseDir $SubDir
        if (Test-Path $targetDir) {
            Set-Location $targetDir
        } else {
            Write-Host "Directory '$targetDir' does not exist." -ForegroundColor Red
        }
    } else {
        Set-Location $baseDir
    }
}

# Enhanced yazi integration
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    try {
        yazi $args --cwd-file=$tmp
        if (Test-Path $tmp) {
            $cwd = Get-Content $tmp
            if ($cwd -and $cwd -ne $PWD) {
                Set-Location $cwd
            }
        }
    }
    finally {
        if (Test-Path $tmp) {
            Remove-Item $tmp
        }
    }
}
# Starship prompt
if (Get-Command starship -ErrorAction SilentlyContinue) {
   function Invoke-Starship-TransientFunction {
  &starship module character
}

Invoke-Expression (&starship init powershell)

Enable-TransientPrompt
}

# fnm (Fast Node Manager)
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}

# zoxide (smart cd)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })}


