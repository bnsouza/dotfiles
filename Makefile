DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
HOMEBREW_PREFIX := $(shell bin/is-supported bin/is-arm64 /opt/homebrew /usr/local)
PATH := $(HOMEBREW_PREFIX)/bin:$(DOTFILES_DIR)/bin:$(PATH)
SHELL := env PATH=$(PATH) /bin/bash
BIN := $(HOMEBREW_PREFIX)/bin
USER_DIR := $(shell basename $(HOME))
export XDG_CONFIG_HOME = $(HOME)/.config
export STOW_DIR = $(DOTFILES_DIR)
export ACCEPT_EULA=Y

all: sudo core packages link macosdefaults files

sudo:
ifndef GITHUB_ACTION
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

core: brew zsh git

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | zsh

zsh:
	if [ ! -d "$$HOME/.oh-my-zsh" ]; then \
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; \
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	fi

git: brew
	brew install git git-extras

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile || true

packages: brew-packages cask-apps # node-packages

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true

stow: brew
	is-executable stow || brew install stow

link: stow
	for FILE in $$(\ls -A $(USER_DIR)); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) $(USER_DIR)
	stow -t $(XDG_CONFIG_HOME) config
	mkdir -p $(HOME)/.local/runtime
	chmod 700 $(HOME)/.local/runtime

unlink: stow
	stow --delete -t $(HOME) $(USER_DIR)
	stow --delete -t $(XDG_CONFIG_HOME) config
	for FILE in $$(\ls -A $(USER_DIR)); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

macosdefaults:
	source $(DOTFILES_DIR)/macosdefaults.sh

files:
	mkdir -p $(HOME)/Library/KeyBindings
	cp -v files/DefaultKeyBinding.Dict $(HOME)/Library/KeyBindings/DefaultKeyBinding.Dict
	cp -v files/com.googlecode.iterm2.plist $(HOME)/Library/Preferences/com.googlecode.iterm2.plist

	# Configurações do Raycast (apenas o template, token deve ser configurado manualmente)
	mkdir -p $(XDG_CONFIG_HOME)/raycast
	if [ ! -f $(XDG_CONFIG_HOME)/raycast/config.json ]; then \
		cp -v config/raycast/config.json.template $(XDG_CONFIG_HOME)/raycast/config.json; \
		echo "⚠️  Configure seu token do Raycast em ~/.config/raycast/config.json"; \
	fi

# Limpeza e manutenção moderna
cleanup:
	@echo "🧹 Limpando extensões do VS Code..."
	@$(DOTFILES_DIR)/scripts/cleanup_vscode.sh
	@echo "🧹 Limpando Homebrew..."
	@brew cleanup
	@brew autoremove
	@echo "✅ Limpeza concluída!"

# Instala plugins modernos do zsh (se ainda não estiverem instalados)
zsh-plugins:
	@echo "🐚 Configurando plugins modernos do zsh..."
	@if [ ! -d "$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then \
		git clone https://github.com/zsh-users/zsh-autosuggestions $${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions; \
	fi
	@if [ ! -d "$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-completions" ]; then \
		git clone https://github.com/zsh-users/zsh-completions $${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-completions; \
	fi
	@echo "✅ Plugins do zsh instalados!"

# Setup moderno completo
setup-modern: all zsh-plugins
	@echo "🚀 Setup moderno dos dotfiles concluído!"
	@echo "💡 Execute 'make cleanup' para remover pacotes e extensões antigas"
	@echo "⚠️  Lembre-se de reiniciar seu terminal para usar os novos aliases e plugins"
