# Windows Development Setup

A comprehensive, automated development environment setup for Windows developers. This repository provides a complete dotfiles setup with modern tools, configurations, and productivity enhancements.

## 🚀 Features

### Core Tools
- **Package Management**: Scoop + Winget for comprehensive package management
- **Terminal**: WezTerm with custom configuration and keybindings
- **Shell**: Enhanced PowerShell with aliases, functions, and integrations
- **Prompt**: Starship with custom, informative prompt
- **Editor**: Neovim with automated config cloning
- **Version Control**: Git with enhanced aliases and delta diff viewer

### Development Tools
- **Languages**: Python, Node.js (via fnm), Go, Rust, Zig
- **File Management**: exa (ls replacement), fd (find replacement), yazi (file manager)
- **Search**: ripgrep (rg) for fast text search
- **Git Tools**: lazygit for enhanced git workflow
- **Navigation**: zoxide for smart directory navigation
- **Terminal Multiplexing**: Built-in WezTerm pane management

### Productivity Features
- **Smart Aliases**: Comprehensive aliases for common operations
- **Project Navigation**: Quick project discovery and navigation
- **Environment Management**: Template-based environment variables
- **Backup Strategy**: Automatic backup of existing configurations
- **Error Handling**: Robust error handling throughout setup process

## 📋 Prerequisites

- Windows 10/11
- PowerShell 5.1+ (PowerShell 7+ recommended)
- Administrator access (for some package installations)

## 🛠️ Quick Start

### 1. Clone the Repository
```powershell
git clone https://github.com/lubasinkal/dev-setup.git
cd dev-setup
```

### 2. Run the Setup
```powershell
.\init.ps1
```

### 3. Restart Your Terminal
Close and reopen your terminal to load the new configuration.

### 4. Customize Your Environment
Edit the `.env` file with your personal settings:
```powershell
code .env
```

## 📁 Repository Structure

```
dev-setup/
├── init.ps1                    # Main setup script
├── packages.txt                # Winget package list
├── .env.template              # Environment variables template
├── CRUSH.md                   # Development commands and standards
├── README.md                  # This file
└── configs/
    ├── .gitconfig             # Git configuration
    ├── .gitconfig.template    # Git config template
    ├── .wezterm.lua           # WezTerm configuration
    ├── starship.toml          # Starship prompt config
    ├── .bashrc                # Bash configuration
    └── Microsoft.PowerShell_profile.ps1  # PowerShell profile
```

## ⚙️ What Gets Installed

### Development Tools
- **Core**: Git, GitHub CLI, Make, Unzip, 7zip
- **Editors**: Neovim, VS Code
- **Languages**: Python, Node.js, Go, Rust, Zig
- **Package Managers**: Scoop, fnm (Node.js), pnpm, uv (Python)
- **Terminal**: WezTerm, PowerShell, Nushell

### Productivity Tools
- **File Utils**: exa, fd, yazi, bat, delta
- **Search**: ripgrep, fzf
- **Git**: lazygit
- **Navigation**: zoxide
- **System**: fastfetch, neofetch

### Development Environment
- **Directories**: Structured dev directories (personal, work, open-source, etc.)
- **Configuration**: All tool configurations automatically applied
- **Aliases**: Comprehensive command aliases
- **Environment**: Template-based environment setup

## 🎯 Key Features

### Enhanced PowerShell Profile
- Smart aliases for common operations
- Project navigation functions
- Tool integrations (starship, fnm, zoxide)
- Custom functions for productivity

### WezTerm Configuration
- Custom keybindings for pane management
- Optimized color scheme and appearance
- Multiple shell options (PowerShell, Bash, Nushell)
- Productivity-focused layout

### Git Configuration
- Enhanced aliases for common git operations
- Delta diff viewer for better diffs
- Smart merge and rebase settings
- GPG signing support (optional)

### Starship Prompt
- Custom, informative prompt
- Git status and branch information
- Python virtual environment display
- Clean, minimal design

## 📖 Usage Guide

### Daily Commands
```powershell
# Navigation
dev personal          # Go to personal dev directory
proj myproject        # Find and jump to project
y                    # Launch yazi file manager

# Git operations
gst                  # Git status
gcm "commit message" # Git commit with message
gp                   # Git push
gl                   # Git pull with rebase

# File operations
ll                   # Detailed file listing
find filename        # Find files
grep pattern         # Search in files

# System info
sysinfo              # Show system information
fastfetch            # Display system stats
```

### Development Workflow
```powershell
# Start new project
dev personal
mkcd new-project
git init
code .

# Node.js development
fnm install 20
fnm use 20
pnpm install
pnpm dev

# Python development
uv venv
uv pip install -r requirements.txt
uv run python main.py
```

## 🔧 Customization

### Adding New Packages
Edit `init.ps1` and add packages to the appropriate function:
```powershell
# For Scoop packages
scoop install new-package

# For Winget packages
"NewPackage.NewPackage"
```

### Custom Aliases
Add to `configs/Microsoft.PowerShell_profile.ps1`:
```powershell
Set-Alias -Name myalias -Value { your-command }
```

### Environment Variables
Edit `.env` file with your specific values:
```bash
MY_CUSTOM_VAR=some_value
API_KEY=your_api_key_here
```

## 🔄 Maintenance

### Update All Packages
```powershell
# Update Scoop packages
scoop update *

# Update Winget packages
winget upgrade --all
```

### Backup Configuration
The setup automatically backs up existing configurations. Manual backup:
```powershell
# Backup current configs
Copy-Item $PROFILE "$PROFILE.bak"
Copy-Item ~/.gitconfig ~/.gitconfig.bak
```

### Reset Configuration
To reset to default configurations:
```powershell
# Remove current configs
Remove-Item $PROFILE
Remove-Item ~/.gitconfig
Remove-Item ~/.wezterm.lua

# Re-run setup
.\init.ps1
```

## 🐛 Troubleshooting

### Common Issues

#### PowerShell Execution Policy
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Scoop Installation Issues
```powershell
# Install Scoop manually
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod get.scoop.sh | Invoke-Expression
```

#### Git Configuration
```powershell
# Set your git identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

#### Path Issues
Restart your terminal or run:
```powershell
. $PROFILE
```

### Getting Help
- Check the [CRUSH.md](CRUSH.md) for detailed commands
- Review individual config files in `configs/`
- Check package documentation for specific tools

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Development Guidelines
- Follow the code style in [CRUSH.md](CRUSH.md)
- Test changes on a fresh Windows installation
- Update documentation for any new features
- Maintain backward compatibility when possible

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Scoop](https://scoop.sh/) for Windows package management
- [Starship](https://starship.rs/) for the awesome prompt
- [WezTerm](https://wezfurlong.org/wezterm/) for the terminal emulator
- [Neovim](https://neovim.io/) for the editor
- The Windows development community for inspiration and tools

## 📞 Support

If you encounter issues or have questions:
1. Check the troubleshooting section above
2. Review the [CRUSH.md](CRUSH.md) for command reference
3. Open an issue on GitHub with detailed information
4. Include your Windows version and PowerShell version in bug reports

---

**Happy Coding! 🎉**
