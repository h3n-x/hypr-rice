#!/bin/bash
# Script para toggle VPN desde Waybar

readonly VPN_SCRIPT="/home/h3n/.config/hypr/scripts/vpn-connect.sh" # Ajusta la ruta a tu script
readonly PID_FILE="/tmp/openvpn.pid"

# Verificar si está conectado
is_connected() {
  if [[ -f "$PID_FILE" ]]; then
    local pid=$(cat "$PID_FILE")
    if ps -p "$pid" >/dev/null 2>&1; then
      if ip link show tun0 >/dev/null 2>&1; then
        return 0
      fi
    fi
  fi
  return 1
}

# Toggle VPN
if is_connected; then
  # Desconectar
  "$VPN_SCRIPT" disconnect
else
  # Conectar
  "$VPN_SCRIPT" connect
fi

# Actualizar Waybar
pkill -SIGRTMIN+8 waybar
