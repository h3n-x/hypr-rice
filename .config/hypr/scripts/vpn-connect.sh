#!/bin/bash
# Script optimizado para ProtonVPN Free
# Países disponibles: JP, NL, US
# Autor: Usuario
# Versión: 2.0

set -euo pipefail

# ==================== CONFIGURACIÓN ====================
readonly VPN_DIR="/home/h3n/VPN"
readonly CREDENTIALS_FILE="$VPN_DIR/Credentials.txt"
readonly AUTH_FILE="/tmp/openvpn_auth"
readonly PID_FILE="/tmp/openvpn.pid"
readonly SERVER_INFO_FILE="/tmp/current_vpn_server"
readonly LOG_FILE="/tmp/vpn-connect.log"
readonly LOCK_FILE="/tmp/vpn-connect.lock"

# Configuración
readonly CONNECTION_TIMEOUT=30
readonly MAX_RETRIES=3
readonly NOTIFICATION_TIMEOUT=5000

# Colores
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

# ==================== FUNCIONES ====================

# Logging mejorado
log() {
  local level="$1"
  shift
  local message="$*"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

  echo "[$timestamp] [$level] $message" >>"$LOG_FILE"

  case "$level" in
  ERROR) print_message "$RED" "❌ $message" ;;
  WARN) print_message "$YELLOW" "⚠️  $message" ;;
  INFO) print_message "$BLUE" "ℹ️  $message" ;;
  SUCCESS) print_message "$GREEN" "✅ $message" ;;
  esac
}

# Mensajes con colores
print_message() {
  local color=$1
  local message=$2
  echo -e "${color}${message}${NC}" >&2
}

# Lock para evitar múltiples instancias
acquire_lock() {
  if ! mkdir "$LOCK_FILE" 2>/dev/null; then
    log "ERROR" "Otra instancia del script ya está ejecutándose"
    exit 1
  fi
  trap 'rm -rf "$LOCK_FILE"' EXIT
}

# Verificar dependencias básicas
check_dependencies() {
  local missing_deps=()
  local deps=("openvpn" "curl" "sudo")

  for dep in "${deps[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      missing_deps+=("$dep")
    fi
  done

  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    log "ERROR" "Dependencias faltantes: ${missing_deps[*]}"
    print_message "$YELLOW" "💡 Instalar con: sudo pacman -S ${missing_deps[*]}"
    exit 1
  fi
}

# Notificaciones simples
send_notification() {
  local title="$1"
  local message="$2"
  local icon="$3"
  local urgency="${4:-normal}"

  if command -v dunstify >/dev/null 2>&1; then
    dunstify -t "$NOTIFICATION_TIMEOUT" -u "$urgency" -i "$icon" "$title" "$message"
  elif command -v notify-send >/dev/null 2>&1; then
    notify-send -t "$NOTIFICATION_TIMEOUT" -u "$urgency" -i "$icon" "$title" "$message"
  fi

  log "INFO" "Notificación: $title - $message"
}

