#!/bin/bash
# Ejecutar Hyprlock para bloquear
hyprlock &
# Esperar un momento para asegurarse de que la pantalla de bloqueo se haya mostrado
sleep 4
# Capturar la pantalla usando grim
grim /home/h3n/lock.png
