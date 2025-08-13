#!/bin/bash

# Script para recargar SwayNC cuando cambien los colores de pywal

# Función para recargar SwayNC
reload_swaync() {
  echo "Recargando SwayNC..."

  # Recargar CSS
  swaync-client --reload-css

  # Recargar configuración
  swaync-client --reload-config

  echo "SwayNC recargado exitosamente"
}

# Verificar si SwayNC está ejecutándose
if pgrep -x "swaync" >/dev/null; then
  reload_swaync
else
  echo "SwayNC no está ejecutándose. Iniciando..."
  swaync &
  sleep 2
  reload_swaync
fi
