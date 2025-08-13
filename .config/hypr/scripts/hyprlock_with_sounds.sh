#!/bin/bash
# Script wrapper para hyprlock con soporte de sonidos
# Integra lock.wav, unlock.wav y wrong.wav

SOUND_DIR="/home/h3n/Rice/Notifications"
LOCK_SOUND="$SOUND_DIR/lock.wav"
UNLOCK_SOUND="$SOUND_DIR/unlock.wav"
WRONG_SOUND="$SOUND_DIR/wrong.wav"

# PID file para tracking
HYPRLOCK_PID_FILE="/tmp/hyprlock_session.pid"
LOCK_LOG="/tmp/hyprlock.log"

# Función para reproducir sonidos
play_sound() {
  local sound_file="$1"
  if [ -f "$sound_file" ]; then
    # Usar paplay (PulseAudio) o aplay (ALSA) según disponibilidad
    if command -v paplay >/dev/null 2>&1; then
      paplay "$sound_file" &
    elif command -v aplay >/dev/null 2>&1; then
      aplay "$sound_file" &
    elif command -v ffplay >/dev/null 2>&1; then
      ffplay -nodisp -autoexit "$sound_file" >/dev/null 2>&1 &
    fi
  fi
}

# Función para monitorear errores de autenticación
monitor_auth_failures() {
  # Monitorear logs de PAM para detectar fallos de autenticación
  journalctl -f -u hyprlock.service 2>/dev/null | while read -r line; do
    if [[ "$line" =~ "authentication failure" ]] || [[ "$line" =~ "Authentication failure" ]]; then
      play_sound "$WRONG_SOUND"
    fi
  done &
  echo $! >"/tmp/hyprlock_auth_monitor.pid"
}

# Función de limpieza al terminar
cleanup() {
  # Limpiar archivos temporales
  [ -f "$HYPRLOCK_PID_FILE" ] && rm -f "$HYPRLOCK_PID_FILE"
  [ -f "/tmp/hyprlock_auth_monitor.pid" ] && {
    kill "$(cat /tmp/hyprlock_auth_monitor.pid)" 2>/dev/null
    rm -f "/tmp/hyprlock_auth_monitor.pid"
  }
}

# Configurar trap para limpieza
trap cleanup EXIT

# Reproducir sonido de bloqueo al iniciar
play_sound "$LOCK_SOUND"

# Guardar PID para tracking
echo $$ >"$HYPRLOCK_PID_FILE"

# Iniciar monitoreo de fallos de autenticación
monitor_auth_failures

# Ejecutar hyprlock y capturar su salida para detectar eventos
echo "$(date): Hyprlock iniciado" >"$LOCK_LOG"

# Ejecutar hyprlock con logging
hyprlock 2>&1 | while IFS= read -r line; do
  echo "$(date): $line" >>"$LOCK_LOG"

  # Detectar fallo de autenticación en la salida
  if [[ "$line" =~ "Authentication failed" ]] || [[ "$line" =~ "auth failed" ]] || [[ "$line" =~ "wrong password" ]]; then
    play_sound "$WRONG_SOUND"
  fi
done

# Cuando hyprlock termina (desbloqueado exitosamente)
echo "$(date): Hyprlock terminado - desbloqueado" >>"$LOCK_LOG"
play_sound "$UNLOCK_SOUND"

# Limpieza final
cleanup
