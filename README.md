# Dotfiles

Configuração pessoal do macOS — shell, pacotes, aplicações, defaults do sistema. Tudo
versionado e linkado para `$HOME` via [GNU Stow](https://www.gnu.org/software/stow/).

---

## Como tudo se conecta

```
~/.dotfiles/
├── Makefile               # entrada principal de automação
├── macosdefaults.sh       # `defaults write …` para o macOS
├── .gitignore
│
├── bin/                   # utilitários (entram no PATH via Makefile)
│   ├── dot                # comando guarda-chuva (dot clean, dot update, dot macos…)
│   ├── is-arm64, is-macos, is-supported, is-executable, append, json
│
├── bnsouza/               # → symlinked para $HOME
│   ├── .zshrc             # shell config (oh-my-zsh + p10k + plugins)
│   ├── .alias             # aliases e atalhos
│   ├── .inputrc           # keybindings do readline (teclado numérico, navegação)
│   └── .tokens            # GITIGNORED. Variáveis privadas (secrets).
│
├── config/                # → symlinked para $XDG_CONFIG_HOME (~/.config/)
│   ├── git/               # git config + gitignore global
│   ├── gh/                # GitHub CLI
│   ├── karabiner/         # remapeamento de teclado
│   └── raycast/           # apenas template; o config real fica em ~/.config/raycast/
│
├── install/
│   ├── Brewfile           # pacotes CLI + extensões VS Code
│   └── Caskfile           # aplicações GUI
│
└── files/                 # arquivos COPIADOS (não symlinked) para paths do sistema
    ├── DefaultKeyBinding.Dict        # → ~/Library/KeyBindings/
    └── com.googlecode.iterm2.plist   # → ~/Library/Preferences/
```

**Pontos importantes**:

- O Stow detecta o nome do diretório `bnsouza/` dinamicamente (via `USER_DIR` no Makefile),
  então funciona em qualquer máquina mesmo com outro nome de usuário.
- Pastas `bnsouza/` e `config/` viram **symlinks**. Editar o arquivo no repo reflete imediatamente
  em `$HOME` — não precisa reinstalar.
- Pasta `files/` é **cópia**, não symlink. Mudou ali? Rode `make files` para reaplicar.
- `bnsouza/.tokens` é gitignored. Nada de secrets no remoto.

---

## Setup numa máquina nova

```bash
git clone https://github.com/bnsouza/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make setup
```

O `make setup` faz `all` + `zsh-plugins`:

1. `sudo` — pede senha uma vez e mantém ativo
2. `core` — instala Homebrew, oh-my-zsh + powerlevel10k, git
3. `packages` — `brew bundle` do Brewfile e Caskfile
4. `link` — backup dos dotfiles existentes (`.bak`) e cria symlinks via Stow
5. `macosdefaults` — aplica `macosdefaults.sh`
6. `files` — copia plists do iTerm2 e KeyBindings
7. `zsh-plugins` — clona `zsh-autosuggestions` e `zsh-completions` no `$ZSH_CUSTOM`

Depois:
- Crie o `~/.tokens` (não está no repo). Ver seção **Tokens** abaixo.
- `gh auth login` para autenticar o GitHub CLI.
- Abra Raycast manualmente e configure (config dele fica em `~/.config/raycast/`).
- Reinicie o terminal.

---

## Operações de manutenção

Todos os comandos rodam a partir do diretório do repo.

| Comando | O que faz |
|---|---|
| `make setup` | Setup completo (primeira instalação). |
| `make all` | Mesmo que setup, sem clonar os plugins zsh. |
| `make packages` | Reinstala/atualiza pacotes do Brewfile + Caskfile. |
| `make link` | Recria os symlinks (rode sempre que adicionar arquivo novo em `bnsouza/` ou `config/`). |
| `make unlink` | Remove symlinks e restaura backups `.bak`. |
| `make macosdefaults` | Reaplica `macosdefaults.sh`. |
| `make files` | Recopia plists em `files/` (iTerm2, KeyBindings). |
| `make cleanup` | `brew cleanup` + `brew autoremove`. |
| `dot update` | Atualiza Homebrew (formulae e casks) e roda cleanup. |
| `dot clean` | Limpa caches (brew, gem, pip). |
| `dot macos` | Mesmo que `make macosdefaults`. |
| `dot edit` | Abre o repo no `$VISUAL`/`$EDITOR`. |

---

## O que está instalado

### Pacotes CLI (`install/Brewfile`)

**Essenciais**: `git`, `git-extras`, `gh`, `stow`, `tree`, `grep`, `wget`

**Substitutos modernos**: `fd` (find), `ripgrep` (grep) — usados via aliases `find`/`grep`
em [bnsouza/.alias](bnsouza/.alias)

**Dev**: `jq`, `biome`

**Node**: `node`, `nvm`, `pnpm`, `bun`

**Cloud/Mídia**: `awscli`, `infisical`, `ffmpeg`

**Outros**: `yabai` (window manager), `zsh-syntax-highlighting`

### Aplicações (`install/Caskfile`)

1Password, Google Chrome, VS Code, iTerm2, Karabiner Elements, Figma, DataGrip,
Postman, Docker Desktop, Raycast, Claude desktop, Discord, Linear, WhatsApp,
AnyDesk, Microsoft Remote Desktop, BeardedSpice — e as fontes Fira Code / Fira Code Nerd
Font / Hack.

### Extensões VS Code

Definidas no próprio Brewfile com `vscode "id"`. Instala pelo `brew bundle`.

### Como adicionar / remover

- **CLI tool**: edite `install/Brewfile` → `brew bundle --file=install/Brewfile`
- **App GUI**: edite `install/Caskfile` → `brew bundle --file=install/Caskfile`
- **Extensão VS Code**: adicione `vscode "publisher.extension"` no `Brewfile`
- **Pra remover** depois de tirar do Brewfile: `brew uninstall <nome>` (o bundle não desinstala sozinho)

---

## Shell

[bnsouza/.zshrc](bnsouza/.zshrc) carrega, na ordem:

1. Powerlevel10k instant prompt (cache no `$XDG_CACHE_HOME`)
2. oh-my-zsh com os plugins: `git`, `vscode`, `node`, `npm`, `docker`, `aws`, `macos`,
   `zsh-autosuggestions`, `zsh-completions`
3. `~/.p10k.zsh` (gerado por `p10k configure`)
4. `~/.alias` — aliases definidos em [bnsouza/.alias](bnsouza/.alias)
5. `~/.inputrc` — keybindings
6. NVM com hook `chpwd` para detectar `.nvmrc` ao trocar de pasta
7. `zsh-syntax-highlighting` (vem do Homebrew)
8. PATH para pnpm, bun, PHP 8.5
9. `~/.tokens` (se existir) — sourceado
10. Define a função `infisical-login` (lazy — não chama login automaticamente)

### Aliases mais usados

```
ll, la, lt         # listagens (ls -laFh, ls -aFh, tree -L 2)
.., ..., ....      # cd .. encadeados
g, gst, gco, gcb,  # git
gp, gpu, gl, gaa,
gc, gca, gcam, glog
ni, nr, nd, nb, nt # pnpm install/run/dev/build/test
bi, br, bd, bb, bt # bun equivalentes
d, dc, dps, dpa,   # docker
di, dex, dlog, dstop
find, grep         # aliased pra fd e ripgrep
reload             # source ~/.zshrc
myip, localip      # IPs
zdb                # atalho de projeto (Zerpi db prod)
```

Lista completa em [bnsouza/.alias](bnsouza/.alias).

### Adicionando aliases

Edite [bnsouza/.alias](bnsouza/.alias) e rode `reload`. Como é symlink, a alteração no repo já reflete.

---

## Tokens (secrets)

O arquivo `~/.tokens` é gerenciado pelo Stow (`bnsouza/.tokens` → `~/.tokens`)
mas **gitignored**. Formato esperado:

```bash
export INFISICAL_UNIVERSAL_AUTH_CLIENT_ID="…"
export INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET="…"
export FONTAWESOME_NPM_TOKEN="…"
# adicione outros conforme necessário
```

### Infisical

O `INFISICAL_TOKEN` não é mais carregado automaticamente em todo shell startup (custo de
rede). Use:

```bash
infisical-login    # gera e exporta $INFISICAL_TOKEN na sessão atual
```

Depois disso, comandos que precisam do token funcionam normalmente naquele shell.

---

## macOS defaults

Tudo em [macosdefaults.sh](macosdefaults.sh). Trocas notáveis:

- Finder: extensões sempre visíveis, busca na pasta atual, view em colunas, abre na Home
- Teclado: repetição rápida, press-and-hold off (bom pra código), capitalização/auto-correct off
- Dock: auto-hide, minimize-to-application, efeito scale
- Energia: hibernate mode 3, power nap off
- Updates: verificação diária, auto-download

Para reaplicar tudo: `make macosdefaults` (ou `dot macos`).

---

## Karabiner

Regras pessoais em [config/karabiner/karabiner.json](config/karabiner/karabiner.json) e
[config/karabiner/assets/complex_modifications/regras_bnsouza.json](config/karabiner/assets/complex_modifications/regras_bnsouza.json).
Backups automáticos do app caem em `config/karabiner/automatic_backups/` (gitignored).

---

## Troubleshooting

| Problema | O que fazer |
|---|---|
| Comando/alias não encontrado | `reload` ou reabra o terminal |
| `make link` falha em algum arquivo | Já existe arquivo regular em `$HOME` com aquele nome; ele será movido para `.bak` |
| VS Code reclama de extensão faltando | `brew bundle --file=install/Brewfile` |
| Brew bundle reclama de tap | Os taps oficiais mudaram. Confirme no Brewfile/Caskfile que só estão os necessários |
| Shell muito lento | Confira se algum comando síncrono foi adicionado ao `.zshrc` (era o caso do `infisical login`) |
| Infisical pede credenciais | Rode `infisical-login` manualmente; verifique se `~/.tokens` tem as variáveis |
