#!/bin/bash

# --------------------------------------------------------------
# Proyecto creado por hen-x
# GitHub: https://github.com/hen-x
# --------------------------------------------------------------

TABCENTER_FILE="$HOME/.mozilla/firefox/*/chrome/includes/tabcenter-reborn.css"
PYWAL="$HOME/.cache/wal/colors.sh"

# Verifica dependencias
if [ ! -f "$PYWAL" ]; then
  echo "❌ No se encontró $PYWAL. Ejecuta pywal primero."
  exit 1
fi

# Encuentra el archivo de TabCenter
TABCENTER_FILE_PATH=$(find $HOME/.mozilla/firefox/*/chrome/includes -name "tabcenter-reborn.css" 2>/dev/null | head -1)

if [ -z "$TABCENTER_FILE_PATH" ]; then
  echo "❌ No se encontró tabcenter-reborn.css en el perfil de Firefox."
  echo "Asegúrate de que el archivo existe en ~/.mozilla/firefox/*/chrome/includes/tabcenter-reborn.css"
  exit 1
fi

# Carga colores de pywal
source "$PYWAL"

# Validación: aborta si algún color está vacío
if [ -z "$color0" ] || [ -z "$color7" ] || [ -z "$color1" ] || [ -z "$color3" ] || [ -z "$color4" ] || [ -z "$color2" ] || [ -z "$color5" ] || [ -z "$color6" ]; then
  echo "❌ Error: No se pudieron cargar los colores de pywal. ¿Ejecutaste pywal recientemente?"
  exit 1
fi

# Crea directorio de backup si no existe
mkdir -p "$(dirname "$TABCENTER_FILE_PATH")/backup"

# Backup
BACKUP_FILE="$(dirname "$TABCENTER_FILE_PATH")/backup/tabcenter-reborn.css.bak.$(date +%Y%m%d%H%M%S)"
cp "$TABCENTER_FILE_PATH" "$BACKUP_FILE"
echo "🗂️  Backup creado: $BACKUP_FILE"

# Mapeo de colores pywal → TabCenter
BASE_COLOR="$color0"
HIGHLIGHT_COLOR="$color8"
INVERTED_COLOR="$color7"
MUTED_COLOR="$color15"
ACCENT_COLOR="$color4"

# Colores de identidad (container tabs)
IDENTITY_BLUE="$color4"
IDENTITY_TURQUOISE="$color6"
IDENTITY_GREEN="$color2"
IDENTITY_YELLOW="$color3"
IDENTITY_ORANGE="$color5"
IDENTITY_RED="$color1"
IDENTITY_PINK="$color7"
IDENTITY_PURPLE="$color0"

# Reemplaza los colores en el archivo
sed -i \
  -e "s|--uc-identity-colour-blue: #[a-fA-F0-9]\{6\}|--uc-identity-colour-blue: $IDENTITY_BLUE|g" \
  -e "s|--uc-identity-colour-turquoise: #[a-fA-F0-9]\{6\}|--uc-identity-colour-turquoise: $IDENTITY_TURQUOISE|g" \
  -e "s|--uc-identity-colour-green: #[a-fA-F0-9]\{6\}|--uc-identity-colour-green: $IDENTITY_GREEN|g" \
  -e "s|--uc-identity-colour-yellow: #[a-fA-F0-9]\{6\}|--uc-identity-colour-yellow: $IDENTITY_YELLOW|g" \
  -e "s|--uc-identity-colour-orange: #[a-fA-F0-9]\{6\}|--uc-identity-colour-orange: $IDENTITY_ORANGE|g" \
  -e "s|--uc-identity-colour-red: #[a-fA-F0-9]\{6\}|--uc-identity-colour-red: $IDENTITY_RED|g" \
  -e "s|--uc-identity-colour-pink: #[a-fA-F0-9]\{6\}|--uc-identity-colour-pink: $IDENTITY_PINK|g" \
  -e "s|--uc-identity-colour-purple: #[a-fA-F0-9]\{6\}|--uc-identity-colour-purple: $IDENTITY_PURPLE|g" \
  -e "s|--uc-base-colour: #[a-fA-F0-9]\{6\}|--uc-base-colour: $BASE_COLOR|g" \
  -e "s|--uc-highlight-colour: #[a-fA-F0-9]\{6\}|--uc-highlight-colour: $HIGHLIGHT_COLOR|g" \
  -e "s|--uc-inverted-colour: #[a-fA-F0-9]\{6\}|--uc-inverted-colour: $INVERTED_COLOR|g" \
  -e "s|--uc-muted-colour: #[a-fA-F0-9]\{6\}|--uc-muted-colour: $MUTED_COLOR|g" \
  -e "s|--uc-accent-colour: #[a-fA-F0-9]\{6\}|--uc-accent-colour: $ACCENT_COLOR|g" \
  "$TABCENTER_FILE_PATH"

echo "✅ Colores de TabCenter Reborn actualizados con pywal en $TABCENTER_FILE_PATH"
echo "💡 Reinicia Firefox para aplicar los cambios"
echo "Si algo sale mal, puedes restaurar el backup: cp $BACKUP_FILE $TABCENTER_FILE_PATH"
