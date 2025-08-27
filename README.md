# 🏠 Dotfiles do Bruno Souza

Configuração personalizada do macOS otimizada para desenvolvimento web moderno.

## 📋 Visão Geral

Este repositório contém toda a configuração do meu ambiente de desenvolvimento macOS, incluindo:

- **Shell**: Zsh com Oh My Zsh + Powerlevel10k
- **Packages**: Homebrew com ferramentas modernas de CLI
- **Apps**: Aplicações essenciais via Homebrew Cask
- **VS Code**: Extensões otimizadas para desenvolvimento web
- **macOS**: Configurações de sistema personalizadas

## 🚀 Instalação Completa (Computador Novo)

### Primeira Instalação
```bash
# Clone o repositório
git clone https://github.com/bnsouza/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Setup completo + plugins modernos
make setup-modern
```

### O que o `setup-modern` faz:
1. ✅ Instala Homebrew
2. ✅ Configura Zsh + Oh My Zsh + Powerlevel10k
3. ✅ Instala Git e ferramentas essenciais
4. ✅ Instala todos os packages (Brewfile)
5. ✅ Instala todas as aplicações (Caskfile)
6. ✅ Cria symlinks dos dotfiles (Stow)
7. ✅ Aplica configurações macOS
8. ✅ Copia arquivos de sistema
9. ✅ Instala plugins modernos do Zsh

---

## 🛠️ Comandos Principais

### Setup e Instalação
```bash
make all              # Setup completo tradicional
make setup-modern     # Setup completo + plugins modernos (recomendado)
make zsh-plugins      # Instala apenas os plugins do Zsh
```

### Instalação Seletiva
```bash
make core             # Apenas ferramentas essenciais (brew, zsh, git)
make packages         # Apenas packages brew + cask apps
make link             # Apenas symlinks (stow)
make macosdefaults    # Apenas configurações macOS
make files            # Apenas arquivos de sistema
```

### Manutenção
```bash
make cleanup          # Limpa VS Code + Homebrew
dot update           # Atualiza tudo (packages, apps, sistema)
dot clean            # Limpa caches (brew, cargo, gem, pip)
```

### Gerenciamento de Links
```bash
make link             # Cria symlinks (com backup automático)
make unlink          # Remove symlinks (restaura backups)
```

### 🛡️ Sistema de Backup
O sistema agora inclui backup automático:
- **Durante `make link`**: Arquivos existentes são salvos como `.bak`
- **Durante `make unlink`**: Arquivos `.bak` são restaurados automaticamente
- **Segurança**: Seus arquivos originais nunca são perdidos

**Exemplo**:
```bash
# Se você já tem ~/.zshrc, ele vira ~/.zshrc.bak
make link       # Cria symlinks + backup automático
make unlink     # Remove symlinks + restaura ~/.zshrc.bak → ~/.zshrc
```

---

## 📦 O que está incluído

### 🔧 Ferramentas Essenciais
- **Git**: `git`, `git-extras`, `gh` (GitHub CLI)
- **Navegação**: `tree`, `stow`, `grep`, `rename`, `wget`
- **Desenvolvimento**: `pre-commit`

### ⚡ Ferramentas CLI Modernas
- **`eza`**: ls melhor com ícones e cores
- **`bat`**: cat melhor com syntax highlighting
- **`fd`**: find mais rápido
- **`ripgrep`**: grep muito mais rápido
- **`htop`**: monitor de processos melhor
- **`httpie`**: curl melhor para APIs
- **`jq`**: processador JSON
- **`biome`**: linter/formatter JS/TS ultrarrápido

### 🟢 Node.js Ecosystem
- **Node.js v22** (LTS mais recente)
- **nvm**: gerenciador de versões
- **pnpm**: gerenciador de pacotes principal
- **bun**: runtime/gerenciador alternativo (mais rápido)

### 🐍 Python (Mínimo)
- **pipx**: instalar apps Python isoladamente

### ☁️ Cloud & Desenvolvimento
- **awscli**: CLI da AWS
- **infisical**: gerenciamento de secrets
- **pulumi**: infraestrutura como código

### 🪟 Produtividade & Interface
- **yabai**: window manager para macOS

### 🎨 Aplicações
- **Essenciais**: 1Password, Chrome, VS Code
- **Desenvolvimento**: Karabiner Elements, Figma, DataGrip, GitHub Desktop, Postman, Docker
- **Terminal**: iTerm2 (terminal avançado)
- **Produtividade**: Raycast (launcher), Discord, Linear, Claude (cliente desktop)
- **Fontes**: Fira Code, Fira Code Nerd Font, Hack
- **Utilitários**: AnyDesk, Remote Desktop, BeardedSpice, WhatsApp

---

## 🐚 Shell Moderno

### Plugins Zsh Incluídos
- `git` - shortcuts e completions do Git
- `vscode` - shortcuts do VS Code
- `node` - completions Node.js
- `npm` - completions npm
- `docker` - completions e shortcuts Docker
- `aws` - completions AWS CLI
- `macos` - shortcuts específicos do macOS
- `zsh-autosuggestions` - sugestões baseadas no histórico
- `zsh-completions` - completions adicionais

