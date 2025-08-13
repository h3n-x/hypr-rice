#!/bin/bash
# Versión actualizada del generador que incluye configuración de sonidos

# Script actualizado que integra la funcionalidad de sonidos
# Basado en tu generate_matrix_hyprlock.sh original

# Leer colores de pywal
if [ -f ~/.cache/wal/colors.sh ]; then
  source ~/.cache/wal/colors.sh
else
  # Colores de respaldo si pywal no está disponible
  color0="#020104"
  color1="#3F2D81"
  color2="#4C3591"
  color3="#5B3CA1"
  color4="#5E48A5"
  color5="#7850C7"
  color6="#965ADD"
  color7="#d6a8e2"
  color8="#95759e"
  foreground="#d6a8e2"
  background="#020104"
  wallpaper="$HOME/Rice/Wallpapers/imagen_161.png"
fi

# Crear configuración hyprlock con comentarios sobre sonidos
cat >~/.config/hypr/hyprlock.conf <<EOF
# Configuración minimalista con diseño de reloj de palabras
# Auto-generada con colores de pywal
# 🔊 SONIDOS: Usa ~/.config/hypr/scripts/hyprlock_with_sounds.sh para sonidos

general {
    disable_loading_bar = true
    grace = 2
    hide_cursor = true
    no_fade_in = false
}

# Fondo con wallpaper de pywal
background {
    monitor =
    path = $wallpaper
    blur_passes = 4
    blur_size = 10
    noise = 0.0117
    contrast = 0.9
    brightness = 0.25
    vibrancy = 0.2
    vibrancy_darkness = 0.0
}

# 1. IMAGEN DE USUARIO (arriba)
image {
    monitor =
    path = ~/.face
    size = 120
    rounding = 60
    border_size = 3
    border_color = rgba(${color6#\#}FF)
    shadow_passes = 3
    shadow_size = 8
    shadow_color = rgba(${color6#\#}40)
    position = 0, 290
    halign = center
    valign = center
}

# Icono de usuario de respaldo si ~/.face no existe
label {
    monitor =
    text = 
    color = rgba(${color6#\#}FF)
    font_size = 80
    position = 0, 200
    halign = center
    valign = center
    shadow_passes = 3
    shadow_size = 8
    shadow_color = rgba(${color6#\#}40)
}

# 2. RELOJ DE PALABRAS MATRIZ (centro)
label {
    monitor =
    text = cmd[update:500] ~/.config/hypr/scripts/word_clock_matrix.sh
    color = rgba(${color6#\#}FF)
    font_size = 22
    font_family = JetBrains Mono Bold
    position = 0, 0
    halign = center
    valign = center
    text_align = center
    allow_breaks = true
    markup = true
    shadow_passes = 5
    shadow_size = 12
    shadow_color = rgba(${color6#\#}80)
    shadow_boost = 2.0
}

# Icono de candado
label {
    monitor =
    text = 
    color = rgba(${color6#\#}FF)
    font_size = 32
    position = 0, -100
    halign = center
    valign = center
    shadow_passes = 2
    shadow_size = 4
    shadow_color = rgba(${color6#\#}40)
}

# 3. CAMPO DE CONTRASEÑA (abajo)
input-field {
    monitor =
    size = 400, 55
    outline_thickness = 3
    dots_size = 0.3
    dots_spacing = 0.6
    dots_center = true
    dots_rounding = -1
    outer_color = rgba(${color6#\#}AA)
    inner_color = rgba(${color0#\#}E6)
    font_color = rgba(${foreground#\#}FF)
    font_family = JetBrains Mono
    font_size = 14
    fade_on_empty = true
    fade_timeout = 1000
    placeholder_text = <span foreground="##${color7#\#}" font_style="italic">Enter Password...</span>
    hide_input = false
    rounding = 20
    check_color = rgba(${color5#\#}FF)
    fail_color = rgba(${color1#\#}FF)
    fail_text = <span foreground="##${color1#\#}" font_weight="bold"> Access Denied</span>
    fail_timeout = 2000
    capslock_color = rgba(${color3#\#}FF)
    numlock_color = rgba(${color4#\#}FF)
    bothlock_color = rgba(${color2#\#}FF)
    position = 0, -250
    halign = center
    valign = center
    shadow_passes = 3
    shadow_size = 6
    shadow_color = rgba(${color0#\#}90)
}
EOF

echo "🎨 Configuración hyprlock generada con soporte de sonidos!"
echo "🔊 Para habilitar sonidos, ejecuta: ~/.config/hypr/scripts/setup_hyprlock_sounds.sh"
