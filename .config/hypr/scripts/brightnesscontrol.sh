#!/usr/bin/env bash

# ============================================================================
# Enhanced Brightness Control System
# Funcionalidades: Control inteligente, perfiles, filtro azul, recordatorios
# ============================================================================

# Configuración
CONFIG_DIR="$HOME/.config/brightness-control"
PROFILES_FILE="$CONFIG_DIR/profiles.conf"
LOG_FILE="$CONFIG_DIR/brightness.log"
SCHEDULE_FILE="$CONFIG_DIR/schedule.conf"
ICON_PATH="$HOME/.config/hypr/scripts/icons"

# Crear directorio de configuración
mkdir -p "$CONFIG_DIR"

# Obtener información de brillo
get_brightness_info() {
    local brightness=$(brightnessctl get)
    local max_brightness=$(brightnessctl max)
    local percentage=$(((brightness * 100) / max_brightness))
    local device=$(brightnessctl info | awk -F"'" '/Device/ {print $2}')
    
    echo "$percentage|$brightness|$max_brightness|$device"
}

# Obtener icono según nivel de brillo
get_brightness_icon() {
    local brightness=$1
    
    if [ "$brightness" -le 10 ]; then
        echo "$ICON_PATH/brightness-low.png"
    elif [ "$brightness" -le 30 ]; then
        echo "$ICON_PATH/brightness-medium-low.png"
    elif [ "$brightness" -le 60 ]; then
        echo "$ICON_PATH/brightness-medium.png"
    elif [ "$brightness" -le 80 ]; then
        echo "$ICON_PATH/brightness-medium-high.png"
    else
        echo "$ICON_PATH/brightness-high.png"
    fi
}

# Generar consejos de brillo
get_brightness_tip() {
    local brightness=$1
    local hour=$(date +%H)
    
    local tips=(
        "💡 Ajusta el brillo según la luz ambiente"
        "👁️ Usa la regla 20-20-20: cada 20 min, mira 20 seg a 20 pies"
        "🌙 Reduce el brillo por la noche para mejor sueño"
        "☀️ Aumenta el brillo en ambientes muy iluminados"
        "🔋 Menor brillo = mayor duración de batería"
        "🖥️ Calibra tu monitor regularmente"
        "😴 Usa filtro azul después de las 6 PM"
        "⚡ El brillo automático ahorra energía"
        "🎯 El brillo óptimo es 50-70% en condiciones normales"
        "🌡️ El brillo alto genera más calor"
    )
    
    if [ "$hour" -ge 20 ] || [ "$hour" -le 6 ]; then
        if [ "$brightness" -gt 50 ]; then
            echo "🌙 Es de noche, considera reducir el brillo para cuidar tus ojos"
        else
            echo "😴 Perfecto para horario nocturno - considera activar filtro azul"
        fi
    elif [ "$hour" -ge 6 ] && [ "$hour" -le 10 ]; then
        echo "🌅 Buenos días! Ajusta el brillo gradualmente para despertar mejor"
    elif [ "$brightness" -lt 20 ]; then
        echo "⚠️ Brillo muy bajo - puede causar fatiga visual"
    elif [ "$brightness" -gt 90 ]; then
        echo "⚠️ Brillo muy alto - puede cansar los ojos y gastar batería"
    else
        echo "${tips[$((RANDOM % ${#tips[@]}))]}"
    fi
}

# Registrar cambios de brillo
log_brightness_change() {
    local brightness=$1
    local action=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] Brightness: $brightness% ($action)" >> "$LOG_FILE"
}

# Enviar notificación
send_notification() {
    local info=$(get_brightness_info)
    IFS='|' read -r percentage brightness max_brightness device <<< "$info"
    
    local icon=$(get_brightness_icon "$percentage")
    local tip=$(get_brightness_tip "$percentage")
    
    # Crear barra visual
    local bar_length=20
    local filled=$((percentage * bar_length / 100))
    local empty=$((bar_length - filled))
    local bar="$(printf '█%.0s' $(seq 1 $filled))$(printf '░%.0s' $(seq 1 $empty))"
    
    # Información adicional
    local details="Dispositivo: $device\nNivel: $brightness/$max_brightness"
    
    # Enviar notificación
    dunstify $ncolor "Brillo" \
        -i "$icon" \
        -u normal \
        -r 91190 \
        -t 2000 \
        "$percentage% [$bar]\n$details\n\n💡 $tip"
}

