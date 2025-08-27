# Ocultar e mostrar automaticamente o Dock
defaults write com.apple.dock autohide -bool true
# Salvar capturas de tela na pasta Downloads
defaults write com.apple.screencapture location -string "$HOME/Downloads"
# Salvar capturas de tela no formato PNG (outras opções: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"
# Desabilitar efeitos sonoros na inicialização
sudo nvram SystemAudioVolume=" "
# Aumentar velocidade de redimensionamento de janelas para aplicações Cocoa
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
# Expandir painel de salvamento por padrão
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
# Fechar automaticamente aplicativo de impressão quando trabalhos de impressão terminarem
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
# Desabilitar diálogo "Tem certeza que deseja abrir esta aplicação?"
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Adormecer o display após 15 minutos
sudo pmset -a displaysleep 15
# Desabilitar modo sleep da máquina enquanto carregando
sudo pmset -c sleep 0
# Definir modo sleep da máquina para 5 minutos na bateria
sudo pmset -b sleep 5
# Definir delay de standby para 24 horas (padrão é 1 hora)
sudo pmset -a standbydelay 86400
# Nunca entrar em modo sleep do computador
sudo systemsetup -setcomputersleep Off > /dev/null
# Modo de hibernação
sudo pmset -a hibernatemode 0
# Finder: mostrar todas as extensões de arquivos
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Finder: mostrar barra de status
defaults write com.apple.finder ShowStatusBar -bool true
# Desabilitar aviso ao alterar extensão de arquivo
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Evitar criação de arquivos .DS_Store em volumes de rede ou USB
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Desabilitar verificação de imagem de disco
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
# Abrir automaticamente nova janela do Finder quando volume for montado
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
# Habilitar snap-to-grid para ícones na área de trabalho e outras visualizações de ícones
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# Usar visualização em colunas em todas as janelas do Finder por padrão
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
# Desabilitar aviso antes de esvaziar lixeira
defaults write com.apple.finder WarnOnEmptyTrash -bool false
# Não exibir prompt irritante ao sair do iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false
# Habilitar verificação automática de atualizações
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
# Verificar atualizações de software diariamente, não apenas uma vez por semana
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
# Baixar atualizações disponíveis em segundo plano
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
# Instalar arquivos de dados do sistema e atualizações de segurança
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
# Baixar automaticamente apps comprados em outros Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
# Ativar auto-atualização de apps
defaults write com.apple.commerce AutoUpdate -bool true
# Permitir que App Store reinicie máquina em atualizações do macOS
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true
# Prevenir Fotos de abrir automaticamente quando dispositivos são conectados
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
# Desabilitar capitalização automática pois é irritante ao digitar código
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# Desabilitar traços inteligentes pois são irritantes ao digitar código
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Desabilitar substituição automática de pontos pois é irritante ao digitar código
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Desabilitar aspas inteligentes pois são irritantes ao digitar código
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Desabilitar correção automática
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Definir idioma e formatos de texto
defaults write NSGlobalDomain AppleLanguages -array "pt-BR" "en"
defaults write NSGlobalDomain AppleLocale -string "pt-BR"

# === MELHORIAS MODERNAS ===

# Melhor responsividade - Remove animações de janela para interface mais rápida
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
# Redimensionamento mais rápido de colunas no Finder
defaults write NSGlobalDomain NSBrowserColumnResizingDisabled -bool true

# Melhor comportamento do Dock
# Usa efeito scale ao invés de genie (mais rápido)
defaults write com.apple.dock mineffect -string "scale"
# Minimiza janelas no ícone da aplicação (melhor organização)
defaults write com.apple.dock minimize-to-application -bool true

# Melhores padrões do Finder
# Novas janelas abrem na pasta Home ao invés de Recentes
defaults write com.apple.finder NewWindowTarget -string "PfHm"
# Busca na pasta atual por padrão ao invés do Mac inteiro
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Melhor responsividade de entrada
# Trackpad/mouse mais rápido (bom para desenvolvimento)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3.0
# Desabilita press-and-hold para teclas (melhor para código, habilita repetição)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Taxa de repetição de tecla mais rápida
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Melhor gerenciamento de energia
# Hibernação mais inteligente (salva RAM no disco)
sudo pmset -a hibernatemode 3
# Desabilita Power Nap (economiza bateria)
sudo pmset -a powernap 0
