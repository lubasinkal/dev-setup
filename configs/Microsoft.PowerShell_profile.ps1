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
$env:BROWSER = 'chrome'

# Development paths
$env:DEV_ROOT = Join-Path $env:USERPROFILE 'dev'
$env:PERSONAL_DEV = Join-Path $env:DEV_ROOT 'personal'
$env:WORK_DEV = Join-Path $env:DEV_ROOT 'work'

# Tool configurations
$env:STARSHIP_CONFIG = Join-Path $env:USERPROFILE '.config\starship\starship.toml'
$env:YAZI_CONFIG_HOME = Join-Path $env:USERPROFILE '.config\yazi'

# ================
#  PATH Extensions
# ================
# Add common development tools to PATH
$pathsToAdd = @(
    'C:\Program Files\Neovim\bin',
    'C:\Program Files\Git\bin',
    'C:\Program Files\GitHub CLI\bin',
    'C:\Users\*\scoop\shims',
    'C:\Users\*\fnm',
    'C:\Program Files\Go\bin',
    'C:\Users\*\go\bin',
    'C:\Users\*\cargo\bin',
    'C:\Program Files\Python\Python*\Scripts',
    'C:\Program Files\Python\Python*',
    'C:\Program Files\nodejs',
    'C:\Users\*\AppData\Local\pnpm',
    'C:\Users\*\AppData\Roaming\npm'
)

foreach ($path in $pathsToAdd) {
    $resolvedPaths = Resolve-Path $path -ErrorAction SilentlyContinue
    foreach ($resolvedPath in $resolvedPaths) {
        if ($resolvedPath.Path -notin $env:PATH.Split(';')) {
            $env:PATH += ";$($resolvedPath.Path)"
        }
    }
}

# ================
#  Aliases
# ================
# Enhanced ls replacements
Set-Alias -Name ll -Value { eza -a -l -F --icons --group-directories-first --header }
Set-Alias -Name la -Value { eza -A --icons --group-directories-first --header }
Set-Alias -Name l -Value { eza -F --icons --group-directories-first --header }
Set-Alias -Name lt -Value { eza -T --icons --group-directories-first --header }
Set-Alias -Name lg -Value { eza --git --icons --group-directories-first --header }

# Development aliases
Set-Alias -Name c -Value clear
Set-Alias -Name reload -Value { . $PROFILE }
Set-Alias -Name vim -Value nvim
Set-Alias -Name vi -Value nvim
Set-Alias -Name k -Value kubectl
Set-Alias -Name d -Value docker
Set-Alias -Name dc -Value docker-compose

# Git aliases (enhanced)
Set-Alias -Name gst -Value { git status -sb }
Set-Alias -Name gco -Value { git checkout }
Set-Alias -Name gbr -Value { git branch }
Set-Alias -Name gcm -Value { git commit -m }
Set-Alias -Name gca -Value { git commit --amend --no-edit }
Set-Alias -Name gp -Value { git push }
Set-Alias -Name gl -Value { git pull --rebase }
Set-Alias -Name gd -Value { git diff }
Set-Alias -Name gds -Value { git diff --staged }
Set-Alias -Name ga -Value { git add }
Set-Alias -Name gaa -Value { git add --all }
Set-Alias -Name grs -Value { git restore --staged }
Set-Alias -Name gr -Value { git restore }

# Utility aliases
Set-Alias -Name grep -Value { rg --color always }
Set-Alias -Name find -Value fd
Set-Alias -Name cat -Value bat
Set-Alias -Name top -Value btop
Set-Alias -ame ps -Value { Get-Process }

# ================
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
    Invoke-Expression (&starship init powershell)
}

# fnm (Fast Node Manager)
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    Invoke-Expression (&fnm env --use-on-cd --shell powershell)
}

# zoxide (smart cd)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (&zoxide init powershell)
}

# ================
#  Welcome Message
# ================
Write-Host "🚀 PowerShell Development Environment Loaded" -ForegroundColor Green
Write-Host "Type 'sysinfo' for system information" -ForegroundColor Gray
Write-Host "Type 'dev <dir>' to navigate to dev directories" -ForegroundColor Gray
Write-Host "Type 'proj <name>' to search for projects" -ForegroundColor Gray
