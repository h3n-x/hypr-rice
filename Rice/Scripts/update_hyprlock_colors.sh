#!/bin/bash

# --------------------------------------------------------------
# Proyecto creado por hen-x
# GitHub: https://github.com/hen-x
# --------------------------------------------------------------

COLORS_FILE="$HOME/.cache/wal/colors.sh"
HYPRLOCK_CONF="$HOME/.config/hypr/hyprlock.conf"

# Verificar que existe el archivo de colores
if [ ! -f "$COLORS_FILE" ]; then
  echo "Error: No se encontró $COLORS_FILE"
  exit 1
fi

# Cargar colores de pywal
source "$COLORS_FILE"

# Generar hyprlock.conf con colores actuales y orden correcto
cat >"$HYPRLOCK_CONF" <<EOF
# Configuración generada automáticamente con colores de pywal
general {
    hide_cursor = false
    ignore_empty_input = false
    immediate_render = true
}

auth {
    pam:enabled = true
}

animations {
    enabled = true
}

bezier = easeOut, 0.25, 1, 0.5, 1
bezier = smoothBounce, 0.68, -0.55, 0.265, 1.55
animation = fade, 1, 8, easeOut
animation = fadeIn, 1, 6, smoothBounce

# Fondo con color de pywal
background {
    monitor = 
    color = rgb(${background#\#})
}

# 1. Imagen de usuario (arriba)
image {
    monitor = 
    path = ~/.face
    size = 120
    rounding = -1
    border_size = 3
    border_color = rgb(${color6#\#})
    position = 0, 150
    halign = center
    valign = center
    
    shadow_passes = 2
    shadow_size = 8
    shadow_color = rgba(${background#\#}, 0.8)
}

# 2. Reloj de palabras matriz (centro) con animación
label {
    monitor = 
    text = cmd[update:500] ~/.config/hypr/scripts/word_clock.sh
    color = rgb(${foreground#\#})
    font_size = 18
    font_family = JetBrainsMono Nerd Font Mono
    font_weight = 400
    position = 0, 0
    halign = center
    valign = center
    text_align = center
    
    shadow_passes = 1
    shadow_size = 2
    shadow_color = rgba(${background#\#}, 0.6)
}

# 3. Campo de contraseña (abajo)
input-field {
    monitor = 
    size = 320, 50
    outline_thickness = 2
    dots_size = 0.3
    dots_spacing = 0.2
    dots_center = true
    dots_rounding = -1
    
    outer_color = rgb(${color3#\#})
    inner_color = rgba(${background#\#}, 0.9)
    font_color = rgb(${foreground#\#})
    font_family = JetBrainsMono Nerd Font
    font_size = 14
    
    fade_on_empty = true
    placeholder_text = <span foreground="#${color6#\#}"><i>  Enter Password...</i></span>
    rounding = 25
    check_color = rgb(${color5#\#})
    fail_color = rgb(${color1#\#})
    fail_text = <span foreground="#${color1#\#}"><i> Authentication Failed</i></span>
    
    position = 0, -150
    halign = center
    valign = center
    
    shadow_passes = 2
    shadow_size = 6
    shadow_color = rgba(${background#\#}, 0.4)
}
EOF

echo "hyprlock.conf actualizado con colores de pywal"