# Seleccionar servidor VPN aleatorio
select_random_vpn() {
  local vpn_files=("$VPN_DIR"/*.protonvpn.tcp.ovpn)

  if [[ ${#vpn_files[@]} -eq 0 || ! -f "${vpn_files[0]}" ]]; then
    log "ERROR" "No se encontraron archivos .protonvpn.tcp.ovpn en $VPN_DIR"
    exit 1
  fi

  local random_index=$((RANDOM % ${#vpn_files[@]}))
  echo "${vpn_files[$random_index]}"
}

# Información del servidor (solo para tus países disponibles)
get_server_info() {
  local ovpn_file=$1
  local filename=$(basename "$ovpn_file" .protonvpn.tcp.ovpn)

  local country=$(echo "$filename" | cut -d'-' -f1)
  local server_num=$(echo "$filename" | cut -d'-' -f3)

  # Solo los países que tienes disponibles
  local country_name
  case "$country" in
  "jp") country_name="🇯🇵 Japón" ;;
  "nl") country_name="🇳🇱 Países Bajos" ;;
  "us") country_name="🇺🇸 Estados Unidos" ;;
  *) country_name="🌍 $country" ;;
  esac

  echo "${country_name} #${server_num}"
}

# Extraer credenciales
extract_credentials() {
  if [[ ! -f "$CREDENTIALS_FILE" ]]; then
    log "ERROR" "No se encontró el archivo de credenciales en $CREDENTIALS_FILE"
    exit 1
  fi

  local user=$(grep "^User=" "$CREDENTIALS_FILE" | cut -d'=' -f2)
  local password=$(grep "^Password=" "$CREDENTIALS_FILE" | cut -d'=' -f2)

  if [[ -z "$user" || -z "$password" ]]; then
    log "ERROR" "No se pudieron extraer las credenciales del archivo"
    exit 1
  fi

  echo "$user" >"$AUTH_FILE"
  echo "$password" >>"$AUTH_FILE"
  chmod 600 "$AUTH_FILE"
}

# Verificar si está conectado
is_connected() {
  if [[ -f "$PID_FILE" ]]; then
    local pid=$(cat "$PID_FILE")
    if ps -p "$pid" >/dev/null 2>&1; then
      # Verificar también interfaz tun
      if ip link show tun0 >/dev/null 2>&1; then
        return 0
      fi
    fi
    # Limpiar archivos obsoletos
    rm -f "$PID_FILE" "$SERVER_INFO_FILE"
  fi
  return 1
}

# Verificar conectividad real
test_connectivity() {
  local test_urls=("https://ifconfig.me" "https://ipinfo.io/ip")

  for url in "${test_urls[@]}"; do
    if curl -s --max-time 10 "$url" >/dev/null 2>&1; then
      return 0
    fi
  done
  return 1
}

# Listar servidores disponibles
list_available_servers() {
  local vpn_files=("$VPN_DIR"/*.protonvpn.tcp.ovpn)

  if [[ ${#vpn_files[@]} -eq 0 || ! -f "${vpn_files[0]}" ]]; then
    print_message "$RED" "No se encontraron servidores VPN disponibles"
    return 1
  fi

  print_message "$CYAN" "🌍 Servidores VPN disponibles (ProtonVPN Free):"
  for file in "${vpn_files[@]}"; do
    local server_info=$(get_server_info "$file")
    print_message "$BLUE" "  • $server_info"
  done
  echo
}

# Conectar a VPN con reintentos
connect_vpn() {
  if is_connected; then
    local current_server=$(cat "$SERVER_INFO_FILE" 2>/dev/null || echo "Servidor desconocido")
    log "WARN" "VPN ya conectada a: $current_server"
    send_notification "VPN ya conectada" "Conectado a: $current_server" "network-vpn" "low"
    return 0
  fi

  print_message "$CYAN" "🔍 Buscando servidores disponibles..."
  list_available_servers

  local retry_count=0
  while [[ $retry_count -lt $MAX_RETRIES ]]; do
    local selected_ovpn=$(select_random_vpn)
    local server_info=$(get_server_info "$selected_ovpn")

    log "INFO" "Intento $((retry_count + 1))/$MAX_RETRIES - Servidor: $server_info"
    print_message "$PURPLE" "🎲 Servidor seleccionado: $server_info"
    print_message "$BLUE" "📡 Conectando..."

    # Verificar archivo
    if [[ ! -f "$selected_ovpn" ]]; then
      log "ERROR" "Archivo no encontrado: $selected_ovpn"
      exit 1
    fi

    # Preparar credenciales
    extract_credentials
    echo "$server_info" >"$SERVER_INFO_FILE"

    # Conectar con timeout
    if timeout "$CONNECTION_TIMEOUT" sudo openvpn \
      --config "$selected_ovpn" \
      --auth-user-pass "$AUTH_FILE" \
      --daemon \
      --writepid "$PID_FILE" \
      --log "/tmp/openvpn.log" \
      --verb 3 \
      --connect-retry 2 \
      --connect-retry-max 3; then

      # Esperar establecimiento de conexión
      sleep 8

      if is_connected && test_connectivity; then
        local external_ip=$(curl -s --max-time 10 ifconfig.me 2>/dev/null || echo 'No disponible')

        log "SUCCESS" "Conectado a $server_info (IP: $external_ip)"
        print_message "$GREEN" "✅ ¡Conectado exitosamente!"
        print_message "$CYAN" "🌐 Servidor: $server_info"
        print_message "$GREEN" "📍 IP externa: $external_ip"

        send_notification "VPN Conectada" "Servidor: $server_info\nIP: $external_ip" "network-vpn"

        # Limpiar credenciales
        rm -f "$AUTH_FILE"
        return 0
      else
        log "WARN" "Conexión fallida, reintentando..."
        disconnect_vpn_force
      fi
    else
      log "WARN" "Timeout en conexión, reintentando..."
    fi

    ((retry_count++))
    [[ $retry_count -lt $MAX_RETRIES ]] && sleep 5
  done

  log "ERROR" "No se pudo conectar después de $MAX_RETRIES intentos"
  print_message "$RED" "❌ Error: No se pudo establecer conexión después de $MAX_RETRIES intentos"
  print_message "$YELLOW" "💡 Revisa el log en /tmp/openvpn.log para más detalles"

  send_notification "Error VPN" "Falló después de $MAX_RETRIES intentos" "network-error" "critical"
  rm -f "$AUTH_FILE" "$SERVER_INFO_FILE"
  exit 1
}

# Desconexión forzada
disconnect_vpn_force() {
  if [[ -f "$PID_FILE" ]]; then
    local pid=$(cat "$PID_FILE")
    sudo kill -9 "$pid" 2>/dev/null || true
    rm -f "$PID_FILE" "$SERVER_INFO_FILE" "$AUTH_FILE"
  fi
}

# Desconectar VPN
disconnect_vpn() {
  if ! is_connected; then
    log "WARN" "VPN no está conectada"
    print_message "$YELLOW" "La VPN no está conectada"
    send_notification "VPN no conectada" "La VPN ya estaba desconectada" "network-offline" "low"
    return 0
  fi

  local current_server=$(cat "$SERVER_INFO_FILE" 2>/dev/null || echo "Servidor desconocido")
  local pid=$(cat "$PID_FILE")

  log "INFO" "Desconectando de: $current_server"
  print_message "$BLUE" "📡 Desconectando de la VPN..."
  print_message "$CYAN" "🌐 Servidor actual: $current_server"

  # Desconexión graceful
  sudo kill "$pid" 2>/dev/null || true

  # Esperar desconexión
  local timeout=10
  while [[ $timeout -gt 0 ]] && ps -p "$pid" >/dev/null 2>&1; do
    sleep 1
    ((timeout--))
  done

  # Forzar si es necesario
  if ps -p "$pid" >/dev/null 2>&1; then
    sudo kill -9 "$pid" 2>/dev/null || true
  fi

  rm -f "$PID_FILE" "$SERVER_INFO_FILE" "$AUTH_FILE"

  log "SUCCESS" "Desconectado de: $current_server"
  print_message "$GREEN" "✅ Desconectado exitosamente"
  send_notification "VPN Desconectada" "Desconectado de: $current_server" "network-offline"
}

# Mostrar estado
show_status() {
  if is_connected; then
    local pid=$(cat "$PID_FILE")
    local current_server=$(cat "$SERVER_INFO_FILE" 2>/dev/null || echo "Servidor desconocido")
    local uptime=$(ps -o etime= -p "$pid" 2>/dev/null | tr -d ' ' || echo "N/A")
    local external_ip=$(curl -s --max-time 10 ifconfig.me 2>/dev/null || echo 'No disponible')

    print_message "$GREEN" "✅ VPN Conectada"
    print_message "$CYAN" "🌐 Servidor: $current_server"
    print_message "$BLUE" "🕐 Tiempo activo: $uptime"
    print_message "$GREEN" "📍 IP externa: $external_ip"
    print_message "$YELLOW" "🔧 PID: $pid"

    # Verificar conectividad
    if test_connectivity; then
      print_message "$GREEN" "🌐 Conectividad: OK"
    else
      print_message "$RED" "⚠️  Conectividad: Problemas detectados"
    fi
  else
    print_message "$RED" "❌ VPN no conectada"
    local current_ip=$(curl -s --max-time 10 ifconfig.me 2>/dev/null || echo 'No disponible')
    print_message "$BLUE" "📍 IP actual: $current_ip"
  fi
}

# Rotar logs si es muy grande
rotate_logs() {
  if [[ -f "$LOG_FILE" ]] && [[ $(stat -c%s "$LOG_FILE" 2>/dev/null || echo 0) -gt 1048576 ]]; then
    mv "$LOG_FILE" "${LOG_FILE}.old"
    log "INFO" "Log rotado"
  fi
}

# Ayuda
show_help() {
  cat <<EOF
🔧 ProtonVPN Free Connect Script v2.0

📋 Uso: $0 [COMANDO]

🚀 Comandos disponibles:
  connect, c      🚀 Conectar a la VPN (selección aleatoria)
  disconnect, d   🛑 Desconectar de la VPN
  status, s       📊 Mostrar estado de la VPN
  list, l         📝 Listar servidores disponibles
  restart, r      🔄 Reiniciar conexión VPN
  logs            📋 Ver últimas líneas del log
  help            ❓ Mostrar esta ayuda

💡 Si no se especifica comando, se ejecutará 'connect'

🌍 Países disponibles (ProtonVPN Free):
  🇯🇵 Japón, 🇳🇱 Países Bajos, 🇺🇸 Estados Unidos

🎲 El script selecciona automáticamente un servidor aleatorio
   de los archivos disponibles en: $VPN_DIR

📁 Archivos:
  Configuraciones: $VPN_DIR/*.protonvpn.tcp.ovpn
  Credenciales:    $CREDENTIALS_FILE
  Log:             $LOG_FILE
EOF
}

# Función principal
main() {
  acquire_lock
  check_dependencies
  rotate_logs

  local command=${1:-connect}

  case "$command" in
  connect | c)
    connect_vpn
    ;;
  disconnect | d)
    disconnect_vpn
    ;;
  status | s)
    show_status
    ;;
  list | l)
    list_available_servers
    ;;
  restart | r)
    print_message "$YELLOW" "🔄 Reiniciando conexión VPN..."
    disconnect_vpn
    sleep 3
    connect_vpn
    ;;
  logs)
    if [[ -f "$LOG_FILE" ]]; then
      tail -20 "$LOG_FILE"
    else
      print_message "$YELLOW" "No hay logs disponibles"
    fi
    ;;
  help | --help | -h)
    show_help
    ;;
  *)
    log "ERROR" "Comando desconocido: $command"
    print_message "$RED" "❌ Error: Comando desconocido '$command'"
    show_help
    exit 1
    ;;
  esac
}

# Manejo de señales
trap 'log "INFO" "Script interrumpido por usuario"; exit 130' INT TERM

# Ejecutar
main "$@"
