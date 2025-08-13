#!/bin/bash

# Script para lanzar Waybar con configuración vertical

# Matar procesos waybar existentes
killall -q waybar

# Esperar a que terminen
while pgrep -x waybar >/dev/null; do sleep 1; done

# Lanzar waybar
waybar -c /home/h3n/.config/waybar/config.json -s /home/h3n/.config/waybar/style.css &

echo "Waybar launched..."
