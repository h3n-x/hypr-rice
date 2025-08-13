#!/bin/bash

# --------------------------------------------------------------
# Proyecto creado por hen-x
# GitHub: https://github.com/hen-x
# --------------------------------------------------------------

# Función para esperar a que Hyprland esté listo
wait_for_hyprland() {
  while ! hyprctl monitors >/dev/null 2>&1; do
    sleep 0.1
  done
  sleep 1 # Esperar un poco más para asegurar que todo esté listo
}

# Función para configurar temperatura de pantalla
setup_display_temperature() {
  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl hyprsunset temperature 2800
  else
    echo "❌ hyprctl no encontrado"
  fi
}

# Función principal
main() {
  # Esperar a que Hyprland esté listo
  wait_for_hyprland

  # Configurar temperatura de pantalla
  setup_display_temperature

}

# Ejecutar función principal
main "$@"
