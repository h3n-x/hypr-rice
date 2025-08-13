#!/bin/bash
# Script para configurar integración de sonidos con hyprlock

echo "🔊 Configurando integración de sonidos para hyprlock..."

SOUND_DIR="/home/h3n/Rice/Notifications"
SCRIPT_DIR="$HOME/.config/hypr/scripts"
HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"

# Verificar que existen los archivos de sonido
echo "🔍 Verificando archivos de sonido..."
missing_sounds=()

if [ ! -f "$SOUND_DIR/lock.wav" ]; then
  missing_sounds+=("lock.wav")
fi

if [ ! -f "$SOUND_DIR/unlock.wav" ]; then
  missing_sounds+=("unlock.wav")
fi

if [ ! -f "$SOUND_DIR/wrong.wav" ]; then
  missing_sounds+=("wrong.wav")
fi

if [ ${#missing_sounds[@]} -gt 0 ]; then
  echo "❌ Archivos de sonido faltantes en $SOUND_DIR:"
  for sound in "${missing_sounds[@]}"; do
    echo "   - $sound"
  done
  echo ""
  echo "Por favor, asegúrate de que estos archivos existan antes de continuar."
  exit 1
fi

echo "✅ Todos los archivos de sonido encontrados"

# Hacer ejecutable el script principal
chmod +x "$SCRIPT_DIR/hyprlock_with_sounds.sh"

# Crear alias para usar el nuevo script
echo "📝 Configurando alias..."

# Agregar alias al .bashrc y .zshrc si existen
for shell_config in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [ -f "$shell_config" ]; then
    # Remover alias previo si existe
    sed -i '/^alias hyprlock=/d' "$shell_config"
    # Agregar nuevo alias
    echo "alias hyprlock='$SCRIPT_DIR/hyprlock_with_sounds.sh'" >>"$shell_config"
    echo "   ✅ Alias agregado a $(basename "$shell_config")"
  fi
done

# Crear script de keybinding para Hyprland
cat >"$SCRIPT_DIR/lock_screen.sh" <<'EOF'
#!/bin/bash
# Script para bloquear pantalla con sonidos integrados
exec ~/.config/hypr/scripts/hyprlock_with_sounds.sh
EOF

chmod +x "$SCRIPT_DIR/lock_screen.sh"

# Sugerir configuración de keybinding para Hyprland
echo ""
echo "🎹 Para integrar con Hyprland, agrega esta línea a tu hyprland.conf:"
echo ""
echo "bind = SUPER, L, exec, ~/.config/hypr/scripts/lock_screen.sh"
echo ""
echo "O reemplaza tu keybinding actual de hyprlock con lock_screen.sh"

# Verificar herramientas de audio disponibles
echo ""
echo "🔧 Verificando herramientas de audio disponibles..."
audio_tools=()

if command -v paplay >/dev/null 2>&1; then
  audio_tools+=("paplay (PulseAudio)")
fi

if command -v aplay >/dev/null 2>&1; then
  audio_tools+=("aplay (ALSA)")
fi

if command -v ffplay >/dev/null 2>&1; then
  audio_tools+=("ffplay (FFmpeg)")
fi

if [ ${#audio_tools[@]} -eq 0 ]; then
  echo "⚠️  No se encontraron herramientas de audio. Instala una de estas:"
  echo "   - PulseAudio: sudo pacman -S pulseaudio"
  echo "   - ALSA: sudo pacman -S alsa-utils"
  echo "   - FFmpeg: sudo pacman -S ffmpeg"
else
  echo "✅ Herramientas de audio encontradas:"
  for tool in "${audio_tools[@]}"; do
    echo "   - $tool"
  done
fi

echo ""
echo "✅ ¡Configuración completada!"
echo ""
echo "📋 Próximos pasos:"
echo "1. Reinicia tu terminal o ejecuta: source ~/.bashrc (o ~/.zshrc)"
echo "2. Usa 'hyprlock' normalmente - ahora incluye sonidos automáticamente"
echo "3. O usa directamente: ~/.config/hypr/scripts/lock_screen.sh"
echo "4. Configura el keybinding sugerido en hyprland.conf"
echo ""
echo "🎵 Sonidos configurados:"
echo "   • Bloqueo: $SOUND_DIR/lock.wav"
echo "   • Desbloqueo: $SOUND_DIR/unlock.wav"
echo "   • Error de contraseña: $SOUND_DIR/wrong.wav"