### Aliases Modernos Principais

#### 📂 Navegação
```bash
ll                    # eza -la --icons --git (lista com ícones + git status)
la                    # eza -a --icons (todos os arquivos com ícones)
lt                    # eza -T --level=2 --icons (tree view)
..                    # cd ..
...                   # cd ../..
-                     # cd - (volta para diretório anterior)
```

#### 🔧 Git
```bash
g                     # git
gst                   # git status
gco                   # git checkout
gcb                   # git checkout -b (cria nova branch)
gp                    # git push
gpu                   # git push -u origin (push + set upstream)
gl                    # git pull
gaa                   # git add -A
gcam                  # git commit -a -m
glog                  # git log --oneline --graph --all
```

#### 📦 Node.js (pnpm principal)
```bash
ni                    # pnpm install
nr                    # pnpm run
nd                    # pnpm run dev
nb                    # pnpm run build
nt                    # pnpm test
nx                    # pnpx (execute packages)
```

#### 🏃 Bun (alternativo rápido)
```bash
bi                    # bun install
br                    # bun run
bd                    # bun run dev
bb                    # bun run build
```

#### 🐳 Docker
```bash
d                     # docker
dc                    # docker-compose
dps                   # docker ps
dpa                   # docker ps -a
di                    # docker images
dex                   # docker exec -it
```

#### 🛠️ Utilitários
```bash
reload                # source ~/.zshrc
cat                   # bat (com syntax highlighting)
find                  # fd (mais rápido)
grep                  # ripgrep (muito mais rápido)
ps                    # htop (melhor)
cleanup               # remove arquivos .DS_Store
myip                  # curl -s ifconfig.me (IP externo)
localip               # ipconfig getifaddr en0 (IP local)
```

---

## ⚙️ Configurações Especiais

### 🚀 Raycast (Launcher de Produtividade)
O Raycast é instalado automaticamente, mas precisa de configuração manual:

1. **Primeira execução**: Abra o Raycast e faça login com sua conta
2. **Obter token de acesso** (para sincronização):
   - **Opção 1**: Vá em `⌘,` (Preferências) → `Advanced` → `Export`
   - **Opção 2**: Acesse `raycast://preferences/advanced`
   - **Opção 3**: Configure uma extensão qualquer para ver o token nos logs
3. **Configurar no dotfiles**:
   ```bash
   # Edite o arquivo criado automaticamente durante make files
   nano ~/.config/raycast/config.json
   # Substitua "YOUR_RAYCAST_ACCESS_TOKEN" pelo seu token real
   ```
4. **Dica importante**: O token é opcional - Raycast funciona sem ele, mas com token você pode sincronizar configurações entre máquinas

**Localização das configurações**: `config/raycast/`

### 🖥️ iTerm2 (Terminal Avançado)
- **Configuração automática**: As preferências são aplicadas via `make files`
- **Profile importado**: Tema, cores, fontes e atalhos personalizados
- **Localização**: `files/com.googlecode.iterm2.plist`

### 🐙 GitHub CLI (gh)
- **Configuração automática**: Setup durante `make link`
- **Localização**: `config/gh/config.yml`
- **Inclui**: Protocolo HTTPS, aliases personalizados (`co: pr checkout`)
- **Primeira execução**: Execute `gh auth login` para autenticação

### 🎹 Karabiner Elements (Teclado)
- **Configuração automática**: Aplicada via symlinks do Stow
- **Localização**: `config/karabiner/karabiner.json`
- **Backups automáticos**: `config/karabiner/automatic_backups/`

---

## 🍎 Configurações macOS

### Melhorias Aplicadas
- **Interface mais rápida**: Remove animações desnecessárias
- **Dock inteligente**: Minimiza janelas no ícone do app
- **Finder produtivo**: Busca na pasta atual, abre na Home
- **Teclado otimizado**: Repetição rápida, ideal para código
- **Energia otimizada**: Hibernação inteligente, Power Nap desabilitado

### Configurações Mantidas
- Dock com auto-hide
- Screenshots salvos em Downloads
- Extensões de arquivo sempre visíveis
- Correção automática desabilitada (melhor para código)

---

## 🔧 VS Code

### Extensões Essenciais Incluídas
- **AI**: Claude Code, GitHub Copilot, ChatGPT
- **Tema**: Dracula
- **JavaScript/Node**: Biome, Tailwind CSS, npm IntelliSense
- **Markdown**: Markdown Mermaid, Markdown All in One
- **Git**: GitHub Actions, Pull Requests
- **Docker**: Docker, VS Code Docker
- **Remote**: SSH, Containers
- **Utilitários**: Auto Rename Tag, Material Icon Theme

### Limpeza Automática
Execute `make cleanup` para remover extensões desnecessárias:
- Temas duplicados (Catppuccin, Monokai, etc.)
- Extensões Python (removidas pois não usa muito)
- Extensões Azure (removidas pois não usa muito)
- Formatters redundantes

