# Minimal PowerShell Profile - Fast Loading

$env:EDITOR = 'nvim'
$env:GIT_EDITOR = 'code --wait'
$env:DEV_ROOT = Join-Path $env:USERPROFILE 'dev'

# Essential eza aliases
function ll { eza $args -alF --icons --group-directories-first }
function la { eza $args -A --icons --group-directories-first }
function l { eza $args --icons --group-directories-first }
function lt { eza $args -T --icons --group-directories-first }

# Essential functions
function c { clear }
function reload { . $PROFILE }
function mkcd { param([string]$Path) New-Item -ItemType Directory -Path $Path -Force | Out-Null; Set-Location $Path }
function dev { param([string]$SubDir = '') $target = if ($SubDir) { Join-Path $env:DEV_ROOT $SubDir } else { $env:DEV_ROOT }; if (Test-Path $target) { Set-Location $target } }

# yazi integration
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    try { yazi $args --cwd-file=$tmp; if (Test-Path $tmp) { $cwd = Get-Content $tmp; if ($cwd -and $cwd -ne $PWD) { Set-Location $cwd } } }
    finally { if (Test-Path $tmp) { Remove-Item $tmp } }
}

# Fast tool initialization
if (Get-Command starship -ErrorAction SilentlyContinue) { Invoke-Expression (&starship init powershell) }
if (Get-Command fnm -ErrorAction SilentlyContinue) { fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression }
if (Get-Command zoxide -ErrorAction SilentlyContinue) { Invoke-Expression (& { (zoxide init powershell | Out-String) }) }