# Ajustar brillo con validación
set_brightness() {
    local target=$1
    local action=$2
    
    # Validar rango
    if [ "$target" -lt 1 ]; then
        target=1
    elif [ "$target" -gt 100 ]; then
        target=100
    fi
    
    # Aplicar cambio
    brightnessctl set "${target}%"
    
    # Registrar y notificar
    log_brightness_change "$target" "$action"
    send_notification
}

# Perfiles de brillo predefinidos
load_profiles() {
    if [ ! -f "$PROFILES_FILE" ]; then
        cat > "$PROFILES_FILE" << EOF
# Perfiles de brillo predefinidos
# Formato: NOMBRE:PORCENTAJE:DESCRIPCION

morning:70:Brillo matutino suave
work:60:Brillo óptimo para trabajo
evening:40:Brillo vespertino relajante
night:15:Brillo nocturno mínimo
presentation:90:Brillo alto para presentaciones
reading:45:Brillo cómodo para lectura
gaming:80:Brillo alto para gaming
battery_save:25:Brillo bajo para ahorrar batería
outdoor:100:Brillo máximo para exteriores
EOF
    fi
}

# Aplicar perfil
apply_profile() {
    local profile_name=$1
    load_profiles
    
    local profile_line=$(grep "^$profile_name:" "$PROFILES_FILE")
    if [ -z "$profile_line" ]; then
        echo "❌ Perfil '$profile_name' no encontrado"
        list_profiles
        return 1
    fi
    
    local brightness=$(echo "$profile_line" | cut -d':' -f2)
    local description=$(echo "$profile_line" | cut -d':' -f3)
    
    set_brightness "$brightness" "profile:$profile_name"
    
    dunstify  "Perfil Aplicado" \
        -i "$(get_brightness_icon $brightness)" \
        -u low \
        -r 91195 \
        -t 3000 \
        "📋 $profile_name\n$description\nBrillo: $brightness%"
}