---

## 📁 Estrutura do Repositório

```
~/.dotfiles/
├── README.md              # Este arquivo
├── CLAUDE.md             # Instruções para Claude Code
├── Makefile              # Comandos de automação (usuário dinâmico)
├── macosdefaults.sh      # Configurações do macOS
├── bin/                  # Scripts utilitários
│   ├── dot               # Comando principal de utilitários
│   ├── is-macos          # Detecta macOS
│   └── ...
├── scripts/              # Scripts de manutenção
│   └── cleanup_vscode.sh # Limpeza do VS Code
├── install/              # Definições de packages
│   ├── Brewfile          # Packages brew + extensões VS Code
│   └── Caskfile          # Aplicações cask
├── [usuário]/           # Configs pessoais (via Stow → ~/)
│   ├── .zshrc           # Configuração do Zsh
│   ├── .alias           # Aliases personalizados
│   ├── .inputrc         # Readline keybindings
│   └── .tokens          # Tokens e variáveis (git ignored)
├── config/              # Configs de apps (via Stow → ~/.config/)
│   ├── git/             # Configuração Git
│   ├── gh/              # GitHub CLI
│   ├── karabiner/       # Customização teclado
│   └── raycast/         # Raycast (template)
└── files/               # Arquivos de sistema
    ├── DefaultKeyBinding.Dict     # Keybindings macOS
    └── com.googlecode.iterm2.plist # Configuração iTerm2
```

### 🔄 Compatibilidade Multi-Usuário
O Makefile agora usa `USER_DIR` dinâmico em vez de `bnsouza` fixo:
- **Detecção automática**: `USER_DIR := $(shell basename $(HOME))`
- **Funciona para qualquer usuário**: O sistema detecta automaticamente o nome do usuário
- **Compatibilidade**: Funciona tanto com `bnsouza/` quanto com outros nomes de usuário

---

## 🎯 Uso Diário

### Comandos que você vai usar sempre:
```bash
# Navegação moderna
ll                    # Lista arquivos com git status
lt                    # Tree view dos diretórios

# Git workflow
gst                   # Status
gco feature/nova      # Checkout branch
gcb feature/outra     # Cria nova branch
gaa                   # Add all
gcam "feat: nova feature"  # Add + commit
gp                    # Push

# Desenvolvimento Node.js
ni                    # Instala dependências
nd                    # Roda dev server
nb                    # Build projeto
bi                    # Instala com Bun (mais rápido)

# Docker
dps                   # Ver containers rodando
dex container-name    # Entrar em container

# Utilitários
reload                # Recarrega configurações shell
cleanup               # Remove .DS_Store files
myip                  # Ver IP externo
```

### Manutenção semanal:
```bash
dot update            # Atualiza tudo
make cleanup          # Limpa extensões e caches
```

---

## 🔄 Atualizações e Manutenção

### Adicionando novos packages:
1. **CLI tools**: Adicione em `install/Brewfile`
2. **GUI apps**: Adicione em `install/Caskfile`
3. **VS Code**: Adicione em `install/Brewfile` como `vscode "extension-id"`
4. Execute: `brew bundle --file=install/Brewfile`

### Adicionando aliases:
1. Edite `bnsouza/.alias`
2. Execute: `reload` ou reinicie o terminal

### Adicionando configs macOS:
1. Edite `macosdefaults.sh`
2. Execute: `make macosdefaults`

---

## 📞 Suporte

- **Comando não encontrado?** Execute `reload` ou reinicie o terminal
- **Package não instala?** Execute `brew update && brew doctor`
- **Alias não funciona?** Verifique se está em `bnsouza/.alias` e execute `reload`
- **VS Code com extensões antigas?** Execute `make cleanup`

---

## 🎉 Resultado Final

Após o setup completo você terá:

✅ **Terminal moderno** com Zsh + plugins + tema Powerlevel10k  
✅ **Ferramentas CLI modernas** (eza, bat, fd, ripgrep, biome, etc.)  
✅ **Node.js v22** com pnpm e bun  
✅ **Git otimizado** com aliases e GitHub CLI configurado  
✅ **VS Code limpo** com extensões essenciais  
✅ **macOS otimizado** para desenvolvimento  
✅ **Aliases inteligentes** para produtividade máxima  
✅ **iTerm2** configurado com tema e atalhos personalizados  
✅ **Raycast** para launcher super produtivo  
✅ **Aplicações modernas** (Discord, Linear, Claude, GitHub Desktop, Postman, Docker)  
✅ **Infraestrutura como código** com Pulumi  
✅ **Window management** com Yabai  
✅ **Sistema de backup automático** para configurações  

**Agora é só codar! 🚀**

### 🔄 Próximas Execuções
Se você já tem o dotfiles configurado e quer apenas atualizar:
```bash
cd ~/.dotfiles
git pull                    # Atualiza o repositório
make packages              # Instala novos pacotes
make link                  # Atualiza symlinks
make files                 # Atualiza configurações de aplicativos
```
