#!/bin/bash

# Hyprland Clipboard Manager with wofi integration
# Dependencies: cliphist, wl-clipboard, wofi, grim, slurp

case "$1" in
"copy-selection")
  # Copiar selección actual (texto seleccionado)
  if [ -n "$(wl-paste -p)" ]; then
    wl-paste -p | wl-copy
    # Guardar en historial inmediatamente
    wl-paste | cliphist store
    notify-send "Clipboard" "Selección copiada"
  else
    notify-send "Clipboard" "No hay selección activa"
  fi
  ;;
"copy-screen")
  # Capturar pantalla completa al clipboard
  grim - | wl-copy
  # Guardar imagen en historial
  wl-paste | cliphist store
  notify-send "Clipboard" "Captura de pantalla copiada"
  ;;
"copy-area")
  # Capturar área seleccionada al clipboard
  grim -g "$(slurp)" - | wl-copy
  # Guardar imagen en historial
  wl-paste | cliphist store
  notify-send "Clipboard" "Área seleccionada copiada"
  ;;
"paste")
  # Pegar contenido del clipboard
  wl-paste
  ;;
"paste-type")
  # Simular escritura del clipboard (útil para campos que no permiten paste)
  wl-paste | wtype -
  ;;
"copy")
  # Monitorear clipboard y guardar en cliphist (en background)
  wl-paste --watch cliphist store &
  notify-send "Clipboard" "Monitor iniciado"
  ;;
"start-monitor")
  # Iniciar monitor del clipboard en background
  if ! pgrep -f "wl-paste --watch cliphist" >/dev/null; then
    wl-paste --watch cliphist store &
    notify-send "Clipboard" "Monitor del clipboard iniciado"
  fi
  ;;
"show")
  # Mostrar historial del clipboard con wofi y copiar selección
  selected=$(cliphist list | wofi --dmenu \
    --prompt "Clipboard:" \
    --width 800 \
    --height 400 \
    --lines 10 \
    --cache-file /dev/null \
    --style ~/.config/wofi/style.css)

  if [ -n "$selected" ]; then
    echo "$selected" | cliphist decode | wl-copy
    notify-send "Clipboard" "✅ Copiado al portapapeles" -t 2000
  else
    notify-send "Clipboard" "❌ No se seleccionó nada" -t 1500
  fi
  ;;
"add-to-history")
  # Agregar texto personalizado al historial
  text=$(echo "" | wofi --dmenu \
    --prompt "Agregar al historial:" \
    --width 600 \
    --height 100 \
    --lines 1 \
    --cache-file /dev/null \
    --style ~/.config/wofi/style.css)

  if [ -n "$text" ]; then
    echo "$text" | wl-copy
    echo "$text" | cliphist store
    notify-send "Clipboard" "Texto agregado al historial"
  fi
  ;;
"add-current-to-history")
  # Agregar contenido actual del clipboard al historial
  current=$(wl-paste)
  if [ -n "$current" ]; then
    echo "$current" | cliphist store
    notify-send "Clipboard" "Contenido actual guardado en historial"
  else
    notify-send "Clipboard" "No hay contenido en el clipboard"
  fi
  ;;
"clear")
  # Limpiar historial del clipboard
  cliphist wipe
  notify-send "Clipboard" "Historial limpiado"
  ;;
"delete")
  # Eliminar entrada específica del clipboard
  selected=$(cliphist list | wofi --dmenu \
    --prompt "Eliminar:" \
    --width 800 \
    --height 400 \
    --lines 10 \
    --cache-file /dev/null \
    --style ~/.config/wofi/style.css)

  if [ -n "$selected" ]; then
    echo "$selected" | cliphist delete
    notify-send "Clipboard" "🗑️ Elemento eliminado" -t 2000
  else
    notify-send "Clipboard" "❌ No se seleccionó nada" -t 1500
  fi
  ;;
"status")
  # Verificar estado del monitor
  if pgrep -f "wl-paste --watch cliphist" >/dev/null; then
    notify-send "Clipboard" "Monitor activo"
    echo "Monitor del clipboard está activo"
    echo "Historial guardado en: ~/.cache/cliphist/db"
    echo "Entradas en historial: $(cliphist list | wc -l)"
  else
    notify-send "Clipboard" "Monitor inactivo"
    echo "Monitor del clipboard NO está activo"
  fi
  ;;
"info")
  # Mostrar información del historial
  db_path="$HOME/.cache/cliphist/db"
  if [ -f "$db_path" ]; then
    echo "📁 Base de datos: $db_path"
    echo "📊 Tamaño: $(du -h "$db_path" | cut -f1)"
    echo "📋 Entradas: $(cliphist list | wc -l)"
    echo "🕒 Última modificación: $(stat -c %y "$db_path")"
  else
    echo "❌ No se encontró la base de datos del historial"
  fi
  ;;
*)
  echo "Uso: $0 {copy|show|clear|delete}"
  echo "Funciones básicas:"
  echo "  copy-selection - Copiar texto seleccionado"
  echo "  copy-screen   - Capturar pantalla completa"
  echo "  copy-area     - Capturar área seleccionada"
  echo "  paste         - Pegar contenido"
  echo "  paste-type    - Escribir contenido (simula teclado)"
  echo ""
  echo "Gestión de historial:"
  echo "  copy          - Iniciar monitoreo del clipboard"
  echo "  start-monitor - Iniciar monitor en background"
  echo "  show  - Mostrar historial del clipboard"
  echo "  add-to-history - Agregar texto personalizado al historial"
  echo "  add-current-to-history - Guardar contenido actual en historial"
  echo "  clear - Limpiar historial completo"
  echo "  delete - Eliminar entrada específica"
  echo "  status - Verificar estado del monitor"
  echo "  info   - Mostrar información del historial"
  exit 1
  ;;
esac
