#!/bin/bash

# Script de confirmación para wlogout
MESSAGE="$1"
COMMAND="$2"

# Crear las opciones como elementos separados
CHOICE=$(rofi -dmenu -p "$MESSAGE" \
  -theme ~/.config/rofi/rofi-confirmation.rasi \
  -format 's' \
  -no-custom \
  -markup-rows \
  <<<$'Yes\nNo')

if [ "$CHOICE" = "Yes" ]; then
  eval "$COMMAND"
fi
