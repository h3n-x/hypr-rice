#!/bin/bash

# --------------------------------------------------------------
# Proyecto creado por hen-x
# GitHub: https://github.com/hen-x
# --------------------------------------------------------------

DUNST_CONFIG="$HOME/.config/dunst/dunstrc"
PYWAL="$HOME/.cache/wal/colors.sh"

# Verifica dependencias
if [ ! -f "$PYWAL" ]; then
  echo "❌ No se encontró $PYWAL. Ejecuta pywal primero."
  exit 1
fi
if [ ! -f "$DUNST_CONFIG" ]; then
  echo "❌ No se encontró $DUNST_CONFIG. Asegúrate de tener tu configuración de Dunst."
  exit 1
fi

# Carga colores de pywal
source "$PYWAL"

# Validación: aborta si algún color está vacío
if [ -z "$color0" ] || [ -z "$color7" ] || [ -z "$color1" ] || [ -z "$color3" ] || [ -z "$color4" ] || [ -z "$color2" ]; then
  echo "❌ Error: No se pudieron cargar los colores de pywal. ¿Ejecutaste pywal recientemente?"
  echo "Aborto para no dejar líneas vacías en tu configuración."
  exit 1
fi

# Mapeo de colores pywal → Dunst (RGBA para transparencia)
BG="${color0}cc"    # Fondo general (80% opaco)
FG="$color7"        # Texto general
FRAME="${color1}cc" # Borde (80% opaco)
HL="$color4"        # Highlight (barra de progreso, etc)
LOW_BG="${color0}cc"
LOW_FG="$color7"
LOW_FRAME="${color2}cc"
NORM_BG="${color0}cc"
NORM_FG="$color7"
NORM_FRAME="${color3}cc"
CRIT_BG="${color1}cc"
CRIT_FG="$color7"
CRIT_FRAME="${color4}cc"

# Personalización de fuentes e iconos
FONT="JetBrains Mono 10"
ICON_POSITION="left"
ICON_SIZE="48"
ICON_RADIUS="8"
ICON_PATH="/usr/share/icons/Papirus/32x32/status/:/usr/share/icons/hicolor/32x32/status/:/usr/share/icons/Adwaita/32x32/status/:/usr/share/pixmaps/"
MAX_ICON_SIZE="64"

# Otros estilos
CORNER_RADIUS="10"
PROGRESS_BAR="true"
PROGRESS_BAR_HEIGHT="8"
PROGRESS_BAR_COLOR="$HL"
FRAME_WIDTH="3"
PADDING="16"
H_PADDING="16"
SEPARATOR_HEIGHT="2"
SEPARATOR_COLOR="$FRAME"
OPACITY="0" # 0 = opaco, 100 = transparente

# Posición y tamaño recomendados (esquina superior derecha, tamaño medio)
GEOMETRY="400x5-30+30" # ancho x cantidad -offsetX +offsetY
OFFSET="30x30"
WIDTH="400"
HEIGHT="200"
NOTIF_LIMIT="5"

# Historial y stacking
HISTORY_LENGTH="20"
STACK_DUPLICATES="true"
SHOW_INDICATORS="true"

# Markup y formato
MARKUP="full"
FORMAT="<b>%s</b>\n%b" # Título en negrita, luego el cuerpo

# Sonido para notificaciones críticas
CRIT_SOUND="/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga"

# Si el archivo está vacío, escribe una configuración base avanzada
if [ ! -s "$DUNST_CONFIG" ]; then
  cat >"$DUNST_CONFIG" <<EOF
# Configuración avanzada de Dunst generada automáticamente
# Puedes editar cualquier valor a tu gusto
#
# Para mostrar iconos de las apps en las notificaciones, asegúrate de:
# - icon_position = left (o right)
# - icon_path incluye rutas de iconos de tu sistema
# - icon_size y max_icon_size ajustan el tamaño