# Listar perfiles disponibles
list_profiles() {
    load_profiles
    
    echo "📋 Perfiles de Brillo Disponibles:"
    echo "================================="
    
    while IFS=':' read -r name brightness description; do
        if [[ ! "$name" =~ ^# ]]; then
            printf "  %-15s %3s%% - %s\n" "$name" "$brightness" "$description"
        fi
    done < "$PROFILES_FILE"
}

# Brillo automático basado en hora
auto_brightness() {
    local hour=$(date +%H)
    local profile=""
    
    if [ "$hour" -ge 6 ] && [ "$hour" -lt 9 ]; then
        profile="morning"
    elif [ "$hour" -ge 9 ] && [ "$hour" -lt 18 ]; then
        profile="work"
    elif [ "$hour" -ge 18 ] && [ "$hour" -lt 22 ]; then
        profile="evening"
    else
        profile="night"
    fi
    
    apply_profile "$profile"
    echo "🤖 Brillo automático aplicado: $profile"
}

# Programar cambios automáticos
schedule_brightness() {
    if [ ! -f "$SCHEDULE_FILE" ]; then
        cat > "$SCHEDULE_FILE" << EOF
# Programación automática de brillo
# Formato: HORA:PERFIL
# Ejemplo: 08:00:morning

06:00:morning
09:00:work
18:00:evening
22:00:night
EOF
        echo "📅 Archivo de programación creado: $SCHEDULE_FILE"
        echo "Edítalo para personalizar los horarios"
        return
    fi
    
    echo "⏰ Iniciando programación automática de brillo..."
    
    while true; do
        local current_time=$(date +%H:%M)
        
        while IFS=':' read -r hour minute profile; do
            local schedule_time="$hour:$minute"
            if [[ ! "$schedule_time" =~ ^# ]] && [ "$current_time" == "$schedule_time" ]; then
                apply_profile "$profile"
                echo "⏰ Cambio programado ejecutado: $profile a las $schedule_time"
            fi
        done < "$SCHEDULE_FILE"
        
        sleep 60  # Verificar cada minuto
    done
}

# Control de filtro azul (requiere redshift o similar)
blue_light_filter() {
    local action=$1
    
    case "$action" in
        "on"|"enable")
            if command -v redshift >/dev/null 2>&1; then
                redshift -O 3000 >/dev/null 2>&1
                dunstify "Filtro Azul" \
                    -i "$ICON_PATH/blue-filter.png" \
                    -u low \
                    -r 91196 \
                    -t 2000 \
                    "🔵 Filtro azul activado\nTemperatura: 3000K"
            else
                echo "❌ redshift no está instalado"
            fi
            ;;
        "off"|"disable")
            if command -v redshift >/dev/null 2>&1; then
                redshift -x >/dev/null 2>&1
                dunstify  "Filtro Azul" \
                    -i "$ICON_PATH/blue-filter-off.png" \
                    -u low \
                    -r 91196 \
                    -t 2000 \
                    "🔵 Filtro azul desactivado"
            fi
            ;;
        "auto")
            if command -v redshift >/dev/null 2>&1; then
                redshift -l 0:0 -t 6500:3000 >/dev/null 2>&1 &
                echo "🔵 Filtro azul automático iniciado"
            fi
            ;;
    esac
}

# Función principal
main() {
    case "${1:-help}" in
        "i"|"increase"|"up")
            local current=$(get_brightness_info | cut -d'|' -f1)
            local new_brightness=$((current + 5))
            set_brightness "$new_brightness" "increase"
            ;;
        "d"|"decrease"|"down")
            local current=$(get_brightness_info | cut -d'|' -f1)
            local new_brightness=$((current - 5))
            if [ "$new_brightness" -lt 5 ]; then
                new_brightness=1
            fi
            set_brightness "$new_brightness" "decrease"
            ;;
        "set")
            if [ -z "$2" ]; then
                echo "❌ Especifica un valor de brillo (1-100)"
                exit 1
            fi
            set_brightness "$2" "manual"
            ;;
        "profile"|"p")
            if [ -z "$2" ]; then
                list_profiles
            else
                apply_profile "$2"
            fi
            ;;
        "auto")
            auto_brightness
            ;;
        "schedule")
            schedule_brightness
            ;;
        "blue"|"filter")
            blue_light_filter "${2:-auto}"
            ;;
        "status"|"s")
            send_notification
            ;;
        "help"|"h"|"-h"|"--help")
            echo "💡 Enhanced Brightness Control System"
            echo "====================================="
            echo ""
            echo "Uso: $0 [comando] [parámetros]"
            echo ""
            echo "Comandos básicos:"
            echo "  i, increase, up    - Aumentar brillo +5%"
            echo "  d, decrease, down  - Disminuir brillo -5%"
            echo "  set <valor>        - Establecer brillo específico (1-100)"
            echo "  status, s          - Mostrar estado actual"
            echo ""
            echo "Perfiles:"
            echo "  profile, p         - Listar perfiles disponibles"
            echo "  profile <nombre>   - Aplicar perfil específico"
            echo "  auto               - Brillo automático según hora"
            echo ""
            echo "Programación:"
            echo "  schedule           - Iniciar programación automática"
            echo ""
            echo "Filtro azul:"
            echo "  blue on/off/auto   - Control de filtro de luz azul"
            echo ""
            echo "Características:"
            echo "  • Control inteligente con validación"
            echo "  • Perfiles predefinidos personalizables"
            echo "  • Programación automática por horarios"
            echo "  • Filtro de luz azul integrado"
            echo "  • Consejos contextuales"
            echo "  • Registro de cambios"
            echo "  • Notificaciones visuales mejoradas"
            ;;
        *)
            echo "❌ Comando desconocido: $1"
            echo "Usa '$0 help' para ver los comandos disponibles"
            exit 1
            ;;
    esac
}

# Ejecutar función principal
main "$@"