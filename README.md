# dev-setup

A PowerShell script to bootstrap a modern development environment on Windows.

This setup includes essential tools, configuration files, and developer-friendly defaults to get you up and running quickly.

## Features

* ✅ Automated installation of Scoop and Winget packages
* ✅ Custom config installation for:

  * WezTerm terminal
  * Starship prompt
  * Neovim config (cloned from GitHub)
* ✅ Handles idempotency (won't reinstall existing apps)
* ✅ Backs up existing Neovim config before replacing

## Installation

1. Clone this repo:

   ```powershell
   git clone https://github.com/lubasinkal/dev-setup.git
   cd dev-setup
   ```

2. Run the setup script (as administrator):

   ```powershell
   .\init.ps1
   ```

> ⚠️ Make sure script execution is enabled: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`

## Requirements

* Windows 10/11
* Administrator access to install applications

## What's Included

### Scoop Apps

* 7zip
* ani-cli
* aria2
* fzf
* yazi
* superfile

### Winget Apps

Includes Git, Neovim, NodeJS, Go, Python, Rust, WezTerm, Starship, Lazygit, VS Code, and more.

## Custom Configs

* `configs/wezterm.lua` → copied to `$LOCALAPPDATA\wezterm`
* `configs/starship.toml` → copied to `$USERPROFILE\.config\starship`
* Neovim config cloned from: [github.com/lubasinkal/nvim](https://github.com/lubasinkal/nvim)

## License

MIT License. Feel free to fork and adapt for your workflow.