[global]
    font = "$FONT"
    corner_radius = $CORNER_RADIUS
    progress_bar = $PROGRESS_BAR
    progress_bar_height = $PROGRESS_BAR_HEIGHT
    highlight = "$PROGRESS_BAR_COLOR"
    frame_width = $FRAME_WIDTH
    padding = $PADDING
    horizontal_padding = $H_PADDING
    separator_height = $SEPARATOR_HEIGHT
    separator_color = "$SEPARATOR_COLOR"
    opacity = $OPACITY
    icon_position = $ICON_POSITION
    icon_size = $ICON_SIZE
    max_icon_size = $MAX_ICON_SIZE
    icon_corner_radius = $ICON_RADIUS
    icon_path = $ICON_PATH
    background = "$BG"
    foreground = "$FG"
    frame_color = "$FRAME"
    geometry = "$GEOMETRY"
    offset = $OFFSET
    width = $WIDTH
    height = $HEIGHT
    notification_limit = $NOTIF_LIMIT
    history_length = $HISTORY_LENGTH
    stack_duplicates = $STACK_DUPLICATES
    show_indicators = $SHOW_INDICATORS
    markup = $MARKUP
    format = "$FORMAT"

[urgency_low]
    background = "$LOW_BG"
    foreground = "$LOW_FG"
    frame_color = "$LOW_FRAME"
    timeout = 4

[urgency_normal]
    background = "$NORM_BG"
    foreground = "$NORM_FG"
    frame_color = "$NORM_FRAME"
    timeout = 8

[urgency_critical]
    background = "$CRIT_BG"
    foreground = "$CRIT_FG"
    frame_color = "$CRIT_FRAME"
    highlight = "$HL"
    timeout = 0
    sound = $CRIT_SOUND

# Regla personalizada para Spotify
[rule]
    appname = "Spotify"
    urgency = low
    background = "#1db954cc"
    foreground = "#ffffff"
    frame_color = "#191414cc"
    icon_position = off
    timeout = 6
EOF
  echo "ℹ️  El archivo estaba vacío, se escribió una configuración base avanzada."
  exit 0
fi

# Reemplaza o inserta las opciones principales en [global]
sed -i \
  -e "s|^\(\s*font\s*=\s*\).*|\1\"$FONT\"|" \
  -e "s|^\(\s*corner_radius\s*=\s*\).*|\1$CORNER_RADIUS|" \
  -e "s|^\(\s*progress_bar\s*=\s*\).*|\1$PROGRESS_BAR|" \
  -e "s|^\(\s*progress_bar_height\s*=\s*\).*|\1$PROGRESS_BAR_HEIGHT|" \
  -e "s|^\(\s*highlight\s*=\s*\).*|\1\"$PROGRESS_BAR_COLOR\"|" \
  -e "s|^\(\s*frame_width\s*=\s*\).*|\1$FRAME_WIDTH|" \
  -e "s|^\(\s*padding\s*=\s*\).*|\1$PADDING|" \
  -e "s|^\(\s*horizontal_padding\s*=\s*\).*|\1$H_PADDING|" \
  -e "s|^\(\s*separator_height\s*=\s*\).*|\1$SEPARATOR_HEIGHT|" \
  -e "s|^\(\s*separator_color\s*=\s*\).*|\1\"$SEPARATOR_COLOR\"|" \
  -e "s|^\(\s*opacity\s*=\s*\).*|\1$OPACITY|" \
  -e "s|^\(\s*icon_position\s*=\s*\).*|\1$ICON_POSITION|" \
  -e "s|^\(\s*icon_size\s*=\s*\).*|\1$ICON_SIZE|" \
  -e "s|^\(\s*max_icon_size\s*=\s*\).*|\1$MAX_ICON_SIZE|" \
  -e "s|^\(\s*icon_corner_radius\s*=\s*\).*|\1$ICON_RADIUS|" \
  -e "s|^\(\s*icon_path\s*=\s*\).*|\1$ICON_PATH|" \
  -e "s|^\(\s*background\s*=\s*\).*|\1\"$BG\"|" \
  -e "s|^\(\s*foreground\s*=\s*\).*|\1\"$FG\"|" \
  -e "s|^\(\s*frame_color\s*=\s*\).*|\1\"$FRAME\"|" \
  -e "s|^\(\s*geometry\s*=\s*\).*|\1\"$GEOMETRY\"|" \
  -e "s|^\(\s*offset\s*=\s*\).*|\1$OFFSET|" \
  -e "s|^\(\s*width\s*=\s*\).*|\1$WIDTH|" \
  -e "s|^\(\s*height\s*=\s*\).*|\1$HEIGHT|" \
  -e "s|^\(\s*notification_limit\s*=\s*\).*|\1$NOTIF_LIMIT|" \
  -e "s|^\(\s*history_length\s*=\s*\).*|\1$HISTORY_LENGTH|" \
  -e "s|^\(\s*stack_duplicates\s*=\s*\).*|\1$STACK_DUPLICATES|" \
  -e "s|^\(\s*show_indicators\s*=\s*\).*|\1$SHOW_INDICATORS|" \
  -e "s|^\(\s*markup\s*=\s*\).*|\1$MARKUP|" \
  -e "s|^\(\s*format\s*=\s*\).*|\1\"$FORMAT\"|" \
  "$DUNST_CONFIG"

