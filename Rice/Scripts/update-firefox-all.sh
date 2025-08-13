#!/bin/bash

# --------------------------------------------------------------
# Proyecto creado por hen-x
# GitHub: https://github.com/hen-x
# --------------------------------------------------------------

PYWAL="$HOME/.cache/wal/colors.sh"

# Verifica dependencias
if [ ! -f "$PYWAL" ]; then
  echo "❌ No se encontró $PYWAL. Ejecuta pywal primero."
  exit 1
fi

echo "🎨 Actualizando todos los archivos CSS de Firefox con pywal..."
echo ""

# Ejecuta todos los scripts en secuencia
echo "1️⃣  Actualizando colores principales de Firefox..."
./update-firefox-colors.sh
echo ""

echo "2️⃣  Actualizando colores de TabCenter Reborn..."
./update-tabcenter-colors.sh
echo ""

echo "3️⃣  Actualizando colores de Side View..."
./update-sideview-colors.sh
echo ""

echo "4️⃣  Actualizando colores de TabCenter Reborn (TCR)..."
./update-tcr-colors.sh
echo ""

echo "✅ Todos los archivos CSS de Firefox han sido actualizados con pywal"
echo "💡 Reinicia Firefox para aplicar todos los cambios"
echo ""
echo "📁 Archivos actualizados:"
echo "   - cascade-colours.css (colores principales)"
echo "   - tabcenter-reborn.css (TabCenter Reborn)"
echo "   - cascade-sideview.css (Side View)"
echo "   - cascade-tcr.css (TabCenter Reborn TCR)"
echo ""
echo "🎯 Para aplicar cambios automáticamente en el futuro,"
echo "   puedes agregar este script a tu autostart o ejecutarlo"
echo "   después de cambiar el wallpaper con pywal."

