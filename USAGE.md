# 🚀 Guía de Uso Diario y Mantenimiento

> **Manual práctico para el uso cotidiano del sistema de rice Hyprland + Arch Linux**

## 📋 Índice

- [⚡ Comandos Esenciales](#-comandos-esenciales)
- [🎨 Gestión de Temas y Wallpapers](#-gestión-de-temas-y-wallpapers)
- [🖱️ Gestión del Cursor](#️-gestión-del-cursor)
- [📱 Gestión de Aplicaciones](#-gestión-de-aplicaciones)
- [🔒 Sistema de Bloqueo](#-sistema-de-bloqueo)
- [🔧 Mantenimiento del Sistema](#-mantenimiento-del-sistema)
- [🚑 Solución de Problemas Comunes](#-solución-de-problemas-comunes)
- [⚙️ Personalización Avanzada](#️-personalización-avanzada)
- [📚 Workflows Recomendados](#-workflows-recomendados)

## ⚡ Comandos Esenciales

### 🎯 **Accesos Rápidos (Keybinds)**

| Atajo | Acción | Descripción |
|-------|--------|-------------|
| `Super + L` | `hyprlock` | Bloquear pantalla |
| `Super + Shift + E` | `wlogout` | Menú de logout |
| `Super + W` | Cambiar wallpaper | Wallpaper aleatorio + actualizar tema |
| `Super + Q` | `kitty` | Abrir terminal |
| `Super + R` | `rofi` | Launcher de aplicaciones |
| `Super + C` | Cerrar ventana | Cerrar ventana activa |

### 📋 **Aliases Útiles (después de cargar rice-aliases.sh)**

```bash
# Cargar aliases (agregar a ~/.zshrc o ~/.bashrc)
source ~/Rice/Scripts/rice-aliases.sh

# Comandos disponibles:
rice-random         # Wallpaper aleatorio + actualizar todo
rice-wall imagen.png # Aplicar wallpaper específico
rice-cursor          # Actualizar cursor con colores actuales
rice-status          # Verificar estado del sistema
rice-colors          # Ver colores actuales de pywal
```

### 🔧 **Comandos Básicos de Mantenimiento**

```bash
# Verificar estado general
cd ~/Rice/Scripts/
./verify-dependencies.sh

# Actualizar todos los componentes
./update-all-colors.sh

# Recargar Hyprland
hyprctl reload

# Verificar logs
journalctl --user -u hyprland -f
```

## 🎨 Gestión de Temas y Wallpapers

### 🖼️ **Cambiar Wallpaper y Tema Completo**

#### **Wallpaper aleatorio:**
```bash
# Opción 1: Con keybind
Super + W

# Opción 2: Desde terminal
wal -i ~/Rice/Wallpapers/ --random

# Opción 3: Con alias
rice-random
```

#### **Wallpaper específico:**
```bash
# Aplicar wallpaper específico
wal -i ~/Rice/Wallpapers/imagen_001.png

# O con alias
rice-wall ~/Rice/Wallpapers/imagen_001.png
```

#### **Actualizar todos los componentes manualmente:**
```bash
cd ~/Rice/Scripts/
./update-all-colors.sh
```

### 🎨 **Gestión de la Colección de Wallpapers**

#### **Agregar nuevos wallpapers:**
```bash
# Copiar nuevos wallpapers
cp /ruta/a/nuevos/wallpapers/* ~/Rice/Wallpapers/

# Verificar que se agregaron
ls ~/Rice/Wallpapers/ | wc -l
```

#### **Organizar wallpapers:**
```bash
# Crear subcategorías (opcional)
mkdir -p ~/Rice/Wallpapers/{nature,abstract,cyberpunk,minimal}

# Mover wallpapers a categorías
mv ~/Rice/Wallpapers/imagen_001.png ~/Rice/Wallpapers/nature/

# Aplicar desde subcategoría
wal -i ~/Rice/Wallpapers/nature/ --random
```

#### **Limpiar wallpapers antiguos:**
```bash
# Listar wallpapers por tamaño
ls -lah ~/Rice/Wallpapers/ | sort -k5 -hr

# Eliminar wallpapers específicos
rm ~/Rice/Wallpapers/imagen_viejo.png

# Backup antes de limpiar
cp -r ~/Rice/Wallpapers/ ~/Rice/Wallpapers_backup/
```

### 🎨 **Ver Información del Tema Actual**

```bash
# Ver colores actuales
rice-colors

# O directamente
cat ~/.cache/wal/colors.sh

# Ver wallpaper actual
echo "Wallpaper: $(grep wallpaper ~/.cache/wal/colors.sh | cut -d'"' -f2)"

# Ver esquema de colores
wal --theme
```

### 🎯 **Aplicar Tema a Aplicación Específica**

```bash
# Solo Spotify
cd ~/Rice/Scripts/
./update-spicetify-colors.sh

# Solo Kitty
./update-kitty-colors.sh

# Solo Firefox
./update-firefox-all.sh

# Solo cursor
./update-hyprland-cursor.sh

# Solo hyprlock
./update_hyprlock_colors.sh
```

## 🖱️ Gestión del Cursor

### 🎨 **Actualizar Cursor con Colores Actuales**

```bash
# Método rápido con alias
rice-cursor

# Método completo
cd ~/Rice/Scripts/
./update-hyprland-cursor.sh
```

### 🔍 **Verificar Estado del Cursor**

```bash
# Ver cursor actual
echo "Tema cursor: $XCURSOR_THEME"
echo "Tamaño cursor: $XCURSOR_SIZE"

# Verificar instalación
ls ~/.local/share/icons/ | grep Bibata

# Verificar dependencias
cd ~/Rice/Scripts/
./update-hyprland-cursor.sh --check
```

### 🛠️ **Solucionar Problemas de Cursor**

```bash
# Regenerar cursor desde cero
cd ~/Rice/Scripts/
rm -rf ~/.local/share/icons/Bibata-Wal
./update-hyprland-cursor.sh

# Verificar herramientas
which cbmp
which ctgen

# Reinstalar herramientas si es necesario
npm install -g cbmp
cargo install ctgen
```

### ⚙️ **Personalizar Cursor Manualmente**

```bash
# Editar configuración de construcción
nano ~/Rice/Bibata_Cursor/build.toml

# Cambiar colores manualmente en el script
nano ~/Rice/Scripts/update-hyprland-cursor.sh

# Regenerar después de cambios
./update-hyprland-cursor.sh
```

## 📱 Gestión de Aplicaciones

### 💻 **Terminal Kitty**

#### **Comandos de gestión:**
```bash
# Actualizar colores
cd ~/Rice/Scripts/
./update-kitty-colors.sh

# Recargar configuración (en kitty running)
kitty @ load-config

# Editar configuración
nano ~/.config/kitty/kitty.conf

# Verificar configuración
kitty --debug-config
```

#### **Personalización rápida:**
```bash
# Cambiar opacidad temporalmente
kitty @ set-background-opacity 0.8

# Cambiar fuente temporalmente
kitty @ set-font-size 14

# Restablecer configuración
kitty @ load-config
```

### 🎵 **Spotify (Spicetify)**

#### **Gestión del tema:**
```bash
# Actualizar tema con colores actuales
cd ~/Rice/Scripts/
./update-spicetify-colors.sh

# O con aliases (después de cargar spicetify-aliases.sh)
source ~/.config/spicetify/Themes/pywal/spicetify-aliases.sh
spicetify-update

# Aplicar tema manualmente
spicetify apply

# Ver estado
spicetify-status
```

#### **Personalización CSS:**
```bash
# Editar CSS personalizado
spicetify-edit css

# O directamente
nano ~/.config/spicetify/Themes/pywal/user.css

# Aplicar cambios
spicetify apply
```

#### **Solucionar problemas:**
```bash
# Restaurar Spotify
spicetify restore

# Verificar permisos
sudo chmod a+wr /opt/spotify /opt/spotify/Apps -R

# Reconfigurar desde cero
spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
spicetify backup apply
```

### 🌐 **Firefox**

#### **Actualizar todos los CSS:**
```bash
cd ~/Rice/Scripts/
./update-firefox-all.sh
```

#### **Actualizar componente específico:**
```bash
# Solo colores principales
./update-firefox-colors.sh

# Solo TabCenter Reborn
./update-tabcenter-colors.sh

# Solo Side View
./update-sideview-colors.sh
```

#### **Verificar configuración:**
```bash
# Verificar userChrome habilitado
# Firefox → about:config → toolkit.legacyUserProfileCustomizations.stylesheets → true

# Verificar archivos CSS
ls ~/.mozilla/firefox/*/chrome/includes/

# Ver backups disponibles
ls ~/.mozilla/firefox/*/chrome/includes/backup/
```

#### **Restaurar desde backup:**
```bash
# Listar backups disponibles
ls ~/.mozilla/firefox/*/chrome/includes/backup/

# Restaurar archivo específico
cp ~/.mozilla/firefox/*/chrome/includes/backup/cascade-colours.css.bak.20231215123456 \
   ~/.mozilla/firefox/*/chrome/includes/cascade-colours.css
```

### 🔔 **Notificaciones (Dunst)**

#### **Gestión básica:**
```bash
# Actualizar configuración
cd ~/Rice/Scripts/
./update-dunst-colors.sh

# Recargar Dunst
killall dunst && dunst &

# Test de notificación
notify-send "Test" "Notificación de prueba"
notify-send -u critical "Crítico" "Notificación crítica"
```

#### **Configuración avanzada:**
```bash
# Editar configuración
nano ~/.config/dunst/dunstrc

# Ver configuración actual
dunst --debug

# Verificar reglas
dunst --print
```

### 🚪 **Wlogout**

#### **Uso básico:**
```bash
# Abrir menú logout
Super + Shift + E

# O desde terminal
wlogout

# Con configuración específica
~/.config/wlogout/launch-wlogout.sh
```

#### **Personalización:**
```bash
# Actualizar colores
cd ~/Rice/Scripts/
./update-wlogout-colors.sh

# Editar layout
nano ~/.config/wlogout/layout

# Editar CSS
nano ~/.config/wlogout/style.css

# Cargar aliases
source ~/.config/wlogout/wlogout-aliases.sh
```

## 🔒 Sistema de Bloqueo

### 🎯 **Uso Diario**

```bash
# Bloquear pantalla
Super + L

# O desde terminal
hyprlock

# Bloqueo con captura (para testing)
~/Rice/Scripts/lockscreen.sh
```

### 🔧 **Gestión del Sistema Matrix**

#### **Actualizar configuración:**
```bash
# Actualizar solo colores
cd ~/Rice/Scripts/
./update_hyprlock_colors.sh

# Regenerar configuración completa
./generate_matrix_hyprlock.sh

# Setup completo (solo primera vez)
./setup_hyprlock.sh
```

#### **Verificar funcionamiento:**
```bash
# Test del reloj de palabras
~/.config/hypr/scripts/word_clock_matrix.sh

# Ver configuración actual
cat ~/.config/hypr/hyprlock.conf

# Verificar avatar
ls -la ~/.face
```

#### **Personalizar reloj:**
```bash
# Editar script del reloj
nano ~/.config/hypr/scripts/word_clock_matrix.sh

# Probar cambios
~/.config/hypr/scripts/word_clock_matrix.sh

# Regenerar configuración
cd ~/Rice/Scripts/
./generate_matrix_hyprlock.sh
```

### 👤 **Gestión del Avatar**

```bash
# Verificar avatar actual
~/Rice/Scripts/check-user-avatar.sh

# Cambiar avatar
cp /ruta/a/nueva/foto.jpg ~/.face

# Verificar nueva imagen
file ~/.face
identify ~/.face  # Si tienes ImageMagick

# Probar en hyprlock
hyprlock
```

## 🔧 Mantenimiento del Sistema

### 🧪 **Verificaciones Rutinarias**

#### **Verificación semanal:**
```bash
# Verificar estado general
cd ~/Rice/Scripts/
./verify-dependencies.sh

# Verificar servicios
systemctl --user status pipewire
systemctl --user status wireplumber

# Verificar Hyprland
hyprctl version
hyprctl monitors
```

#### **Verificación de archivos:**
```bash
# Verificar configuraciones importantes
ls -la ~/.config/hypr/hyprland.conf
ls -la ~/.config/hypr/hyprlock.conf
ls -la ~/.cache/wal/colors.sh

# Verificar scripts ejecutables
ls -la ~/Rice/Scripts/*.sh | grep -v "x"

# Hacer ejecutables si es necesario
chmod +x ~/Rice/Scripts/*.sh
```

### 🧹 **Limpieza del Sistema**

#### **Limpiar archivos temporales:**
```bash
# Limpiar bitmaps de cursor antiguos
cd ~/Rice/Bibata_Cursor/
rm -rf bitmaps/Bibata-Wal-*

# Limpiar backups antiguos de Firefox (mayor a 30 días)
find ~/.mozilla/firefox/*/chrome/includes/backup/ -name "*.bak.*" -mtime +30 -delete

# Limpiar archivos de pywal antiguos
rm -rf ~/.cache/wal.old
```

#### **Optimizar configuraciones:**
```bash
# Regenerar todas las configuraciones desde cero
cd ~/Rice/Scripts/
wal -i ~/Rice/Wallpapers/imagen_001.png
./update-all-colors.sh

# Limpiar logs antiguos
journalctl --user --vacuum-time=7d
```

### 🔄 **Actualización de Componentes**

#### **Actualizar dependencias:**
```bash
# Actualizar sistema base
sudo pacman -Syu

# Actualizar paquetes AUR
paru -Syu

# Actualizar herramientas de cursor
npm update -g cbmp
cargo install ctgen --force
```

#### **Actualizar tema después de cambios del sistema:**
```bash
# Después de actualizar Hyprland
hyprctl reload
cd ~/Rice/Scripts/
./update-hyprland-config.sh

# Después de actualizar Spotify
spicetify backup apply
./update-spicetify-colors.sh

# Después de actualizar Firefox
./update-firefox-all.sh
```

### 📊 **Monitoreo del Sistema**

#### **Verificar rendimiento:**
```bash
# Uso de memoria por aplicaciones de rice
ps aux | grep -E "(hyprland|dunst|kitty|spotify)" | awk '{print $1, $2, $4, $11}'

# Espacio usado por wallpapers
du -sh ~/Rice/Wallpapers/

# Espacio usado por cursores
du -sh ~/.local/share/icons/Bibata*

# Estado de audio
pactl info
pactl list sinks short
```

#### **Logs importantes:**
```bash
# Logs de Hyprland
journalctl --user -u hyprland -n 50

# Logs de PipeWire
journalctl --user -u pipewire -n 50

# Logs del sistema
sudo journalctl -n 50
```

## 🚑 Solución de Problemas Comunes

### ❌ **Problemas Frecuentes y Soluciones**

#### **🎨 Pywal no genera colores**
```bash
# Verificar instalación
wal --version

# Reinstalar pywal
pip install --user pywal

# Verificar permisos
ls -la ~/.cache/wal/

# Regenerar colores
wal -i ~/Rice/Wallpapers/imagen_001.png

# Verificar resultado
cat ~/.cache/wal/colors.sh
```

#### **🖱️ Cursor no se aplica**
```bash
# Verificar variables de entorno
echo $XCURSOR_THEME
echo $XCURSOR_SIZE

# Verificar instalación
ls ~/.local/share/icons/ | grep Bibata

# Regenerar cursor
cd ~/Rice/Scripts/
rm -rf ~/.local/share/icons/Bibata-Wal
./update-hyprland-cursor.sh

# Forzar recarga
hyprctl reload
```

#### **🔒 Hyprlock no funciona**
```bash
# Verificar configuración
cat ~/.config/hypr/hyprlock.conf

# Verificar permisos
chmod +x ~/.config/hypr/scripts/word_clock_matrix.sh

# Test de componentes
~/.config/hypr/scripts/word_clock_matrix.sh

# Regenerar configuración
cd ~/Rice/Scripts/
./setup_hyprlock.sh
```

#### **🎵 Spotify/Spicetify no funciona**
```bash
# Verificar permisos
sudo chmod a+wr /opt/spotify /opt/spotify/Apps -R

# Restaurar y reconfigurar
spicetify restore
spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
spicetify backup apply

# Aplicar tema
cd ~/Rice/Scripts/
./update-spicetify-colors.sh
```

#### **🌐 Firefox CSS no se aplica**
```bash
# Verificar configuración
firefox about:config
# Buscar: toolkit.legacyUserProfileCustomizations.stylesheets
# Debe estar en: true

# Verificar archivos
ls ~/.mozilla/firefox/*/chrome/includes/

# Restaurar desde backup si es necesario
cp ~/.mozilla/firefox/*/chrome/includes/backup/cascade-colours.css.bak.* \
   ~/.mozilla/firefox/*/chrome/includes/cascade-colours.css

# Regenerar CSS
cd ~/Rice/Scripts/
./update-firefox-all.sh

# Reiniciar Firefox completamente
killall firefox
firefox
```

#### **🔊 Audio no funciona**
```bash
# Verificar PipeWire
systemctl --user status pipewire
systemctl --user status pipewire-pulse
systemctl --user status wireplumber

# Reiniciar servicios
systemctl --user restart pipewire
systemctl --user restart pipewire-pulse
systemctl --user restart wireplumber

# Verificar funcionamiento
pactl info
pactl list sinks short
```

### 🔧 **Comandos de Diagnóstico Rápido**

```bash
# Script de diagnóstico completo
cd ~/Rice/Scripts/
./diagnose.sh  # Si lo has creado según la documentación

# O verificación manual rápida
echo "=== DIAGNÓSTICO RÁPIDO ==="
echo "Hyprland: $(hyprctl version 2>/dev/null | head -1)"
echo "Pywal: $(wal --version 2>/dev/null)"
echo "Cursor: $XCURSOR_THEME ($XCURSOR_SIZE)"
echo "Audio: $(pactl info 2>/dev/null | grep "Server Name")"
echo "Spotify: $(spicetify -v 2>/dev/null)"
echo "Avatar: $([ -f ~/.face ] && echo "✅" || echo "❌")"
echo "Scripts: $(ls ~/Rice/Scripts/*.sh 2>/dev/null | wc -l) archivos"
```

## ⚙️ Personalización Avanzada

### 🎨 **Personalizar Esquemas de Color**

#### **Crear paletas personalizadas:**
```bash
# Generar paleta desde color específico
wal --theme base16-default-dark

# Usar imagen con configuración específica
wal -i ~/Rice/Wallpapers/imagen_001.png --saturate 0.8

# Guardar esquema personalizado
wal --theme > ~/.config/wal/colorschemes/mi-esquema.json
```

#### **Modificar generación de colores:**
```bash
# Editar configuración de pywal
nano ~/.config/wal/templates/colors.sh

# Usar backend específico
wal -i imagen.png --backend colorz
wal -i imagen.png --backend wal
wal -i imagen.png --backend colorthief
```

### 🖱️ **Personalizar Cursor**

#### **Modificar configuración de construcción:**
```bash
# Editar build.toml
nano ~/Rice/Bibata_Cursor/build.toml

# Cambiar tamaños de cursor
# x11_sizes = [16, 20, 24, 28, 32, 40, 48, 56, 64]

# Cambiar directorio de salida
# out_dir = '/home/h3n/.icons/'
```

#### **Crear variantes de cursor:**
```bash
# Editar script de generación
nano ~/Rice/Scripts/update-hyprland-cursor.sh

# Modificar mapeo de colores:
# BORDER_COLOR="$color1"    # Cambiar a $color2
# OUTLINE_COLOR="$color2"   # Cambiar a $color3
# WATCH_COLOR="$cursor"     # Cambiar a $color4
```

### 🔒 **Personalizar Sistema de Bloqueo**

#### **Modificar diseño del reloj:**
```bash
# Editar script del reloj
nano ~/.config/hypr/scripts/word_clock_matrix.sh

# Cambiar matriz de palabras (líneas 38-50)
# Cambiar lógica de tiempo (líneas 110-152)
# Cambiar colores de resaltado
```

#### **Personalizar efectos visuales:**
```bash
# Editar configuración de hyprlock
nano ~/.config/hypr/hyprlock.conf

# Modificar efectos de blur:
# blur_passes = 4  # Número de pasadas
# blur_size = 10   # Tamaño de blur

# Modificar posiciones:
# position = 0, 290  # Imagen usuario
# position = 0, 0    # Reloj
# position = 0, -250 # Campo contraseña
```

### 📱 **Personalizar Aplicaciones**

#### **Kitty personalizado:**
```bash
# Editar generador de configuración
nano ~/Rice/Scripts/update-kitty-colors.sh

# Cambiar fuente:
# echo "font_family JetBrains Mono Nerd Font"  # Cambiar fuente
# echo "font_size 12.0"                        # Cambiar tamaño

# Cambiar opacidad:
# echo "background_opacity 0.95"               # Cambiar transparencia
```

#### **Spicetify personalizado:**
```bash
# Editar CSS personalizado
nano ~/.config/spicetify/Themes/pywal/user.css

# Agregar nuevos efectos:
/* Nuevos gradientes */
.Button--style-green {
    background: linear-gradient(45deg, var(--pywal-color1), var(--pywal-color4)) !important;
}

/* Animaciones personalizadas */
@keyframes mi-animacion {
    0% { transform: scale(1); }
    50% { transform: scale(1.1); }
    100% { transform: scale(1); }
}

.Card:hover {
    animation: mi-animacion 0.5s ease-in-out !important;
}
```

### 🎯 **Crear Scripts Personalizados**

#### **Script para cambio automático de wallpaper:**
```bash
# Crear script de cambio automático
cat > ~/Rice/Scripts/auto-wallpaper.sh << 'EOF'
#!/bin/bash
# Cambio automático de wallpaper cada X minutos

WALLPAPER_DIR="$HOME/Rice/Wallpapers"
INTERVAL=1800  # 30 minutos en segundos

while true; do
    # Cambiar wallpaper aleatorio
    wal -i "$WALLPAPER_DIR" --random
    
    # Actualizar todos los componentes
    cd ~/Rice/Scripts/
    ./update-all-colors.sh
    
    # Esperar intervalo
    sleep $INTERVAL
done
EOF

chmod +x ~/Rice/Scripts/auto-wallpaper.sh

# Ejecutar en background
nohup ~/Rice/Scripts/auto-wallpaper.sh &
```

#### **Script para backup automático:**
```bash
# Crear script de backup
cat > ~/Rice/Scripts/backup-configs.sh << 'EOF'
#!/bin/bash
# Backup automático de configuraciones

BACKUP_DIR="$HOME/Rice/Backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup configuraciones importantes
cp -r ~/.config/hypr "$BACKUP_DIR/"
cp -r ~/.config/kitty "$BACKUP_DIR/"
cp -r ~/.config/dunst "$BACKUP_DIR/"
cp -r ~/.config/wlogout "$BACKUP_DIR/"
cp -r ~/.mozilla/firefox/*/chrome "$BACKUP_DIR/"
cp ~/.face "$BACKUP_DIR/" 2>/dev/null || true

echo "✅ Backup creado en: $BACKUP_DIR"
EOF

chmod +x ~/Rice/Scripts/backup-configs.sh
```

## 📚 Workflows Recomendados

### 🌅 **Rutina Matutina**

```bash
# 1. Cambiar tema para empezar el día
rice-random

# 2. Verificar estado del sistema
rice-status

# 3. Abrir aplicaciones principales
Super + Q  # Terminal
Super + R  # Rofi para buscar apps
```

### 🎨 **Cambio de Tema Semanal**

```bash
# 1. Backup actual
cd ~/Rice/Scripts/
./backup-configs.sh

# 2. Explorar nuevos wallpapers
ls ~/Rice/Wallpapers/ | shuf | head -10

# 3. Probar diferentes temas
for img in $(ls ~/Rice/Wallpapers/*.png | shuf | head -5); do
    echo "Probando: $img"
    wal -i "$img"
    sleep 5
done

# 4. Seleccionar favorito y aplicar completo
wal -i ~/Rice/Wallpapers/imagen_favorita.png
./update-all-colors.sh
```

### 🔧 **Mantenimiento Mensual**

```bash
# 1. Actualizar sistema
sudo pacman -Syu
paru -Syu

# 2. Limpiar archivos temporales
find ~/Rice/Bibata_Cursor/bitmaps -name "Bibata-Wal-*" -mtime +7 -delete
find ~/.mozilla/firefox/*/chrome/includes/backup/ -name "*.bak.*" -mtime +30 -delete

# 3. Verificar y regenerar configuraciones
cd ~/Rice/Scripts/
./verify-dependencies.sh
./update-all-colors.sh

# 4. Backup completo
./backup-configs.sh

# 5. Verificar funcionamiento
hyprlock  # Test lock screen
notify-send "Test" "Sistema funcionando correctamente"
```

### 🎯 **Desarrollo y Testing**

```bash
# 1. Crear rama de desarrollo
cp -r ~/Rice ~/Rice_dev

# 2. Modificar scripts en desarrollo
cd ~/Rice_dev/Scripts/
# Editar scripts...

# 3. Probar cambios
./update-all-colors.sh

# 4. Si funciona, aplicar a producción
cp ~/Rice_dev/Scripts/*.sh ~/Rice/Scripts/

# 5. Si no funciona, restaurar
rm -rf ~/Rice_dev/
```

### 📱 **Setup Nuevo Dispositivo**

```bash
# 1. Clonar configuración
git clone https://github.com/tu-usuario/tu-rice.git ~/Rice

# 2. Ejecutar instalación
cd ~/Rice/
chmod +x Scripts/*.sh
./INSTALLATION.md  # Seguir guía

# 3. Configurar avatar
cp /ruta/a/foto.jpg ~/.face

# 4. Aplicar primer tema
wal -i ~/Rice/Wallpapers/imagen_001.png
cd Scripts/
./update-all-colors.sh

# 5. Verificar funcionamiento
./verify-dependencies.sh
```

## 🎯 **Consejos Pro**

### ⚡ **Optimización de Rendimiento**

```bash
# Reducir frecuencia de actualización del reloj matrix
# Editar ~/.config/hypr/hyprlock.conf
# Cambiar: text = cmd[update:500]
# Por: text = cmd[update:1000]  # Actualiza cada segundo en vez de 0.5s

# Optimizar blur en hyprlock para hardware menos potente
# Cambiar: blur_passes = 4
# Por: blur_passes = 2

# Reducir opacidad de aplicaciones para mejor rendimiento
# En kitty: background_opacity 1.0  # Sin transparencia
```

### 🎨 **Consistencia Visual**

```bash
# Siempre usar el mismo wallpaper durante sesiones largas de trabajo
echo "WALLPAPER_FIJO=/home/usuario/Rice/Wallpapers/trabajo.png" >> ~/.zshrc

# Crear función para modo trabajo
work_mode() {
    wal -i "$WALLPAPER_FIJO"
    cd ~/Rice/Scripts/
    ./update-all-colors.sh
}
```

### 🔧 **Automatización Inteligente**

```bash
# Hook para aplicar tema específico según hora del día
cat > ~/.config/wal/templates/time-based-theme.sh << 'EOF'
#!/bin/bash
hour=$(date +%H)

if [ $hour -ge 6 ] && [ $hour -lt 12 ]; then
    # Mañana - colores claros
    wal -i ~/Rice/Wallpapers/morning/
elif [ $hour -ge 12 ] && [ $hour -lt 18 ]; then
    # Tarde - colores neutros
    wal -i ~/Rice/Wallpapers/afternoon/
else
    # Noche - colores oscuros
    wal -i ~/Rice/Wallpapers/night/
fi
EOF
```

---

## 📖 **Resumen de Comandos Diarios**

### 🚀 **Comandos Más Usados**
1. `rice-random` - Cambiar tema completo
2. `Super + L` - Bloquear pantalla
3. `rice-status` - Verificar sistema
4. `hyprctl reload` - Recargar Hyprland
5. `killall dunst && dunst &` - Recargar notificaciones

### 🔧 **Comandos de Mantenimiento**
1. `./verify-dependencies.sh` - Verificar estado
2. `./update-all-colors.sh` - Actualizar todo
3. `./backup-configs.sh` - Crear backup
4. `pactl info` - Verificar audio
5. `journalctl --user -u hyprland -n 20` - Ver logs

### 🎨 **Comandos de Personalización**
1. `wal -i ~/Rice/Wallpapers/imagen.png` - Cambiar wallpaper específico
2. `./update-hyprland-cursor.sh` - Actualizar cursor
3. `spicetify apply` - Aplicar tema Spotify
4. `notify-send "Test" "Mensaje"` - Probar notificaciones
5. `hyprlock` - Probar bloqueo de pantalla

---

**🎉 ¡Disfruta de tu sistema de rice completamente automatizado! Con esta guía tendrás todo lo necesario para el uso diario y mantenimiento de tu configuración Hyprland + Arch Linux.**

---

## 📚 **Enlaces a Documentación Relacionada**

- **[README.md](README.md)** - Visión general del sistema
- **[DEPENDENCIES.md](DEPENDENCIES.md)** - Guía completa de dependencias
- **[INSTALLATION.md](INSTALLATION.md)** - Instalación paso a paso
- **[SCRIPTS.md](SCRIPTS.md)** - Documentación detallada de scripts

---

**Creado por [hen-x](https://github.com/hen-x) • Guía de uso diario y mantenimiento**
