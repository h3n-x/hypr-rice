#!/bin/bash

# Script de configuración mejorado para Matrix lock screen
# Combina nuestra funcionalidad con el diseño elaborado

echo "🚀 Configurando Matrix lock screen mejorado..."

# Crear directorios necesarios
mkdir -p ~/.config/hypr/scripts

# Hacer scripts ejecutables
chmod +x ~/.config/hypr/scripts/word_clock_matrix.sh
chmod +x ~/.config/hypr/scripts/generate_matrix_hyprlock.sh
chmod +x ~/.config/hypr/scripts/update_hyprlock_colors.sh

# Generar configuración inicial
~/.config/hypr/scripts/generate_matrix_hyprlock.sh

# Crear hook de pywal para actualización automática
PYWAL_HOOK_DIR="$HOME/.config/wal/templates"
mkdir -p "$PYWAL_HOOK_DIR"

cat >"$PYWAL_HOOK_DIR/hyprlock-matrix-update.sh" <<'EOF'
#!/bin/bash
# Hook automático de pywal - se ejecuta después de cambiar wallpaper
echo "🎨 Pywal detectado - actualizando colores Matrix lock..."
~/.config/hypr/scripts/generate_matrix_hyprlock.sh
echo "✅ ¡Colores Matrix lock screen actualizados!"
EOF

chmod +x "$PYWAL_HOOK_DIR/hyprlock-matrix-update.sh"

# Verificar configuración del avatar de usuario
USER_FACE="$HOME/.face"

echo ""
echo "🖼️  Verificando avatar de usuario..."

if [ -f "$USER_FACE" ]; then
  echo "✅ Avatar de usuario encontrado en ~/.face"
  file "$USER_FACE" 2>/dev/null || echo "   Archivo válido detectado"
else
  echo "❌ No se encontró avatar en ~/.face"
  echo ""
  echo "📋 Para agregar tu avatar:"
  echo "   1. Copia tu foto de perfil a ~/.face"
  echo "   2. Formatos recomendados: PNG, JPG (imagen cuadrada funciona mejor)"
  echo "   3. Tamaño recomendado: 200x200 píxeles o mayor"
  echo ""
  echo "Comandos de ejemplo:"
  echo "   cp /ruta/a/tu/foto.jpg ~/.face"
  echo "   # o"
  echo "   wget -O ~/.face 'https://github.com/tuusuario.png'"
  echo ""
  echo "🔄 La pantalla de bloqueo usará un icono de usuario de respaldo si no se encuentra ~/.face"
fi

echo ""
echo "✅ ¡Configuración Matrix mejorada completada!"
echo ""
echo "🎯 Para usar:"
echo "   1. Ejecuta: wal -i /ruta/a/tu/wallpaper.jpg"
echo "   2. Los colores se actualizarán automáticamente"
echo "   3. Prueba hyprlock para ver el resultado"
echo ""
echo "🎨 Características incluidas:"
echo "   • Efectos Matrix animados en múltiples capas"
echo "   • Reloj de palabras con matriz personalizada"
echo "   • Colores dinámicos de pywal"
echo "   • Efectos de brillo y sombras"
echo "   • Animaciones sutiles y pulsantes"
echo "   • Orden: Imagen → Reloj → Contraseña"
