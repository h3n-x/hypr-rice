#!/bin/bash
# Menú contextual para VPN en Waybar usando rofi (Versión mejorada)

# Configurar variables de entorno
export PATH="/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:$PATH"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

# Rutas absolutas
readonly VPN_SCRIPT="/home/h3n/.config/hypr/scripts/vpn-connect.sh"
readonly ROFI_CONFIG="/home/h3n/.config/rofi/config.rasi"
readonly LOG_FILE="/tmp/vpn-menu.log"

# Función de logging
log_msg() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >>"$LOG_FILE"
}

# Verificar que rofi esté disponible
if ! command -v rofi &>/dev/null; then
  log_msg "ERROR: rofi no encontrado en PATH"
  notify-send "Error VPN" "rofi no está disponible" -u critical
  exit 1
fi

# Verificar que el script VPN existe
if [[ ! -x "$VPN_SCRIPT" ]]; then
  log_msg "ERROR: Script VPN no encontrado o no ejecutable: $VPN_SCRIPT"
  notify-send "Error VPN" "Script VPN no disponible" -u critical
  exit 1
fi

log_msg "Iniciando menú VPN desde: $0"

# Opciones del menú
options=" Conectar VPN
 Desconectar VPN
 Reiniciar VPN"

# Función para ejecutar acción VPN
execute_vpn_action() {
  local action="$1"
  log_msg "Ejecutando acción VPN: $action"

  # Ejecutar en background para no bloquear Waybar
  nohup bash -c "
        '$VPN_SCRIPT' '$action'
        # Actualizar Waybar después de la acción
        pkill -SIGRTMIN+8 waybar
    " >>"$LOG_FILE" 2>&1 &
}

# Mostrar menú con rofi (ejecutar en background si viene de Waybar)
if [[ "$PPID" != "1" ]] && pstree -p "$PPID" | grep -q "waybar"; then
  # Ejecutado desde Waybar - usar background
  log_msg "Detectado origen: Waybar - ejecutando en background"

  nohup bash -c '
        selected=$(echo -e "'"$options"'" | rofi -dmenu -i -p "VPN Options" -theme "'"$ROFI_CONFIG"'")
        
        case "$selected" in
        " Conectar VPN")
            "'"$VPN_SCRIPT"'" c
            ;;
        " Desconectar VPN")
            "'"$VPN_SCRIPT"'" d
            ;;
        " Reiniciar VPN")
            "'"$VPN_SCRIPT"'" r
            ;;
        esac
        
        # Actualizar Waybar
        pkill -SIGRTMIN+8 waybar
    ' >>"$LOG_FILE" 2>&1 &

else
  # Ejecutado desde terminal - ejecución normal
  log_msg "Detectado origen: Terminal - ejecución normal"

  selected=$(echo -e "$options" | rofi -dmenu -i -p "VPN Options" -theme "$ROFI_CONFIG")

  case "$selected" in
  " Conectar VPN")
    execute_vpn_action "c"
    ;;
  " Desconectar VPN")
    execute_vpn_action "d"
    ;;
  " Reiniciar VPN")
    execute_vpn_action "r"
    ;;
  *)
    log_msg "Ninguna opción seleccionada o cancelado"
    ;;
  esac
fi

log_msg "Menú VPN completado"
