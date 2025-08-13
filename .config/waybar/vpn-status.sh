#!/bin/bash
# Script corregido para mostrar estado de VPN en Waybar
# Maneja correctamente el escape de caracteres para JSON válido

readonly PID_FILE="/tmp/openvpn.pid"
readonly SERVER_INFO_FILE="/tmp/current_vpn_server"

# Función para escapar JSON correctamente
json_escape() {
  local input="$1"
  # Escapar caracteres especiales para JSON
  echo "$input" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\t/\\t/g; s/\r/\\r/g; s/\n/\\n/g'
}

# Función para verificar si está conectado
is_connected() {
  if [[ -f "$PID_FILE" ]]; then
    local pid=$(cat "$PID_FILE")
    if ps -p "$pid" >/dev/null 2>&1; then
      # Verificar también interfaz tun
      if ip link show tun0 >/dev/null 2>&1; then
        return 0
      fi
    fi
  fi
  return 1
}

# Obtener información del servidor
get_server_display_name() {
  local server_info="$1"
  # Extraer solo el país y número para display compacto
  if [[ "$server_info" =~ 🇯🇵.*#([0-9]+) ]]; then
    echo " JP#${BASH_REMATCH[1]}"
  elif [[ "$server_info" =~ 🇳🇱.*#([0-9]+) ]]; then
    echo " NL#${BASH_REMATCH[1]}"
  elif [[ "$server_info" =~ 🇺🇸.*#([0-9]+) ]]; then
    echo " US#${BASH_REMATCH[1]}"
  else
    echo " "
  fi
}

# Obtener IP externa con timeout más corto
get_external_ip() {
  curl -s --max-time 3 --connect-timeout 2 ifconfig.me 2>/dev/null || echo "N/A"
}

# Generar JSON válido para Waybar
generate_json() {
  local text="$1"
  local class="$2"
  local tooltip="$3"

  # Escapar todas las variables
  local escaped_text=$(json_escape "$text")
  local escaped_class=$(json_escape "$class")
  local escaped_tooltip=$(json_escape "$tooltip")

  # Usar printf para generar JSON más seguro
  printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' \
    "$escaped_text" "$escaped_class" "$escaped_tooltip"
}

# Lógica principal
if is_connected; then
  server_info=$(cat "$SERVER_INFO_FILE" 2>/dev/null || echo "Servidor desconocido")
  display_name=$(get_server_display_name "$server_info")
  external_ip=$(get_external_ip)
  pid=$(cat "$PID_FILE")
  uptime=$(ps -o etime= -p "$pid" 2>/dev/null | tr -d ' ' || echo "N/A")

  # Crear tooltip sin caracteres problemáticos
  tooltip="Servidor: $server_info - IP: $external_ip - Tiempo: $uptime"

  generate_json "$display_name" "connected" "$tooltip"
else
  external_ip=$(get_external_ip)
  tooltip="VPN Desconectada - IP local: $external_ip"

  generate_json " Unsecure" "disconnected" "$tooltip"
fi
