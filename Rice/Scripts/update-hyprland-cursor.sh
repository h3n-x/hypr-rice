#!/bin/bash

# --------------------------------------------------------------
# Proyecto creado por hen-x
# GitHub: https://github.com/hen-x
# --------------------------------------------------------------

# Configuración de rutas
BIBATA_CURSOR_DIR="$HOME/Rice/Bibata_Cursor"
HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland.conf"
PYWAL_COLORS_SCSS="$HOME/.cache/wal/colors.scss"
PYWAL_COLORS_SH="$HOME/.cache/wal/colors.sh"
CURSOR_NAME="Bibata-Wal"

# Función para mostrar mensajes con colores
print_status() {
  echo "🎨 $1"
}

print_success() {
  echo "✅ $1"
}

print_error() {
  echo "❌ $1"
}

print_warning() {
  echo "⚠️  $1"
}

print_info() {
  echo "💡 $1"
}

# Función para verificar dependencias
check_dependencies() {
  print_status "Verificando dependencias..."

  local missing_deps=()

  # Verificar cbmp
  if ! command -v cbmp &>/dev/null; then
    missing_deps+=("cbmp (cursor-builder)")
  fi

  # Verificar ctgen
  if ! command -v ctgen &>/dev/null; then
    missing_deps+=("ctgen (cursor-toolbox)")
  fi

  # Verificar npx
  if ! command -v npx &>/dev/null; then
    missing_deps+=("npx (Node.js)")
  fi

  # Verificar archivos de pywal
  if [ ! -f "$PYWAL_COLORS_SCSS" ]; then
    missing_deps+=("pywal colors (ejecuta: wal -i /path/to/wallpaper)")
  fi

  # Verificar directorio de cursor
  if [ ! -d "$BIBATA_CURSOR_DIR" ]; then
    missing_deps+=("directorio Bibata_Cursor en $BIBATA_CURSOR_DIR")
  fi

  # Verificar archivos requeridos en el directorio
  if [ -d "$BIBATA_CURSOR_DIR" ]; then
    if [ ! -d "$BIBATA_CURSOR_DIR/svg/modern" ]; then
      missing_deps+=("directorio svg/modern en $BIBATA_CURSOR_DIR")
    fi
    if [ ! -f "$BIBATA_CURSOR_DIR/build.toml" ]; then
      missing_deps+=("archivo build.toml en $BIBATA_CURSOR_DIR")
    fi
  fi

  if [ ${#missing_deps[@]} -gt 0 ]; then
    print_error "Dependencias faltantes:"
    for dep in "${missing_deps[@]}"; do
      echo "   - $dep"
    done
    echo ""
    print_info "Instalación de dependencias:"
    echo "   - cbmp: npm install -g cbmp"
    echo "   - ctgen: cargo install ctgen o desde AUR: paru -S cursor-toolbox"
    echo "   - Bibata cursors: git clone https://github.com/ful1e5/Bibata_Cursor.git"
    echo "   - pywal: ejecuta 'wal -i /path/to/wallpaper' para generar colores"
    return 1
  fi

  print_success "Todas las dependencias están presentes"
  return 0
}

# Función para leer colores desde el archivo SCSS de pywal
read_pywal_colors() {
  print_status "Leyendo colores de pywal desde $PYWAL_COLORS_SCSS..."

  # Verificar que el archivo existe
  if [ ! -f "$PYWAL_COLORS_SCSS" ]; then
    print_error "No se encontró el archivo de colores SCSS de pywal"
    return 1
  fi

  # Leer colores usando grep y sed para extraer valores hexadecimales
  local background=$(grep '^\$background:' "$PYWAL_COLORS_SCSS" | sed 's/^\$background: *\(#[^;]*\);/\1/')
  local foreground=$(grep '^\$foreground:' "$PYWAL_COLORS_SCSS" | sed 's/^\$foreground: *\(#[^;]*\);/\1/')
  local cursor=$(grep '^\$cursor:' "$PYWAL_COLORS_SCSS" | sed 's/^\$cursor: *\(#[^;]*\);/\1/')
  local color1=$(grep '^\$color1:' "$PYWAL_COLORS_SCSS" | sed 's/^\$color1: *\(#[^;]*\);/\1/')
  local color2=$(grep '^\$color2:' "$PYWAL_COLORS_SCSS" | sed 's/^\$color2: *\(#[^;]*\);/\1/')

  # Validar que los colores se leyeron correctamente
  if [ -z "$color1" ] || [ -z "$color2" ] || [ -z "$cursor" ]; then
    print_error "No se pudieron leer algunos colores del archivo SCSS"
    print_info "Contenido del archivo:"
    head -20 "$PYWAL_COLORS_SCSS"
    return 1
  fi

  # Asignar colores a variables globales
  BORDER_COLOR="$color1"
  OUTLINE_COLOR="$color2"
  WATCH_COLOR="$cursor"

  print_success "Colores leídos exitosamente:"
  echo "   - Border Color (color1): $BORDER_COLOR"
  echo "   - Outline Color (color2): $OUTLINE_COLOR"
  echo "   - Watch Color (cursor): $WATCH_COLOR"

  return 0
}

# Función para generar el cursor con los nuevos colores
generate_cursor() {
  print_status "Generando cursor personalizado con colores de pywal..."

  # Cambiar al directorio de trabajo
  cd "$BIBATA_CURSOR_DIR" || {
    print_error "No se pudo acceder al directorio $BIBATA_CURSOR_DIR"
    return 1
  }

  print_status "Ejecutando cbmp para generar bitmaps..."

  # Limpiar directorio de salida anterior si existe
  if [ -d "bitmaps/$CURSOR_NAME" ]; then
    print_info "Limpiando bitmaps anteriores..."
    rm -rf "bitmaps/$CURSOR_NAME"
  fi

  # Limpiar TODOS los directorios de instalación anteriores
  print_info "Limpiando instalaciones anteriores del cursor..."

  # Limpiar directorio en ~/.local/share/icons/
  if [ -d "$HOME/.local/share/icons/$CURSOR_NAME" ]; then
    rm -rf "$HOME/.local/share/icons/$CURSOR_NAME"
    print_info "Eliminado: ~/.local/share/icons/$CURSOR_NAME"
  fi

  # Limpiar directorio en ~/.icons/
  if [ -d "$HOME/.icons/$CURSOR_NAME" ]; then
    rm -rf "$HOME/.icons/$CURSOR_NAME"
    print_info "Eliminado: ~/.icons/$CURSOR_NAME"
  fi

  # Limpiar cualquier directorio temporal que pueda existir
  if [ -d "/tmp/$CURSOR_NAME" ]; then
    rm -rf "/tmp/$CURSOR_NAME"
    print_info "Eliminado: /tmp/$CURSOR_NAME"
  fi

  # Ejecutar cbmp con los colores de pywal
  if npx cbmp -d 'svg/modern' -o "bitmaps/$CURSOR_NAME" -bc "$BORDER_COLOR" -oc "$OUTLINE_COLOR" -wc "$WATCH_COLOR"; then
    print_success "Bitmaps generados exitosamente"
  else
    print_error "Falló la generación de bitmaps"
    return 1
  fi

  print_status "Ejecutando ctgen para construir el cursor..."

  # Ejecutar ctgen para construir el cursor
  if ctgen build.toml -d "bitmaps/$CURSOR_NAME" -n "$CURSOR_NAME" -c "Bibata cursores con colores de pywal."; then
    print_success "Cursor generado exitosamente"
  else
    print_error "Falló la construcción del cursor"
    print_info "Intentando limpieza más profunda y reintentar..."

    # Limpieza más agresiva de todos los posibles directorios
    rm -rf "$HOME/.local/share/icons/$CURSOR_NAME" 2>/dev/null || true
    rm -rf "$HOME/.icons/$CURSOR_NAME" 2>/dev/null || true
    rm -rf "/tmp/$CURSOR_NAME" 2>/dev/null || true

    # Limpiar archivos temporales en el directorio de bitmaps
    find "bitmaps/$CURSOR_NAME" -name "*.cursor" -delete 2>/dev/null || true

    # Limpiar cualquier enlace simbólico roto
    find "$HOME/.local/share/icons/" -name "$CURSOR_NAME" -type l -delete 2>/dev/null || true
    find "$HOME/.icons/" -name "$CURSOR_NAME" -type l -delete 2>/dev/null || true

    # Reintentar la construcción
    print_status "Reintentando construcción del cursor..."
    if ctgen build.toml -d "bitmaps/$CURSOR_NAME" -n "$CURSOR_NAME" -c "Bibata cursores con colores de pywal."; then
      print_success "Cursor generado exitosamente en el segundo intento"
    else
      print_error "Falló la construcción del cursor en el segundo intento"
      print_info "Puedes intentar manualmente:"
      print_info "1. rm -rf ~/.local/share/icons/$CURSOR_NAME"
      print_info "2. rm -rf ~/.icons/$CURSOR_NAME"
      print_info "3. rm -rf bitmaps/$CURSOR_NAME"
      print_info "4. Ejecutar el script nuevamente"
      return 1
    fi
  fi

  # Verificar que el cursor se generó correctamente
  local cursor_installed=false
  if [ -d "$HOME/.local/share/icons/$CURSOR_NAME" ]; then
    print_success "Cursor instalado en: ~/.local/share/icons/$CURSOR_NAME"
    cursor_installed=true
  fi
  if [ -d "$HOME/.icons/$CURSOR_NAME" ]; then
    print_success "Cursor instalado en: ~/.icons/$CURSOR_NAME"
    cursor_installed=true
  fi

  if [ "$cursor_installed" = false ]; then
    print_warning "El cursor podría no haberse instalado correctamente"
    print_info "Verificando directorios de instalación..."
    ls -la "$HOME/.local/share/icons/" | grep -i bibata || print_info "No se encontró en ~/.local/share/icons/"
    ls -la "$HOME/.icons/" 2>/dev/null | grep -i bibata || print_info "No se encontró en ~/.icons/"
  else
    print_success "Cursor instalado correctamente"
  fi

  return 0
}

# Función para actualizar la configuración de Hyprland
update_hyprland_config() {
  print_status "Actualizando configuración de Hyprland..."

  # Verificar que el archivo de configuración existe
  if [ ! -f "$HYPRLAND_CONFIG" ]; then
    print_error "No se encontró el archivo de configuración de Hyprland: $HYPRLAND_CONFIG"
    return 1
  fi

  # Buscar y actualizar la línea del cursor
  if grep -q "env = XCURSOR_THEME," "$HYPRLAND_CONFIG"; then
    # Actualizar línea existente
    sed -i "s/^env = XCURSOR_THEME,.*/env = XCURSOR_THEME,$CURSOR_NAME/" "$HYPRLAND_CONFIG"
    print_success "Configuración de cursor actualizada en Hyprland"
  else
    # Buscar la sección de cursor y agregar si no existe
    if grep -q "# Cursor" "$HYPRLAND_CONFIG"; then
      # Insertar después del comentario de cursor
      sed -i "/# Cursor/a env = XCURSOR_THEME,$CURSOR_NAME" "$HYPRLAND_CONFIG"
      print_success "Configuración de cursor agregada a Hyprland"
    else
      # Agregar al final del archivo
      echo -e "\n# Cursor" >>"$HYPRLAND_CONFIG"
      echo "env = XCURSOR_THEME,$CURSOR_NAME" >>"$HYPRLAND_CONFIG"
      echo "env = XCURSOR_SIZE,24" >>"$HYPRLAND_CONFIG"
      echo "env = HYPRCURSOR_SIZE,24" >>"$HYPRLAND_CONFIG"
      print_success "Sección de cursor agregada a Hyprland"
    fi
  fi

  # Verificar que los cambios se aplicaron
  if grep -q "env = XCURSOR_THEME,$CURSOR_NAME" "$HYPRLAND_CONFIG"; then
    print_success "Configuración verificada exitosamente"
  else
    print_error "Error al verificar la configuración"
    return 1
  fi

  return 0
}

# Función para recargar el cursor en Hyprland
reload_cursor() {
  print_status "Recargando cursor en Hyprland..."

  # Verificar que estamos en Hyprland
  if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    # Recargar la configuración de Hyprland
    if command -v hyprctl &>/dev/null; then
      hyprctl reload || print_warning "No se pudo recargar la configuración de Hyprland"

      # También actualizar las variables de entorno
      hyprctl setenv XCURSOR_THEME "$CURSOR_NAME" || true
      hyprctl setenv XCURSOR_SIZE 24 || true
      hyprctl setenv HYPRCURSOR_SIZE 24 || true

      print_success "Configuración de Hyprland recargada"
    else
      print_warning "hyprctl no encontrado, reinicia Hyprland manualmente"
    fi
  else
    print_warning "No se detectó Hyprland, reinicia manualmente para aplicar cambios"
  fi
}

# Función para mostrar información final
show_final_info() {
  echo ""
  echo "🎉 ¡Actualización de cursor de Hyprland completada exitosamente!"
  echo ""
  echo "📋 Resumen de cambios:"
  echo "   - Cursor generado: $CURSOR_NAME"
  echo "   - Colores aplicados:"
  echo "     • Border: $BORDER_COLOR"
  echo "     • Outline: $OUTLINE_COLOR"
  echo "     • Watch: $WATCH_COLOR"
  echo "   - Configuración actualizada: $HYPRLAND_CONFIG"
  echo ""
  echo "🔄 Para aplicar completamente los cambios:"
  echo "   1. Reinicia las aplicaciones que usan cursor"
  echo "   2. O reinicia Hyprland completamente"
  echo "   3. Verifica con: echo \$XCURSOR_THEME"
  echo ""
  echo "💡 Comandos útiles:"
  echo "   - Ver cursor actual: hyprctl getoption cursor:no_hardware_cursors"
  echo "   - Listar cursores: ls ~/.local/share/icons/"
  echo "   - Reejecutar script: $0"
  echo ""
  echo "🎨 Wallpaper actual: $(grep 'wallpaper:' "$PYWAL_COLORS_SCSS" 2>/dev/null | sed 's/.*"\(.*\)".*/\1/' || echo 'No encontrado')"
  echo "📅 Generado: $(date)"
}

# Función para crear un script de automatización
create_automation_script() {
  local auto_script="$HOME/.local/bin/update-cursor-pywal"

  print_status "Creando script de automatización..."

  # Crear directorio si no existe
  mkdir -p "$(dirname "$auto_script")"

  # Crear script de automatización
  cat >"$auto_script" <<'EOF'
#!/bin/bash
# Script de automatización para actualizar cursor con pywal
# Se ejecuta automáticamente cuando cambias el wallpaper

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_SCRIPT="$(find "$HOME" -name "update-hyprland-cursor.sh" -type f | head -1)"

if [ -f "$MAIN_SCRIPT" ]; then
    echo "🔄 Actualizando cursor automáticamente..."
    bash "$MAIN_SCRIPT"
else
    echo "❌ No se encontró el script principal de actualización de cursor"
    exit 1
fi
EOF

  chmod +x "$auto_script"
  print_success "Script de automatización creado: $auto_script"

  # Crear hook para pywal si es posible
  local pywal_hook="$HOME/.config/wal/templates/update-cursor.sh"
  mkdir -p "$(dirname "$pywal_hook")"

  cat >"$pywal_hook" <<EOF
#!/bin/bash
# Hook automático para pywal - actualiza cursor cuando cambias wallpaper
# Este archivo se ejecuta automáticamente cuando ejecutas 'wal -i imagen'

# Esperar un poco para que pywal termine de generar los archivos
sleep 2

# Ejecutar actualización de cursor
if [ -f "$auto_script" ]; then
    bash "$auto_script" &
fi
EOF

  chmod +x "$pywal_hook"
  print_success "Hook de pywal creado: $pywal_hook"

  print_info "Automatización configurada. El cursor se actualizará automáticamente cuando cambies el wallpaper con pywal."
}

# Función principal
main() {
  echo "🎨 Script de actualización de cursor de Hyprland con colores de pywal"
  echo "=================================================================="
  echo ""

  # Verificar dependencias
  if ! check_dependencies; then
    exit 1
  fi

  # Leer colores de pywal
  if ! read_pywal_colors; then
    exit 1
  fi

  # Generar cursor personalizado
  if ! generate_cursor; then
    exit 1
  fi

  # Actualizar configuración de Hyprland
  if ! update_hyprland_config; then
    exit 1
  fi

  # Recargar cursor en Hyprland
  reload_cursor

  # Crear automatización
  create_automation_script

  # Mostrar información final
  show_final_info
}

# Función de ayuda
show_help() {
  echo "Script de actualización de cursor de Hyprland con colores de pywal"
  echo ""
  echo "Uso: $0 [opciones]"
  echo ""
  echo "Opciones:"
  echo "  -h, --help     Mostrar esta ayuda"
  echo "  -c, --check    Solo verificar dependencias"
  echo "  -d, --dry-run  Ejecutar sin hacer cambios reales"
  echo ""
  echo "Descripción:"
  echo "  Este script automatiza la generación de un cursor personalizado"
  echo "  usando los colores de pywal y actualiza la configuración de Hyprland."
  echo ""
  echo "Dependencias:"
  echo "  - cbmp (npm install -g cbmp)"
  echo "  - ctgen (cargo install ctgen)"
  echo "  - pywal (python-pywal)"
  echo "  - Bibata_Cursor repository en ~/Rice/Bibata_Cursor"
  echo ""
  echo "Archivos modificados:"
  echo "  - ~/.config/hypr/hyprland.conf"
  echo "  - ~/.local/share/icons/$CURSOR_NAME/"
  echo ""
}

# Manejo de argumentos de línea de comandos
case "${1:-}" in
  -h | --help)
    show_help
    exit 0
    ;;
  -c | --check)
    check_dependencies
    exit $?
    ;;
  -d | --dry-run)
    echo "🧪 Modo dry-run: verificando sin hacer cambios..."
    check_dependencies && read_pywal_colors
    echo "✅ Verificación completada. Ejecuta sin -d para aplicar cambios."
    exit 0
    ;;
  "")
    main
    ;;
  *)
    echo "❌ Opción desconocida: $1"
    echo "Usa $0 --help para ver las opciones disponibles."
    exit 1
    ;;
esac
