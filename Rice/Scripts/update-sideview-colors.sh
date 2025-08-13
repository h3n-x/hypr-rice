#!/bin/bash

# --------------------------------------------------------------
# Proyecto creado por hen-x
# GitHub: https://github.com/hen-x
# --------------------------------------------------------------

SIDEVIEW_FILE="$HOME/.mozilla/firefox/*/chrome/includes/cascade-sideview.css"
PYWAL="$HOME/.cache/wal/colors.sh"

# Verifica dependencias
if [ ! -f "$PYWAL" ]; then
  echo "❌ No se encontró $PYWAL. Ejecuta pywal primero."
  exit 1
fi

# Encuentra el archivo de Side View
SIDEVIEW_FILE_PATH=$(find $HOME/.mozilla/firefox/*/chrome/includes/ -name "cascade-sideview.css" 2>/dev/null | head -1)

if [ -z "$SIDEVIEW_FILE_PATH" ]; then
  echo "❌ No se encontró cascade-sideview.css en el perfil de Firefox."
  echo "Asegúrate de que el archivo existe en ~/.mozilla/firefox/*/chrome/integrations/side-view/"
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
mkdir -p "$(dirname "$SIDEVIEW_FILE_PATH")/backup"

# Backup
BACKUP_FILE="$(dirname "$SIDEVIEW_FILE_PATH")/backup/cascade-sideview.css.bak.$(date +%Y%m%d%H%M%S)"
cp "$SIDEVIEW_FILE_PATH" "$BACKUP_FILE"
echo "🗂️  Backup creado: $BACKUP_FILE"

# Mapeo de colores pywal → Side View
BASE_COLOR="$color0"
FRAME_COLOR="$color0"

# Reemplaza los colores en el archivo
sed -i \
  -e "s|background-color: var(--lwt-frame) !important;|background-color: $BASE_COLOR !important;|g" \
  "$SIDEVIEW_FILE_PATH"

echo "✅ Colores de Side View actualizados con pywal en $SIDEVIEW_FILE_PATH"
echo "💡 Reinicia Firefox para aplicar los cambios"
echo "Si algo sale mal, puedes restaurar el backup: cp $BACKUP_FILE $SIDEVIEW_FILE_PATH"
