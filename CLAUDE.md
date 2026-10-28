# CLAUDE.md

Guidance for Claude Code (claude.ai/code) when working in this repository.

## Overview

Personal macOS dotfiles. Uses GNU Stow for symlink management and Homebrew for package
management. Anything that ends up in `$HOME` is either a symlink into this repo
(`bnsouza/`, `config/`) or a copy (`files/`).

## Structure

- `Makefile` — entry point. Targets: `setup`, `all`, `core`, `packages`, `link`, `unlink`,
  `macosdefaults`, `files`, `zsh-plugins`, `cleanup`.
- `bin/` — utilities added to PATH. `dot` is the umbrella command (`dot clean`,
  `dot update`, `dot macos`, `dot edit`).
- `bnsouza/` — files symlinked into `$HOME` (`.zshrc`, `.alias`, `.inputrc`, `.tokens`,
  `.p10k.zsh`, `.yabairc`).
  The directory name is detected dynamically (`USER_DIR := $(shell basename $(HOME))`),
  so the repo works for any user.
- `config/` — files symlinked into `$XDG_CONFIG_HOME` (`git/`, `gh/`, `karabiner/`,
  `raycast/` — config template + `scripts/` with Raycast Script Commands that use yabai).
- `install/Brewfile` — CLI packages + VS Code extensions.
- `install/Caskfile` — GUI applications.
- `files/` — plists copied (not symlinked) by `make files` (iTerm2, DefaultKeyBinding).
- `macosdefaults.sh` — `defaults write …` statements; reapply with `make macosdefaults`.

## Conventions

- `bnsouza/.tokens` is gitignored. Never commit secrets.
- Infisical login is **lazy** — defined as the `infisical-login` function in `.zshrc`,
  not as a synchronous network call at shell startup. Don't reintroduce a sync call.
- Comments in shell/config files are written in Portuguese (BR) to match the repo style.
- The README is the user-facing reference; this file is for assistants.
- The Makefile uses `export PATH :=` + `SHELL := /bin/bash`. Don't go back to
  `SHELL := env PATH=$(PATH) …` — it breaks when PATH has spaces (e.g. `~/Library/Application Support/...`).
- Third-party tap formulae in the Brewfile need both `tap "…"` and the fully qualified name.

## Common operations

```bash
make setup            # first-time install (= all + zsh-plugins)
make link / unlink    # re-create / remove symlinks (auto-backs up existing files to .bak)
make packages         # brew bundle (Brewfile + Caskfile)
make macosdefaults    # re-apply macosdefaults.sh
make cleanup          # brew cleanup + autoremove
dot update            # brew update + upgrade + cleanup
dot clean             # purge caches (brew, gem, pip)
```

## When editing this repo

- Edits to files inside `bnsouza/` or `config/` take effect immediately (symlinks).
- Edits to `files/*` require `make files` to reapply (they are copies).
- After adding a new file in `bnsouza/` or `config/`, run `make link`.
- After editing `install/Brewfile`, run `brew bundle --file=install/Brewfile`.
- `brew bundle` does not uninstall — packages removed from the Brewfile must be
  uninstalled manually with `brew uninstall <name>`.
