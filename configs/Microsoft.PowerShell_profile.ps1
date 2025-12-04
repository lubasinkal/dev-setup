# PowerShell Profile - Enhanced Development Environment
# Place this file in: $PROFILE

# ================
#  Error Handling
# ================
$ErrorActionPreference = 'Stop'

# ================
#  Environment Variables
# ================
$env:EDITOR = 'nvim'
$env:GIT_EDITOR = 'code --wait'

# Development paths
$env:DEV_ROOT = Join-Path $env:USERPROFILE 'dev'
$env:PERSONAL_DEV = Join-Path $env:DEV_ROOT 'personal'
$env:WORK_DEV = Join-Path $env:DEV_ROOT 'work'

# Tool configurations
$env:STARSHIP_CONFIG = Join-Path $env:USERPROFILE '.config\starship\starship.toml'
$env:YAZI_CONFIG_HOME = Join-Path $env:USERPROFILE '.config\yazi'

# ================
#  Aliases
# ================
## Enhanced Directory Functions (eza)
function ls { eza $args --icons }
function ll { eza $args -a -l -F --icons --group-directories-first --header }
function la { eza $args -A --icons --group-directories-first --header }
function l { eza $args -F --icons --group-directories-first --header }
function lt { eza $args -T --icons --group-directories-first --header }
function lg { eza $args --git --icons --group-directories-first --header }

## Development Functions
function c { clear }
function reload { . $PROFILE }function reload { . $PROFILE }
# Git aliases (enhanced - defined as functions for proper argument passing)
# Use $args to pass all arguments received by the function to the underlying command.

function gst { git status -sb }
function gco { git checkout $args }
function gbr { git branch $args }
function gcm { git commit -m $args }
function gca { git commit --amend --no-edit }
function gp { git push $args }
function gl { git pull --rebase $args }
function gd { git diff $args }
function gds { git diff --staged $args }
function ga { git add $args }
function gaa { git add --all }
function grs { git restore --staged $args }
function gr { git restore $args }# Utility aliases
# Utility aliases (assuming rg, fd, bat, and btop are installed)
function grep { rg $args --color always } # Kept as function
function find { fd $args }
function cat { bat $args }
function ps { Get-Process $args } # Converted to function for argument passing# ================
#  Functions
# ================

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

# Quick project search
function proj {
    param([string]$ProjectName)
    $searchDirs = @($env:PERSONAL_DEV, $env:WORK_DEV, $env:DEV_ROOT)

    foreach ($dir in $searchDirs) {
        if (Test-Path $dir) {
            $found = Get-ChildItem -Path $dir -Directory -Recurse | Where-Object { $_.Name -like "*$ProjectName*" } | Select-Object -First 1
            if ($found) {
                Set-Location $found.FullName
                Write-Host "Found project: $($found.Name)" -ForegroundColor Green
                return
            }
        }
    }
    Write-Host "No project found matching: $ProjectName" -ForegroundColor Red
}

# System information
function sysinfo {
    Write-Host "=== System Information ===" -ForegroundColor Cyan
    Write-Host "OS: $(Get-WmiObject -Class Win32_OperatingSystem).Caption"
    Write-Host "PowerShell: $($PSVersionTable.PSVersion)"
    Write-Host "User: $env:USERNAME@$env:COMPUTERNAME"
    Write-Host "Shell: $env:SHELL"
    Write-Host "Editor: $env:EDITOR"
    Write-Host "=========================" -ForegroundColor Cyan
}

# ================
#  Tool Initializations
# ================

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


