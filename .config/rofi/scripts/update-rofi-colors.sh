#!/bin/bash

# Script para actualizar colores de rofi con pywal
# Se ejecuta automáticamente cuando cambias el wallpaper

ROFI_DIR="$HOME/.config/rofi"
WAL_COLORS="$HOME/.cache/wal/colors.sh"

# Verificar que existan los colores de pywal
if [[ ! -f "$WAL_COLORS" ]]; then
  echo "Error: No se encontraron colores de pywal"
  exit 1
fi

# Cargar colores de pywal
source "$WAL_COLORS"

# Crear archivo de colores para rofi compatible con pywal
cat >"$HOME/.cache/wal/colors-rofi-dark.rasi" <<EOF
/* Colores generados por pywal para rofi */
* {
    background:     ${background};
    background-alt: ${color0};
    foreground:     ${foreground};
    selected:       ${color1};
    active:         ${color2};
    urgent:         ${color3};
    
    /* Colores numerados */
    color0:         ${color0};
    color1:         ${color1};
    color2:         ${color2};
    color3:         ${color3};
    color4:         ${color4};
    color5:         ${color5};
    color6:         ${color6};
    color7:         ${color7};
    color8:         ${color8};
    color9:         ${color9};
    color10:        ${color10};
    color11:        ${color11};
    color12:        ${color12};
    color13:        ${color13};
    color14:        ${color14};
    color15:        ${color15};
    
    /* Aliases para compatibilidad */
    accent:         ${color4};
    highlight:      ${color5};
    border:         ${color6};
    text:           ${foreground};
    text-alt:       ${color8};
    separatorcolor: ${color8};
}
EOF

echo "✓ Colores de rofi actualizados"