# Sección [urgency_low]
sed -i "/^\[urgency_low\]/,/^\[/ { 
    s|^\(\s*background\s*=\s*\).*|\1\"$LOW_BG\"|
    s|^\(\s*foreground\s*=\s*\).*|\1\"$LOW_FG\"|
    s|^\(\s*frame_color\s*=\s*\).*|\1\"$LOW_FRAME\"|
    s|^\(\s*timeout\s*=\s*\).*|\14|
}" "$DUNST_CONFIG"

# Sección [urgency_normal]
sed -i "/^\[urgency_normal\]/,/^\[/ { 
    s|^\(\s*background\s*=\s*\).*|\1\"$NORM_BG\"|
    s|^\(\s*foreground\s*=\s*\).*|\1\"$NORM_FG\"|
    s|^\(\s*frame_color\s*=\s*\).*|\1\"$NORM_FRAME\"|
    s|^\(\s*timeout\s*=\s*\).*|\18|
}" "$DUNST_CONFIG"

# Sección [urgency_critical]
sed -i "/^\[urgency_critical\]/,/^\[/ { 
    s|^\(\s*background\s*=\s*\).*|\1\"$CRIT_BG\"|
    s|^\(\s*foreground\s*=\s*\).*|\1\"$CRIT_FG\"|
    s|^\(\s*frame_color\s*=\s*\).*|\1\"$CRIT_FRAME\"|
    s|^\(\s*highlight\s*=\s*\).*|\1\"$HL\"|
    s|^\(\s*timeout\s*=\s*\).*|\10|
    s|^\(\s*sound\s*=\s*\).*|\1$CRIT_SOUND|
}" "$DUNST_CONFIG"

# Regla personalizada para Spotify (si ya existe, la reemplaza; si no, la añade al final)
if grep -q '\[rule\]' "$DUNST_CONFIG" && grep -A 5 '\[rule\]' "$DUNST_CONFIG" | grep -q 'appname = "Spotify"'; then
  sed -i "/\[rule\]/,/^\[/ { 
        /appname = \"Spotify\"/!b
        s|^\(\s*urgency\s*=\s*\).*|\1low|
        s|^\(\s*background\s*=\s*\).*|\1\"#1db954cc\"|
        s|^\(\s*foreground\s*=\s*\).*|\1\"#ffffff\"|
        s|^\(\s*frame_color\s*=\s*\).*|\1\"#191414cc\"|
        s|^\(\s*icon_position\s*=\s*\).*|\1off|
        s|^\(\s*timeout\s*=\s*\).*|\16|
    }" "$DUNST_CONFIG"
else
  cat >>"$DUNST_CONFIG" <<EOF

[rule]
    appname = "Spotify"
    urgency = low
    background = "#1db954cc"
    foreground = "#ffffff"
    frame_color = "#191414cc"
    icon_position = off
    timeout = 6
EOF
fi

echo "✅ Dunst personalizado completamente con pywal y configuración avanzada en $DUNST_CONFIG"
echo "💡 Recarga Dunst con: killall dunst && dunst &"
