#!/bin/bash
# Servicio de monitoreo para eventos de hyprlock
# Alternativa más robusta para detectar eventos

SOUND_DIR="/home/h3n/Rice/Notifications"
UNLOCK_SOUND="$SOUND_DIR/unlock.wav"
WRONG_SOUND="$SOUND_DIR/wrong.wav"

play_sound() {
  local sound_file="$1"
  if [ -f "$sound_file" ]; then
    if command -v paplay >/dev/null 2>&1; then
      paplay "$sound_file" &
    elif command -v aplay >/dev/null 2>&1; then
      aplay "$sound_file" &
    elif command -v ffplay >/dev/null 2>&1; then
      ffplay -nodisp -autoexit "$sound_file" >/dev/null 2>&1 &
    fi
  fi
}

# Monitorear proceso de hyprlock
monitor_hyprlock() {
  while true; do
    # Esperar a que hyprlock inicie
    while ! pgrep -x hyprlock >/dev/null; do
      sleep 0.5
    done

    echo "$(date): Hyprlock detectado activo"

    # Esperar a que hyprlock termine
    while pgrep -x hyprlock >/dev/null; do
      sleep 0.5
    done

    # Verificar si hubo fallo reciente antes de reproducir desbloqueo
    if [ -f "/tmp/hyprlock_monitor_fail" ]; then
      LAST_FAIL=$(cat "/tmp/hyprlock_monitor_fail")
      CURRENT_TIME=$(date +%s)
      TIME_DIFF=$((CURRENT_TIME - LAST_FAIL))

      # Si el último fallo fue hace más de 2 segundos, es desbloqueo exitoso
      if [ $TIME_DIFF -gt 2 ]; then
        echo "$(date): Hyprlock terminado exitosamente - reproduciendo sonido de desbloqueo"
        play_sound "$UNLOCK_SOUND"
      else
        echo "$(date): Hyprlock terminado después de fallo reciente - omitiendo sonido de desbloqueo"
      fi
      rm -f "/tmp/hyprlock_monitor_fail"
    else
      echo "$(date): Hyprlock terminado exitosamente - reproduciendo sonido de desbloqueo"
      play_sound "$UNLOCK_SOUND"
    fi

    # Pequeña pausa antes de monitorear de nuevo
    sleep 2
  done
}

# Monitorear logs de autenticación para errores
monitor_auth_failures() {
  journalctl -f _COMM=hyprlock 2>/dev/null | while read -r line; do
    if [[ "$line" =~ "pam_unix" ]] && [[ "$line" =~ "authentication failure" ]]; then
      # Solo reproducir si hyprlock sigue activo
      if pgrep -x hyprlock >/dev/null 2>&1; then
        echo "$(date): Fallo de autenticación detectado"
        play_sound "$WRONG_SOUND"
        # Marcar timestamp del fallo
        echo "$(date +%s)" >"/tmp/hyprlock_monitor_fail"
        sleep 0.5 # Evitar sonidos duplicados
      fi
    fi
  done &
}

# Función para limpiar procesos al terminar
cleanup() {
  jobs -p | xargs -r kill
}

trap cleanup EXIT

echo "🔊 Iniciando monitor de sonidos para hyprlock..."
echo "Sonidos configurados en: $SOUND_DIR"

# Iniciar monitoreo de ambos tipos de eventos
monitor_auth_failures
monitor_hyprlock
