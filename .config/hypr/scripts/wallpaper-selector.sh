#!/bin/bash

# Script para seleccionar wallpapers con rofi, basado en el ejemplo del usuario
# Adaptado para usar swww + pywal + scripts de actualización

# === CONFIGURACIÓN ===
RICE_DIR="$HOME/Rice"
WALLPAPERS_DIR="$RICE_DIR/Wallpapers"
SCRIPTS_DIR="$RICE_DIR/Scripts"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"

# === FUNCIONES ===

# Función para mostrar notificación
show_notification() {
  local message="$1"
  local icon="${2:-image-x-generic}"

  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Wallpaper Selector" "$message" -i "$icon" -t 2000
  fi
}

# Función para aplicar wallpaper
apply_wallpaper() {
  local wallpaper_path="$1"
  local wallpaper_name=$(basename "$wallpaper_path")

  echo "Aplicando wallpaper: $wallpaper_name"
  show_notification "Aplicando wallpaper: $wallpaper_name"

  # Verificar que swww esté ejecutándose
  if ! pgrep -x "swww-daemon" >/dev/null; then
    echo "Iniciando swww daemon..."
    swww init &
    sleep 2
  fi

  # Aplicar wallpaper
  swww img "$wallpaper_path" \
    --transition-type wipe \
    --transition-duration 0.8 \
    --transition-fps 60

  return $?
}

# Función para generar colores con pywal
generate_colors() {
  local wallpaper_path="$1"

  echo "Generando colores con pywal..."
  show_notification "Generando colores..."

  # Aplicar pywal
  wal -i "$wallpaper_path" -q -n

  return $?
}

# Función para ejecutar scripts de actualización
update_applications() {
  echo "Actualizando aplicaciones..."
  show_notification "Aplicando tema a las aplicaciones..."

  # Scripts críticos primero
  local critical_scripts=(
    "update-hyprland-cursor.sh"
    "update-hyprland-config.sh"
    "update-kitty-colors.sh"
    "setup_hyprlock.sh"
    "update_vscode_colors.sh"
  )

  # Scripts secundarios
  local secondary_scripts=(
    "update-nvim-colors.sh"
    "update-dunst-colors.sh"
    "update-firefox-all.sh"
    "update-spicetify-colors.sh"
    "update-wlogout-colors.sh"
  )

  local success_count=0
  local total_count=$((${#critical_scripts[@]} + ${#secondary_scripts[@]}))

  # Ejecutar scripts críticos
  for script in "${critical_scripts[@]}"; do
    local script_path="$SCRIPTS_DIR/$script"
    if [[ -f "$script_path" ]]; then
      echo "  → $script"
      if bash "$script_path" >/dev/null 2>&1; then
        ((success_count++))
      fi
    fi
  done

  # Ejecutar scripts secundarios en paralelo
  local pids=()
  for script in "${secondary_scripts[@]}"; do
    local script_path="$SCRIPTS_DIR/$script"
    if [[ -f "$script_path" ]]; then
      echo "  → $script"
      bash "$script_path" >/dev/null 2>&1 &
      pids+=($!)
    fi
  done

  # Esperar scripts en paralelo
  for pid in "${pids[@]}"; do
    if wait "$pid"; then
      ((success_count++))
    fi
  done

  echo "✓ Scripts ejecutados: $success_count/$total_count"
}

# === FUNCIÓN PRINCIPAL ===
main() {
  echo "=== WALLPAPER SELECTOR ==="

  # Verificar dependencias
  local missing_deps=()
  command -v rofi >/dev/null 2>&1 || missing_deps+=("rofi")
  command -v swww >/dev/null 2>&1 || missing_deps+=("swww")
  command -v wal >/dev/null 2>&1 || missing_deps+=("python-pywal")

  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    echo "Error: Dependencias faltantes: ${missing_deps[*]}"
    show_notification "Error: Dependencias faltantes" "dialog-error"
    exit 1
  fi

  # Verificar directorio
  if [[ ! -d "$WALLPAPERS_DIR" ]]; then
    echo "Error: Directorio no encontrado: $WALLPAPERS_DIR"
    show_notification "Error: Directorio no encontrado" "dialog-error"
    exit 1
  fi

  echo "Iniciando selector..."
  show_notification "Cargando wallpapers..."

  # Cambiar al directorio de wallpapers
  cd "$WALLPAPERS_DIR" || exit 1

  # === MANEJAR ESPACIOS EN NOMBRES ===
  IFS=$'\n'

  # === SELECCIÓN CON ROFI, ORDENADO POR MÁS RECIENTE ===
  echo "Mostrando selector con rofi..."
  SELECTED_WALL=$(for a in $(ls -t *.jpg *.png *.gif *.jpeg *.webp 2>/dev/null); do
    echo -en "$a\0icon\x1f$a\n"
  done | rofi -dmenu -p "Seleccionar Wallpaper" -i -theme ~/.config/rofi/selected-wallpapers.rasi)

  # Verificar selección
  [ -z "$SELECTED_WALL" ] && {
    echo "Selección cancelada"
    exit 0
  }

  SELECTED_PATH="$WALLPAPERS_DIR/$SELECTED_WALL"
  echo "Wallpaper seleccionado: $SELECTED_WALL"

  # === APLICAR WALLPAPER ===
  if apply_wallpaper "$SELECTED_PATH"; then
    show_notification "✓ Wallpaper aplicado: $SELECTED_WALL"

    # === GENERAR COLORES ===
    if generate_colors "$SELECTED_PATH"; then
      show_notification "✓ Colores generados"

      # === CREAR SYMLINK ===
      echo "Creando symlink..."
      mkdir -p "$(dirname "$SYMLINK_PATH")"
      ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"

      # === ACTUALIZAR APLICACIONES ===
      update_applications

      # === ACTUALIZAR COLORES DE ROFI ===
      if [[ -f "$HOME/.config/rofi/scripts/update-rofi-colors.sh" ]]; then
        bash "$HOME/.config/rofi/scripts/update-rofi-colors.sh"
      fi

      show_notification "✓ Tema aplicado completamente" "$SELECTED_PATH"
      echo "✓ Proceso completado exitosamente"
    else
      show_notification "✗ Error al generar colores" "dialog-error"
      echo "✗ Error con pywal"
    fi
  else
    show_notification "✗ Error al aplicar wallpaper" "dialog-error"
    echo "✗ Error con swww"
  fi
}

# Ejecutar función principal
main "$@"
