#!/bin/bash

# --------------------------------------------------------------
# Proyecto creado por hen-x
# GitHub: https://github.com/hen-x
# --------------------------------------------------------------

# Configuración de rutas
SPICETIFY_CONFIG_DIR="$HOME/.config/spicetify"
SPICETIFY_THEMES_DIR="$SPICETIFY_CONFIG_DIR/Themes"
PYWAL_THEME_DIR="$SPICETIFY_THEMES_DIR/pywal"
COLOR_INI_FILE="$PYWAL_THEME_DIR/color.ini"
USER_CSS_FILE="$PYWAL_THEME_DIR/user.css"
PYWAL_COLORS_SH="$HOME/.cache/wal/colors.sh"
PYWAL_COLORS_JSON="$HOME/.cache/wal/colors.json"

# Crear directorios necesarios
mkdir -p "$PYWAL_THEME_DIR"

# Verificar que existan los archivos de pywal
if [ ! -f "$PYWAL_COLORS_SH" ]; then
  echo "❌ Error: No se encontró el archivo de colores de pywal: $PYWAL_COLORS_SH"
  echo "Ejecuta pywal primero con: wal -i /path/to/wallpaper"
  exit 1
fi

# Verificar que spicetify esté instalado
if ! command -v spicetify &>/dev/null; then
  echo "❌ Error: Spicetify no está instalado"
  echo "Instala Spicetify primero: https://spicetify.app/docs/getting-started"
  exit 1
fi

# Función para convertir color hex a formato sin #
hex_clean() {
  local hex="$1"
  echo "${hex#\#}"
}

