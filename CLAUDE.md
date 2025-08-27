# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal macOS dotfiles repository that manages system configuration, application preferences, and development environment setup using GNU Stow for symlink management and Homebrew for package management.

## Architecture

### Core Structure
- **`Makefile`**: Main automation entry point with staged setup process
- **`bin/`**: Utility scripts for system detection and helper functions
- **`bnsouza/`**: Personal configuration files (shell, aliases, tokens) - managed by Stow
- **`config/`**: Application configurations (Git, Karabiner) - managed by Stow
- **`install/`**: Package definitions (Brewfile, Caskfile)
- **`files/`**: System preference files and application plists
- **`macosdefaults.sh`**: macOS system defaults and preferences

### Package Management System
- **Homebrew packages**: `install/Brewfile` (CLI tools, development packages)
- **Cask applications**: `install/Caskfile` (GUI applications)
- **VS Code extensions**: Defined in Brewfile with `vscode "extension.name"`

### Configuration Management
Uses GNU Stow for symlink management:
- `bnsouza/` → `$HOME/` (personal configs like .zshrc, .alias)
- `config/` → `$XDG_CONFIG_HOME` (~/.config) (application configs)

## Common Commands

### Initial Setup
```bash
make all                    # Complete setup: sudo, core, packages, link, macosdefaults, files
```

### Individual Setup Steps
```bash
make sudo                   # Request sudo access for automated operations
make core                   # Install core components: brew, zsh, git, nvm
make packages              # Install all packages: brew packages + cask apps
make link                  # Create symlinks using Stow
make macosdefaults         # Apply macOS system defaults
make files                 # Copy system files and preferences
```

### Package Management
```bash
make brew-packages         # Install CLI tools from Brewfile
make cask-apps            # Install GUI applications from Caskfile
```

### Symlink Management
```bash
make link                 # Create symlinks for dotfiles
make unlink              # Remove symlinks and restore backups
```

### Utility Commands (via bin/dot)
```bash
dot clean                 # Clean up caches (brew, cargo, gem, pip)
dot update               # Update all packages and package managers
dot macos                # Apply macOS system defaults
dot test                 # Run tests
dot edit                 # Open dotfiles in IDE
```

## Development Environment

### Shell Configuration
- **Shell**: Zsh with Oh My Zsh framework
- **Theme**: Powerlevel10k
- **Key Features**:
  - Automatic Node version switching via `.nvmrc`
  - Custom aliases for development workflows
  - Syntax highlighting and autocompletion

### Key Tools and Frameworks
- **Package Managers**: Homebrew, npm/pnpm/bun, pip, poetry
- **Version Managers**: nvm (Node.js), pyenv (Python)
- **Development**: Git, VS Code, Docker (OrbStack), AWS CLI
- **Languages**: Node.js, Python, PHP (multiple versions)

### Custom Functions
Located in `bnsouza/.alias`:
- **`certificado()`**: Digital certificate processing for Brazilian business workflows
- **`nfe-download()`**: Electronic invoice file management from AWS S3
- **`renomear_s3()`**: AWS S3 file renaming utility

## Configuration Files

### Core Shell Files
- **`.zshrc`**: Main shell configuration with theme, plugins, and environment setup
- **`.alias`**: Custom aliases and business-specific functions
- **`.inputrc`**: Readline key bindings
- **`.tokens`**: Environment variables and API tokens (excluded from version control)

### Application Configurations
- **Git**: `config/git/config` and `config/git/ignore`
- **Karabiner Elements**: `config/karabiner/karabiner.json` (keyboard customization)
- **iTerm2**: `files/com.googlecode.iterm2.plist`

### System Integration
- **Key Bindings**: `files/DefaultKeyBinding.Dict` for macOS text navigation
- **macOS Defaults**: Finder, Dock, system behavior, and performance optimizations

## Maintenance

### Adding New Packages
- **CLI tools**: Add to `install/Brewfile`
- **GUI apps**: Add to `install/Caskfile`
- **VS Code extensions**: Add to Brewfile as `vscode "extension-id"`

### System Updates
Use `dot update` (powered by topgrade) for comprehensive system updates including:
- Homebrew packages and casks
- Node.js packages (npm/pnpm/bun)
- Python packages (pip/poetry)
- macOS system updates
- VS Code extensions

### Backup and Restore
- Configuration files are backed up automatically during `make link`
- Use `make unlink` to restore original files from `.bak` copies
- Karabiner configurations include automatic backups in `config/karabiner/automatic_backups/`
