#!/bin/bash

# --------------------------------------------------------------
# Proyecto creado por hen-x
# GitHub: https://github.com/hen-x
# --------------------------------------------------------------

# Configuración de rutas
KITTY_CONFIG_DIR="$HOME/.config/kitty"
KITTY_CONFIG_FILE="$KITTY_CONFIG_DIR/kitty.conf"
PYWAL_COLORS_FILE="$HOME/.cache/wal/colors-kitty.conf"
PYWAL_COLORS_SH="$HOME/.cache/wal/colors.sh"

# Crear directorio de kitty si no existe
mkdir -p "$KITTY_CONFIG_DIR"

# Verificar que existan los archivos de pywal
if [ ! -f "$PYWAL_COLORS_FILE" ]; then
  echo "Error: No se encontró el archivo de colores de pywal: $PYWAL_COLORS_FILE"
  echo "Ejecuta pywal primero con: wal -i /path/to/wallpaper"
  exit 1
fi

# Función para generar la configuración completa de kitty
generate_kitty_config() {
  echo "# Configuración de Kitty con colores de pywal"
  echo "# Generada automáticamente el $(date)"
  echo ""

  # Configuración de fuentes
  echo "# === CONFIGURACIÓN DE FUENTES ==="
  echo "font_family JetBrains Mono Nerd Font"
  echo "bold_font JetBrains Mono Nerd Font Bold"
  echo "italic_font JetBrains Mono Nerd Font Italic"
  echo "bold_italic_font JetBrains Mono Nerd Font Bold Italic"
  echo ""
  echo "# Fuente alternativa"
  echo "# font_family Fira Code"
  echo "# bold_font Fira Code Bold"
  echo "# italic_font Fira Code Italic"
  echo ""
  echo "font_size 12.0"
  echo "adjust_line_height 110%"
  echo "adjust_column_width 0"
  echo ""

  # Configuración de símbolos y emojis
  echo "# === SOPORTE PARA SÍMBOLOS Y EMOJIS ==="
  echo "symbol_map U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0B3,U+E0C0-U+E0C7,U+E0CA,U+E0CC-U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6AC,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F32F,U+F400-U+F4A9,U+F500-U+F8FF,U+F0001-U+F1AF0 JetBrains Mono Nerd Font"
  echo ""

  # Configuración de colores (se lee desde pywal)
  echo "# === COLORES DE PYWAL ==="
  cat "$PYWAL_COLORS_FILE"
  echo ""

  # Configuración de ventana
  echo "# === CONFIGURACIÓN DE VENTANA ==="
  echo "window_padding_width 8"
  echo "window_margin_width 0"
  echo "window_border_width 1"
  echo "draw_minimal_borders yes"
  echo "window_logo_path none"
  echo "window_logo_position bottom-right"
  echo "window_logo_alpha 0.5"
  echo "hide_window_decorations no"
  echo "resize_debounce_time 0.1"
  echo "resize_in_steps no"
  echo ""

  # Configuración de tabs
  echo "# === CONFIGURACIÓN DE PESTAÑAS ==="
  echo "tab_bar_edge bottom"
  echo "tab_bar_margin_width 0.0"
  echo "tab_bar_style powerline"
  echo "tab_bar_min_tabs 2"
  echo "tab_switch_strategy previous"
  echo "tab_fade 0.25 0.5 0.75 1"
  echo "tab_separator \" ┇ \""
  echo "tab_activity_symbol none"
  echo "tab_title_template \"{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}\""
  echo "active_tab_title_template none"
  echo ""

  # Configuración de cursor
  echo "# === CONFIGURACIÓN DE CURSOR ==="
  echo "cursor_shape block"
  echo "cursor_beam_thickness 1.5"
  echo "cursor_underline_thickness 2.0"
  echo "cursor_blink_interval -1"
  echo "cursor_stop_blinking_after 15.0"
  echo ""

  # Configuración de scroll
  echo "# === CONFIGURACIÓN DE SCROLL ==="
  echo "scrollback_lines 10000"
  echo "scrollback_pager less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER"
  echo "scrollback_pager_history_size 0"
  echo "wheel_scroll_multiplier 5.0"
  echo "touch_scroll_multiplier 1.0"
  echo ""

  # Configuración de mouse
  echo "# === CONFIGURACIÓN DE MOUSE ==="
  echo "mouse_hide_wait 3.0"
  echo "url_color #0087BD"
  echo "url_style curly"
  echo "open_url_modifiers kitty_mod"
  echo "open_url_with default"
  echo "url_prefixes http https file ftp"
  echo "detect_urls yes"
  echo "copy_on_select no"
  echo "strip_trailing_spaces never"
  echo "rectangle_select_modifiers ctrl+alt"
  echo "terminal_select_modifiers shift"
  echo "select_by_word_characters @-./_~?&=%+#"
  echo "click_interval -1.0"
  echo "focus_follows_mouse no"
  echo "pointer_shape_when_grabbed arrow"
  echo ""

  # Configuración de rendimiento
  echo "# === CONFIGURACIÓN DE RENDIMIENTO ==="
  echo "repaint_delay 10"
  echo "input_delay 3"
  echo "sync_to_monitor yes"
  echo ""

  # Configuración de bell
  echo "# === CONFIGURACIÓN DE BELL ==="
  echo "enable_audio_bell no"
  echo "visual_bell_duration 0.0"
  echo "window_alert_on_bell yes"
  echo "bell_on_tab yes"
  echo "command_on_bell none"
  echo ""

  # Configuración de terminal
  echo "# === CONFIGURACIÓN DE TERMINAL ==="
  echo "remember_window_size yes"
  echo "initial_window_width 640"
  echo "initial_window_height 400"
  echo "enabled_layouts *"
  echo "dynamic_background_opacity no"
  echo "background_opacity 0.95"
  echo "background_image none"
  echo "background_image_layout tiled"
  echo "background_image_linear no"
  echo "background_tint 0.0"
  echo ""

  # Keybindings personalizados
  echo "# === ATAJOS DE TECLADO PERSONALIZADOS ==="
  echo "kitty_mod ctrl+shift"
  echo ""
  echo "# Clipboard"
  echo "map kitty_mod+c copy_to_clipboard"
  echo "map kitty_mod+v paste_from_clipboard"
  echo "map kitty_mod+s paste_from_selection"
  echo "map shift+insert paste_from_selection"
  echo "map kitty_mod+o pass_selection_to_program"
  echo ""
  echo "# Scrolling"
  echo "map kitty_mod+up scroll_line_up"
  echo "map kitty_mod+down scroll_line_down"
  echo "map kitty_mod+k scroll_line_up"
  echo "map kitty_mod+j scroll_line_down"
  echo "map kitty_mod+page_up scroll_page_up"
  echo "map kitty_mod+page_down scroll_page_down"
  echo "map kitty_mod+home scroll_home"
  echo "map kitty_mod+end scroll_end"
  echo "map kitty_mod+h show_scrollback"
  echo ""
  echo "# Window management"
  echo "map kitty_mod+enter new_window"
  echo "map kitty_mod+n new_os_window"
  echo "map kitty_mod+w close_window"
  echo "map kitty_mod+] next_window"
  echo "map kitty_mod+[ previous_window"
  echo "map kitty_mod+f move_window_forward"
  echo "map kitty_mod+b move_window_backward"
  echo "map kitty_mod+\` move_window_to_top"
  echo "map kitty_mod+r start_resizing_window"
  echo "map kitty_mod+1 first_window"
  echo "map kitty_mod+2 second_window"
  echo "map kitty_mod+3 third_window"
  echo "map kitty_mod+4 fourth_window"
  echo "map kitty_mod+5 fifth_window"
  echo "map kitty_mod+6 sixth_window"
  echo "map kitty_mod+7 seventh_window"
  echo "map kitty_mod+8 eighth_window"
  echo "map kitty_mod+9 ninth_window"
  echo "map kitty_mod+0 tenth_window"
  echo ""
  echo "# Tab management"
  echo "map kitty_mod+right next_tab"
  echo "map kitty_mod+left previous_tab"
  echo "map kitty_mod+t new_tab"
  echo "map kitty_mod+q close_tab"
  echo "map kitty_mod+. move_tab_forward"
  echo "map kitty_mod+, move_tab_backward"
  echo "map kitty_mod+alt+t set_tab_title"
  echo ""
  echo "# Layout management"
  echo "map kitty_mod+l next_layout"
  echo ""
  echo "# Font sizes"
  echo "map kitty_mod+equal change_font_size all +2.0"
  echo "map kitty_mod+minus change_font_size all -2.0"
  echo "map kitty_mod+backspace change_font_size all 0"
  echo ""
  echo "# Miscellaneous"
  echo "map kitty_mod+f11 toggle_fullscreen"
  echo "map kitty_mod+f10 toggle_maximized"
  echo "map kitty_mod+u kitten unicode_input"
  echo "map kitty_mod+f2 edit_config_file"
  echo "map kitty_mod+escape kitty_shell window"
  echo "map kitty_mod+a>m set_background_opacity +0.1"
  echo "map kitty_mod+a>l set_background_opacity -0.1"
  echo "map kitty_mod+a>1 set_background_opacity 1"
  echo "map kitty_mod+a>d set_background_opacity default"
  echo "map kitty_mod+delete clear_terminal reset active"
  echo ""

  # Configuración específica para el tema
  echo "# === CONFIGURACIÓN ESPECÍFICA DEL TEMA ==="
  echo "allow_remote_control yes"
  echo "shell_integration enabled"
  echo "term xterm-kitty"
  echo ""
  echo "# Configuración para mejorar la legibilidad"
  echo "text_composition_strategy platform"
  echo "text_fg_override_threshold 0"
  echo ""
  echo "# Configuración para desarrollo"
  echo "close_on_child_death no"
  echo "allow_hyperlinks yes"
  echo "shell_integration no-cursor"
  echo ""
  echo "# Fin de la configuración"
}

# Función principal
main() {
  echo "🎨 Actualizando configuración de Kitty con colores de pywal..."

  # Generar nueva configuración
  generate_kitty_config >"$KITTY_CONFIG_FILE"

  # Notificar a todas las instancias de kitty para que recarguen la configuración
  if command -v kitty &>/dev/null; then
    kitty @ load-config &>/dev/null || true
  fi

  echo "✅ Configuración de Kitty actualizada exitosamente!"
  echo "📁 Archivo de configuración: $KITTY_CONFIG_FILE"
  echo "🎨 Colores aplicados desde: $PYWAL_COLORS_FILE"
  echo ""
  echo "💡 Consejos:"
  echo "   - Reinicia Kitty para aplicar todos los cambios"
  echo "   - Usa Ctrl+Shift+F2 para editar la configuración"
  echo "   - Ejecuta este script cada vez que cambies el wallpaper con pywal"
  echo ""
  echo "🔧 Fuentes configuradas:"
  echo "   - Principal: JetBrains Mono Nerd Font"
  echo "   - Alternativa: Fira Code (comentada)"
  echo "   - Soporte completo para emojis y símbolos"
}

# Ejecutar función principal
main "$@"