# Función para generar color más claro
lighten_color() {
  local hex="$1"
  local factor="${2:-20}"

  # Remover el # si existe
  hex="${hex#\#}"

  # Convertir hex a RGB
  local r=$((16#${hex:0:2}))
  local g=$((16#${hex:2:2}))
  local b=$((16#${hex:4:2}))

  # Aumentar brillo
  r=$((r + factor > 255 ? 255 : r + factor))
  g=$((g + factor > 255 ? 255 : g + factor))
  b=$((b + factor > 255 ? 255 : b + factor))

  # Convertir de vuelta a hex
  printf "%02x%02x%02x" $r $g $b
}

# Función para generar color más oscuro
darken_color() {
  local hex="$1"
  local factor="${2:-20}"

  # Remover el # si existe
  hex="${hex#\#}"

  # Convertir hex a RGB
  local r=$((16#${hex:0:2}))
  local g=$((16#${hex:2:2}))
  local b=$((16#${hex:4:2}))

  # Reducir brillo
  r=$((r - factor < 0 ? 0 : r - factor))
  g=$((g - factor < 0 ? 0 : g - factor))
  b=$((b - factor < 0 ? 0 : b - factor))

  # Convertir de vuelta a hex
  printf "%02x%02x%02x" $r $g $b
}

# Función para leer colores de pywal
read_pywal_colors() {
  # Leer colores desde el archivo de pywal
  source "$PYWAL_COLORS_SH" 2>/dev/null || {
    echo "❌ Error: No se pudo leer el archivo de colores de pywal"
    exit 1
  }
}

# Función para generar el archivo color.ini con colores de pywal
generate_color_ini() {
  # Leer colores de pywal
  read_pywal_colors

  echo "# Spicetify Theme con colores de pywal"
  echo "# Generado automáticamente el $(date)"
  echo "# Basado en wallpaper: $wallpaper"
  echo ""
  echo "[pywal]"
  echo "# === COLORES PRINCIPALES DE SPICETIFY ==="
  echo "text               = $(hex_clean "$foreground")"
  echo "subtext            = $(hex_clean "$color7")"
  echo "main               = $(hex_clean "$background")"
  echo "main-elevated      = $(hex_clean "$color0")"
  echo "highlight          = $(lighten_color "$background" 15)"
  echo "highlight-elevated = $(lighten_color "$color0" 20)"
  echo "sidebar            = $(darken_color "$background" 10)"
  echo "player             = $(darken_color "$background" 15)"
  echo "card               = $(hex_clean "$color0")"
  echo "shadow             = $(darken_color "$background" 20)"
  echo "selected-row       = $(hex_clean "$color8")"
  echo "button             = $(hex_clean "$color2")"
  echo "button-active      = $(hex_clean "$color4")"
  echo "button-disabled    = $(hex_clean "$color8")"
  echo "tab-active         = $(hex_clean "$color0")"
  echo "notification       = $(hex_clean "$color0")"
  echo "notification-error = $(hex_clean "$color1")"
  echo "equalizer          = $(hex_clean "$color3")"
  echo "misc               = $(lighten_color "$color0" 10)"
  echo ""
  echo "# === COLORES EXTENDIDOS BASADOS EN PYWAL ==="
  echo "# Colores base de pywal adaptados"
  echo "crust              = $(darken_color "$background" 25)"
  echo "mantle             = $(darken_color "$background" 20)"
  echo "base               = $(hex_clean "$background")"
  echo "surface0           = $(hex_clean "$color0")"
  echo "surface1           = $(lighten_color "$color0" 10)"
  echo "surface2           = $(lighten_color "$color0" 20)"
  echo "overlay0           = $(hex_clean "$color8")"
  echo "overlay1           = $(hex_clean "$color2")"
  echo "overlay2           = $(hex_clean "$color4")"
  echo ""
  echo "# === COLORES TEMÁTICOS ==="
  echo "# Adaptados desde la paleta de pywal"
  echo "rosewater          = $(hex_clean "$color15")"
  echo "flamingo           = $(hex_clean "$color14")"
  echo "pink               = $(hex_clean "$color5")"
  echo "maroon             = $(hex_clean "$color1")"
  echo "red                = $(hex_clean "$color1")"
  echo "peach              = $(hex_clean "$color3")"
  echo "yellow             = $(hex_clean "$color3")"
  echo "green              = $(hex_clean "$color2")"
  echo "teal               = $(hex_clean "$color6")"
  echo "sapphire           = $(hex_clean "$color4")"
  echo "blue               = $(hex_clean "$color4")"
  echo "sky                = $(hex_clean "$color6")"
  echo "mauve              = $(hex_clean "$color5")"
  echo "lavender           = $(hex_clean "$color7")"
}

# Función para generar CSS personalizado
generate_user_css() {
  # Leer colores de pywal
  read_pywal_colors

  echo "/* CSS personalizado para Spicetify con colores de pywal */"
  echo "/* Generado automáticamente el $(date) */"
  echo "/* Wallpaper: $wallpaper */"
  echo ""

  echo "/* === VARIABLES CSS PERSONALIZADAS === */"
  echo ":root {"
  echo "    --pywal-background: $background;"
  echo "    --pywal-foreground: $foreground;"
  echo "    --pywal-color0: $color0;"
  echo "    --pywal-color1: $color1;"
  echo "    --pywal-color2: $color2;"
  echo "    --pywal-color3: $color3;"
  echo "    --pywal-color4: $color4;"
  echo "    --pywal-color5: $color5;"
  echo "    --pywal-color6: $color6;"
  echo "    --pywal-color7: $color7;"
  echo "    --pywal-color8: $color8;"
  echo "}"
  echo ""

  echo "/* === MEJORAS VISUALES PERSONALIZADAS === */"
  echo ""

  echo "/* Barra de progreso personalizada */"
  echo ".progress-bar {"
  echo "    background: linear-gradient(90deg, $color1, $color4) !important;"
  echo "    border-radius: 4px !important;"
  echo "}"
  echo ""

  echo "/* Botones con gradiente sutil */"
  echo ".Button--style-green, .Button--style-default {"
  echo "    background: linear-gradient(135deg, $color2, $color4) !important;"
  echo "    border: 1px solid $color1 !important;"
  echo "    transition: all 0.3s ease !important;"
  echo "}"
  echo ""
  echo ".Button--style-green:hover, .Button--style-default:hover {"
  echo "    background: linear-gradient(135deg, $color4, $color6) !important;"
  echo "    transform: translateY(-1px) !important;"
  echo "    box-shadow: 0 4px 12px rgba($(hex_to_rgb "$color1"), 0.3) !important;"
  echo "}"
  echo ""

  echo "/* Sidebar con efecto glassmorphism */"
  echo ".Root__nav-bar {"
  echo "    background: rgba($(hex_to_rgb "$background"), 0.85) !important;"
  echo "    backdrop-filter: blur(10px) !important;"
  echo "    border-right: 1px solid rgba($(hex_to_rgb "$color1"), 0.2) !important;"
  echo "}"
  echo ""

  echo "/* Cards con sombra personalizada */"
  echo ".Card, .card {"
  echo "    background: $color0 !important;"
  echo "    border: 1px solid rgba($(hex_to_rgb "$color1"), 0.1) !important;"
  echo "    border-radius: 8px !important;"
  echo "    box-shadow: 0 2px 8px rgba($(hex_to_rgb "$background"), 0.3) !important;"
  echo "    transition: all 0.3s ease !important;"
  echo "}"
  echo ""
  echo ".Card:hover, .card:hover {"
  echo "    transform: translateY(-2px) !important;"
  echo "    box-shadow: 0 4px 16px rgba($(hex_to_rgb "$color1"), 0.2) !important;"
  echo "}"
  echo ""

  echo "/* Player controls mejorados */"
  echo ".player-controls {"
  echo "    background: rgba($(hex_to_rgb "$color0"), 0.9) !important;"
  echo "    border-radius: 12px !important;"
  echo "    padding: 8px !important;"
  echo "    margin: 4px !important;"
  echo "}"
  echo ""

  echo "/* Scrollbar personalizada */"
  echo "::-webkit-scrollbar {"
  echo "    width: 8px !important;"
  echo "}"
  echo ""
  echo "::-webkit-scrollbar-track {"
  echo "    background: $color0 !important;"
  echo "    border-radius: 4px !important;"
  echo "}"
  echo ""
  echo "::-webkit-scrollbar-thumb {"
  echo "    background: linear-gradient(180deg, $color2, $color4) !important;"
  echo "    border-radius: 4px !important;"
  echo "}"
  echo ""
  echo "::-webkit-scrollbar-thumb:hover {"
  echo "    background: linear-gradient(180deg, $color4, $color6) !important;"
  echo "}"
  echo ""

  echo "/* Animaciones suaves para transiciones */"
  echo "* {"
  echo "    transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease !important;"
  echo "}"
  echo ""

  echo "/* Efectos de hover mejorados */"
  echo ".main-trackList-rowSectionVariable:hover {"
  echo "    background: rgba($(hex_to_rgb "$color1"), 0.1) !important;"
  echo "}"
  echo ""

  echo "/* Personalización del now playing */"
  echo ".Root__now-playing-bar {"
  echo "    background: linear-gradient(90deg, rgba($(hex_to_rgb "$background"), 0.95), rgba($(hex_to_rgb "$color0"), 0.95)) !important;"
  echo "    border-top: 1px solid rgba($(hex_to_rgb "$color1"), 0.2) !important;"
  echo "}"
}

# Función auxiliar para convertir hex a RGB
hex_to_rgb() {
  local hex="$1"
  hex="${hex#\#}"
  local r=$((16#${hex:0:2}))
  local g=$((16#${hex:2:2}))
  local b=$((16#${hex:4:2}))
  echo "$r, $g, $b"
}

# Función para aplicar el tema en Spicetify
apply_spicetify_theme() {
  echo "🎵 Aplicando tema pywal en Spicetify..."

  # Configurar Spicetify para usar el tema pywal
  spicetify config current_theme pywal 2>/dev/null || {
    echo "⚠️  Configurando tema pywal por primera vez..."
    spicetify config current_theme pywal
  }

  # Aplicar los cambios
  if spicetify apply 2>/dev/null; then
    echo "✅ Tema aplicado exitosamente"
  else
    echo "⚠️  Hubo un problema al aplicar el tema. Intentando backup y restore..."
    spicetify backup apply 2>/dev/null || {
      echo "❌ Error al aplicar el tema. Verifica tu instalación de Spicetify"
      return 1
    }
  fi
}

# Función para crear script de lanzamiento
generate_spicetify_launcher() {
  local launcher_file="$PYWAL_THEME_DIR/apply-theme.sh"

  echo "#!/bin/bash"
  echo "# Script para aplicar tema pywal a Spicetify"
  echo "# Generado automáticamente el $(date)"
  echo ""
  echo "# Verificar que Spicetify esté instalado"
  echo "if ! command -v spicetify &> /dev/null; then"
  echo "    echo \"❌ Error: Spicetify no está instalado\""
  echo "    exit 1"
  echo "fi"
  echo ""
  echo "# Aplicar tema"
  echo "echo \"🎵 Aplicando tema pywal a Spicetify...\""
  echo "spicetify config current_theme pywal"
  echo "spicetify apply"
  echo ""
  echo "if [ \$? -eq 0 ]; then"
  echo "    echo \"✅ Tema aplicado exitosamente\""
  echo "else"
  echo "    echo \"❌ Error al aplicar el tema\""
  echo "    exit 1"
  echo "fi"

  chmod +x "$launcher_file"
}

# Función para crear aliases útiles
create_spicetify_aliases() {
  local aliases_file="$PYWAL_THEME_DIR/spicetify-aliases.sh"

  echo "#!/bin/bash"
  echo "# Aliases útiles para Spicetify con pywal"
  echo "# Fuente este archivo en tu .bashrc o .zshrc:"
  echo "# source ~/.config/spicetify/Themes/pywal/spicetify-aliases.sh"
  echo ""
  echo "# Alias principales"
  echo "alias spicetify-update='$PWD/update-spicetify-colors.sh'"
  echo "alias spicetify-apply='$PYWAL_THEME_DIR/apply-theme.sh'"
  echo "alias spicetify-restore='spicetify restore'"
  echo ""
  echo "# Funciones útiles"
  echo "spicetify-reload() {"
  echo "    echo \"🔄 Recargando tema de Spicetify...\""
  echo "    spicetify apply"
  echo "    echo \"✅ Tema recargado\""
  echo "}"
  echo ""
  echo "spicetify-edit() {"
  echo "    if [ \"\$1\" = \"colors\" ]; then"
  echo "        \${EDITOR:-nano} \"$COLOR_INI_FILE\""
  echo "    elif [ \"\$1\" = \"css\" ]; then"
  echo "        \${EDITOR:-nano} \"$USER_CSS_FILE\""
  echo "    else"
  echo "        echo \"Uso: spicetify-edit [colors|css]\""
  echo "        echo \"  colors - Editar archivo color.ini\""
  echo "        echo \"  css    - Editar archivo user.css\""
  echo "    fi"
  echo "}"
  echo ""
  echo "spicetify-status() {"
  echo "    echo \"📊 Estado de Spicetify:\""
  echo "    spicetify -v"
  echo "    echo \"  Tema actual: \$(spicetify config | grep current_theme | cut -d'=' -f2)\""
  echo "    echo \"  Archivos de tema:\""
  echo "    echo \"    - color.ini: $COLOR_INI_FILE\""
  echo "    echo \"    - user.css: $USER_CSS_FILE\""
  echo "    if [ -f \"$COLOR_INI_FILE\" ]; then"
  echo "        echo \"  ✅ Configuración de colores existe\""
  echo "    else"
  echo "        echo \"  ❌ Configuración de colores no encontrada\""
  echo "    fi"
  echo "}"
  echo ""
  echo "spicetify-reset() {"
  echo "    echo \"🔄 Restaurando Spicetify a configuración por defecto...\""
  echo "    spicetify restore"
  echo "    echo \"✅ Spicetify restaurado\""
  echo "}"
}

# Función para crear documentación
create_documentation() {
  local docs_file="$PYWAL_THEME_DIR/README.md"

  echo "# Tema Pywal para Spicetify"
  echo ""
  echo "Este tema fue generado automáticamente para integrar Spicetify con los colores de pywal."
  echo ""
  echo "## Archivos generados"
  echo ""
  echo "- \`color.ini\` - Configuración de colores principal"
  echo "- \`user.css\` - Estilos CSS personalizados"
  echo "- \`apply-theme.sh\` - Script para aplicar el tema"
  echo "- \`spicetify-aliases.sh\` - Aliases útiles"
  echo "- \`README.md\` - Este archivo"
  echo ""
  echo "## Uso básico"
  echo ""
  echo "\`\`\`bash"
  echo "# Aplicar tema"
  echo "./apply-theme.sh"
  echo ""
  echo "# O manualmente"
  echo "spicetify config current_theme pywal"
  echo "spicetify apply"
  echo "\`\`\`"
  echo ""
  echo "## Personalización"
  echo ""
  echo "### Cambiar colores"
  echo ""
  echo "1. Ejecuta pywal con una nueva imagen:"
  echo "   \`\`\`bash"
  echo "   wal -i /path/to/your/wallpaper.jpg"
  echo "   \`\`\`"
  echo ""
  echo "2. Regenera el tema:"
  echo "   \`\`\`bash"
  echo "   ./update-spicetify-colors.sh"
  echo "   \`\`\`"
  echo ""
  echo "### Modificar estilos"
  echo ""
  echo "Edita \`user.css\` para personalizar:"
  echo "- Efectos visuales"
  echo "- Animaciones"
  echo "- Gradientes"
  echo "- Sombras"
  echo ""
  echo "## Características"
  echo ""
  echo "- ✨ Colores adaptativos basados en pywal"
  echo "- 🎨 Gradientes y efectos visuales"
  echo "- 🌟 Animaciones suaves"
  echo "- 📱 Scrollbar personalizada"
  echo "- 🎵 Controles de reproductor mejorados"
  echo ""
  echo "## Troubleshooting"
  echo ""
  echo "### El tema no se aplica"
  echo ""
  echo "1. Verifica que Spicetify esté instalado:"
  echo "   \`\`\`bash"
  echo "   spicetify -v"
  echo "   \`\`\`"
  echo ""
  echo "### Colores no se actualizan"
  echo ""
  echo "1. Regenera el tema:"
  echo "   \`\`\`bash"
  echo "   ./update-spicetify-colors.sh"
  echo "   \`\`\`"
  echo ""
  echo "2. Aplica los cambios:"
  echo "   \`\`\`bash"
  echo "   spicetify apply"
  echo "   \`\`\`"
  echo ""
  echo "## Compatibilidad"
  echo ""
  echo "- Spicetify v2.0+"
  echo "- Spotify (versiones soportadas por Spicetify)"
  echo "- Pywal (python-pywal)"
  echo ""
  echo "Wallpaper actual: \`$wallpaper\`"
  echo "Generado el: \`$(date)\`"
}

# Función principal
main() {
  echo "🎵 Configurando Spicetify con colores de pywal..."
  echo ""

  # Verificar dependencias
  echo "🔍 Verificando dependencias..."
  if ! command -v spicetify &>/dev/null; then
    echo "⚠️  Advertencia: Spicetify no está instalado"
    echo "   Instala desde: https://spicetify.app/docs/getting-started"
  else
    echo "✅ Spicetify encontrado: $(spicetify -v)"
  fi

  # Generar archivos de configuración
  echo "📝 Generando configuración de colores..."
  generate_color_ini >"$COLOR_INI_FILE"

  echo "🎨 Generando CSS personalizado..."
  generate_user_css >"$USER_CSS_FILE"

  echo "🚀 Creando script de aplicación..."
  generate_spicetify_launcher

  echo "⚡ Creando aliases útiles..."
  create_spicetify_aliases

  echo "📚 Creando documentación..."
  create_documentation

  # Aplicar el tema
  apply_spicetify_theme

  echo ""
  echo "✅ Configuración de Spicetify completada exitosamente!"
  echo "📁 Archivos generados:"
  echo "   - Colores: $COLOR_INI_FILE"
  echo "   - CSS: $USER_CSS_FILE"
  echo "   - Aplicador: $PYWAL_THEME_DIR/apply-theme.sh"
  echo "   - Aliases: $PYWAL_THEME_DIR/spicetify-aliases.sh"
  echo "   - Documentación: $PYWAL_THEME_DIR/README.md"
  echo ""
  echo "🎨 Colores aplicados desde: $PYWAL_COLORS_SH"
  echo ""
  echo "💡 Uso rápido:"
  echo "   - Aplicar tema: $PYWAL_THEME_DIR/apply-theme.sh"
  echo "   - Recargar: spicetify apply"
  echo "   - Activar aliases: source $PYWAL_THEME_DIR/spicetify-aliases.sh"
  echo ""
  echo "🎵 Características incluidas:"
  echo "   - Tema adaptativo con colores de pywal"
  echo "   - CSS personalizado con efectos visuales"
  echo "   - Gradientes y animaciones suaves"
  echo "   - Scrollbar personalizada"
  echo "   - Controles de reproductor mejorados"
  echo ""
  echo "🎯 Próximos pasos:"
  echo "   1. Abre Spotify para ver los cambios"
  echo "   2. Personaliza user.css si deseas más cambios"
  echo "   3. Ejecuta el script cada vez que cambies wallpaper"
  echo ""
  echo "📖 Lee la documentación completa en: $PYWAL_THEME_DIR/README.md"
}

# Ejecutar función principal
main "$@"
