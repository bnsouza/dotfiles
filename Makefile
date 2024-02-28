DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
HOMEBREW_PREFIX := $(shell bin/is-supported bin/is-arm64 /opt/homebrew /usr/local)
PATH := $(HOMEBREW_PREFIX)/bin:$(DOTFILES_DIR)/bin:$(PATH)
SHELL := env PATH=$(PATH) /bin/bash
BIN := $(HOMEBREW_PREFIX)/bin
export XDG_CONFIG_HOME = $(HOME)/.config
export STOW_DIR = $(DOTFILES_DIR)
export ACCEPT_EULA=Y

all: sudo core packages link macosdefaults files

sudo:
ifndef GITHUB_ACTION
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

core: brew zsh git nvm

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | zsh

zsh:
	if [ ! -d "$$HOME/.oh-my-zsh" ]; then \
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; \
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	fi

git: brew
	brew install git git-extras

nvm: brew-packages
	# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
	# nvm install --lts

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile || true

packages: brew-packages cask-apps # node-packages

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true

# node-packages: nvm
# 	$(which npm) install --force --location global $(shell cat install/npmfile)

stow: brew
	is-executable stow || brew install stow

link: stow
	for FILE in $$(\ls -A bnsouza); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) bnsouza
	stow -t $(XDG_CONFIG_HOME) config
	mkdir -p $(HOME)/.local/runtime
	chmod 700 $(HOME)/.local/runtime

unlink: stow
	stow --delete -t $(HOME) bnsouza
	stow --delete -t $(XDG_CONFIG_HOME) config
	for FILE in $$(\ls -A bnsouza); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

macosdefaults:
	source $(DOTFILES_DIR)/macosdefaults.sh

files:
	mkdir -p $(HOME)/Library/KeyBindings
	cp -v files/DefaultKeyBinding.Dict $(HOME)/Library/KeyBindings/DefaultKeyBinding.Dict
	cp -v files/com.googlecode.iterm2.plist $(HOME)/Library/Preferences/com.googlecode.iterm2.plist
