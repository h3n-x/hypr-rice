#!/bin/bash

# --------------------------------------------------------------
# Proyecto creado por hen-x
# GitHub: https://github.com/hen-x
# --------------------------------------------------------------

CONFIG="$HOME/.config/hypr/hyprland.conf"
PYWAL="$HOME/.cache/wal/colors.sh"

# Verifica dependencias
if [ ! -f "$PYWAL" ]; then
  echo "❌ No se encontró $PYWAL. Ejecuta pywal primero."
  exit 1
fi
if [ ! -f "$CONFIG" ]; then
  echo "❌ No se encontró $CONFIG. Asegúrate de tener tu configuración de Hyprland."
  exit 1
fi

# Carga colores de pywal
source "$PYWAL"

# Validación: aborta si algún color está vacío
if [ -z "$color4" ] || [ -z "$color1" ] || [ -z "$color0" ] || [ -z "$color8" ]; then
  echo "❌ Error: No se pudieron cargar los colores de pywal. ¿Ejecutaste pywal recientemente?"
  echo "Aborto para no dejar líneas vacías en tu configuración."
  exit 1
fi

# Convierte color #xxxxxx a rgba(xxxxxxff)
hex_to_rgba() {
  local hex="$1"
  echo "rgba(${hex:1}ff)"
}

BORDER_ACTIVE=$(hex_to_rgba "$color4")
BORDER_INACTIVE=$(hex_to_rgba "$color1")
SHADOW_COLOR=$(hex_to_rgba "$color0")
SHADOW_COLOR_INACTIVE=$(hex_to_rgba "$color8")

# Reemplaza solo los colores en el archivo de configuración
sed -i \
  -e "s/^\(\s*col.active_border\s*=\s*\).*$/\1$BORDER_ACTIVE/" \
  -e "s/^\(\s*col.inactive_border\s*=\s*\).*$/\1$BORDER_INACTIVE/" \
  -e "s/^\(\s*color\s*=\s*\).*$/\1$SHADOW_COLOR/" \
  -e "s/^\(\s*color_inactive\s*=\s*\).*$/\1$SHADOW_COLOR_INACTIVE/" \
  "$CONFIG"

echo "✅ Colores de Hyprland actualizados con los de pywal en formato rgba en $CONFIG"
echo "💡 Recarga Hyprland con: hyprctl reload"
