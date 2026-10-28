#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Alinhar à esquerda com rotação
# @raycast.mode silent
# @raycast.packageName Janelas
# @raycast.icon images/custom-window-size.png
# @raycast.author BNSouza
# @raycast.description Move a janela ativa ciclicamente entre posições: metade tela atual → tela cheia em outro monitor → metade esquerda desse monitor → e para lá.

# Verifica se yabai está funcionando
if ! command -v yabai &> /dev/null; then
    echo "Erro: yabai não está instalado ou não está no PATH"
    exit 1
fi

# Tenta obter informações da janela ativa
window_info=$(yabai -m query --windows --window 2>/dev/null)
if [ $? -ne 0 ] || [ -z "$window_info" ] || [ "$window_info" = "null" ]; then
    echo "Erro: Não foi possível obter informações da janela ativa. Verifique se a janela tem permissões de acessibilidade."
    exit 1
fi

app_name=$(echo "$window_info" | jq -r '.app')
win_id=$(echo "$window_info" | jq -r '.id')
current_display=$(echo "$window_info" | jq '.display')

# Verifica se conseguiu obter as informações básicas
if [ "$win_id" = "null" ] || [ -z "$win_id" ]; then
    echo "Erro: Não foi possível obter ID da janela ativa"
    exit 1
fi

# Lista os displays disponíveis, ordenados por posição X
display_list=$(yabai -m query --displays | jq 'sort_by(.frame.x) | reverse')
display_count=$(echo "$display_list" | jq 'length')

# Encontra índice do display atual
current_index=$(echo "$display_list" | jq "map(.index) | index($current_display)")

# Pega informações do display atual
display_info=$(echo "$display_list" | jq ".[$current_index]")
frame_x=$(echo "$display_info" | jq '.frame.x' | awk '{printf "%d", $1}')
frame_y=$(echo "$display_info" | jq '.frame.y' | awk '{printf "%d", $1}')
frame_w=$(echo "$display_info" | jq '.frame.w' | awk '{printf "%d", $1}')
frame_h=$(echo "$display_info" | jq '.frame.h' | awk '{printf "%d", $1}')

# Configurações específicas por aplicativo
if [ "$app_name" = "Claude" ] || [ "$app_name" = "Notion Calendar" ]; then
  # Apps que podem ter restrições de acessibilidade - usa posicionamento mais suave
  half_width=$((frame_w / 2))
  
  if ! yabai -m window "$win_id" --move abs:"$frame_x":"$frame_y" 2>/dev/null; then
    echo "Aviso: O aplicativo $app_name pode não permitir controle de janela. Verifique as permissões de acessibilidade."
    exit 1
  fi
  if ! yabai -m window "$win_id" --resize abs:"$half_width":"$frame_h" 2>/dev/null; then
    echo "Aviso: Não foi possível redimensionar a janela do $app_name"
  fi

else
  # Verifica tamanho e posição atual da janela
  win_frame_x=$(echo "$window_info" | jq '.frame.x' | awk '{printf "%d", $1}')
  win_frame_w=$(echo "$window_info" | jq '.frame.w' | awk '{printf "%d", $1}')

  # Calcula a posição da metade esquerda
  half_width=$((frame_w / 2))

  # Verifica se a janela já está na metade esquerda da tela atual
  is_left_half=$((win_frame_w <= half_width + 10 && win_frame_x <= frame_x + 10))

  # Estado 1: metade esquerda da tela atual → vai para tela cheia no próximo monitor (se existir)
  if [ "$is_left_half" -eq 1 ] && [ "$((current_index + 1))" -lt "$display_count" ]; then
    next_display_index=$((current_index + 1))
    next_display_info=$(echo "$display_list" | jq ".[$next_display_index]")
    nx=$(echo "$next_display_info" | jq '.frame.x' | awk '{printf "%d", $1}')
    ny=$(echo "$next_display_info" | jq '.frame.y' | awk '{printf "%d", $1}')
    nw=$(echo "$next_display_info" | jq '.frame.w' | awk '{printf "%d", $1}')
    nh=$(echo "$next_display_info" | jq '.frame.h' | awk '{printf "%d", $1}')

    if ! yabai -m window "$win_id" --move abs:"$nx":"$ny" 2>/dev/null; then
      echo "Aviso: Não foi possível mover a janela para o próximo monitor"
      exit 1
    fi
    if ! yabai -m window "$win_id" --resize abs:"$nw":"$nh" 2>/dev/null; then
      echo "Aviso: Não foi possível redimensionar a janela no próximo monitor"
    fi

  # Estado 2: tela cheia → vira metade esquerda
  elif [ "$win_frame_w" -ge "$frame_w" ]; then
    if ! yabai -m window "$win_id" --move abs:"$frame_x":"$frame_y" 2>/dev/null; then
      echo "Aviso: Não foi possível mover a janela para a esquerda"
      exit 1
    fi
    if ! yabai -m window "$win_id" --resize abs:"$half_width":"$frame_h" 2>/dev/null; then
      echo "Aviso: Não foi possível redimensionar a janela"
    fi

  # Estado final: vai para metade esquerda da tela atual
  else
    if ! yabai -m window "$win_id" --move abs:"$frame_x":"$frame_y" 2>/dev/null; then
      echo "Aviso: Não foi possível mover a janela para a esquerda"
      exit 1
    fi
    if ! yabai -m window "$win_id" --resize abs:"$half_width":"$frame_h" 2>/dev/null; then
      echo "Aviso: Não foi possível redimensionar a janela"
    fi
  fi
fi
