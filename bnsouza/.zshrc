# Habilitar prompt instantâneo do Powerlevel10k. Deve ficar próximo ao topo do ~/.zshrc.
# Código de inicialização que pode requerer entrada do console (prompts de senha, confirmações [y/n],
# etc.) deve ir acima deste bloco; tudo mais pode ir abaixo.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Caminho para instalação do oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

HIST_STAMPS="yyyy-mm-dd"

# Tema
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins - Seleção moderna para workflow de desenvolvimento
plugins=(
  git                    # Shortcuts e completions do Git
  vscode                 # Shortcuts do VS Code
  node                   # Completions do Node.js
  npm                    # Completions do npm
  docker                 # Completions e shortcuts do Docker
  aws                    # Completions da AWS CLI
  macos                  # Shortcuts específicos do macOS
  zsh-autosuggestions   # Sugestões de comandos baseadas no histórico
  zsh-completions       # Completions adicionais
)

source $ZSH/oh-my-zsh.sh

# Editor preferido para sessões locais e remotas
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='code'
else
  export EDITOR='nano'
fi

# Para customizar o prompt, execute `p10k configure` ou edite ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
source $HOME/.alias

# Keybindings
source $HOME/.inputrc

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Carrega o nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Carrega bash completion do nvm

# NVM muda versão quando pasta tem arquivo `.nvmrc`
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Revertendo para versão padrão do nvm"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Auto Complete
autoload -Uz compinit
zstyle ':completion:*' menu select

# Homebrew
export HOMEBREW_NO_ENV_HINTS=1

# ZSH Syntax Highlight
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# pnpm - Usa $HOME para funcionar com qualquer usuário
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun completions - Usa $HOME para funcionar com qualquer usuário
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Tokens
source $HOME/.tokens

# Infisical
export INFISICAL_TOKEN=$(infisical login --method=universal-auth --silent --plain)
