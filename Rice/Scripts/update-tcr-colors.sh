#!/bin/bash

# --------------------------------------------------------------
# Proyecto creado por hen-x
# GitHub: https://github.com/hen-x
# --------------------------------------------------------------

TCR_FILE="$HOME/.mozilla/firefox/*/chrome/includes/cascade-tcr.css"
PYWAL="$HOME/.cache/wal/colors.sh"

# Verifica dependencias
if [ ! -f "$PYWAL" ]; then
  echo "❌ No se encontró $PYWAL. Ejecuta pywal primero."
  exit 1
fi

# Encuentra el archivo de TCR
TCR_FILE_PATH=$(find $HOME/.mozilla/firefox/*/chrome/includes/ -name "cascade-tcr.css" 2>/dev/null | head -1)

if [ -z "$TCR_FILE_PATH" ]; then
  echo "❌ No se encontró cascade-tcr.css en el perfil de Firefox."
  echo "Asegúrate de que el archivo existe en ~/.mozilla/firefox/*/chrome/integrations/tabcenter-reborn/"
  exit 1
fi

# Carga colores de pywal
source "$PYWAL"

# Validación: aborta si algún color está vacío
if [ -z "$color0" ] || [ -z "$color7" ]; then
  echo "❌ Error: No se pudieron cargar los colores de pywal. ¿Ejecutaste pywal recientemente?"
  exit 1
fi

# Crea directorio de backup si no existe
mkdir -p "$(dirname "$TCR_FILE_PATH")/backup"

# Backup
BACKUP_FILE="$(dirname "$TCR_FILE_PATH")/backup/cascade-tcr.css.bak.$(date +%Y%m%d%H%M%S)"
cp "$TCR_FILE_PATH" "$BACKUP_FILE"
echo "🗂️  Backup creado: $BACKUP_FILE"

# Mapeo de colores pywal → TCR
BASE_COLOR="$color0"
BORDER_COLOR="$color1"

# Reemplaza los colores en el archivo (si hay alguno)
# Este archivo es principalmente estructural, pero podemos actualizar bordes si los hay
sed -i \
  -e "s|border-right: none;|border-right: 1px solid $BORDER_COLOR;|g" \
  "$TCR_FILE_PATH"

echo "✅ Colores de TabCenter Reborn (TCR) actualizados con pywal en $TCR_FILE_PATH"
echo "💡 Reinicia Firefox para aplicar los cambios"
echo "Si algo sale mal, puedes restaurar el backup: cp $BACKUP_FILE $TCR_FILE_PATH"
