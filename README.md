# 🌟 Configuración Hyprland + Arch Linux Rice

> **Sistema de escritorio altamente personalizado y automatizado con tematización dinámica por Pywal**

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Arch](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=arch-linux&logoColor=fff&style=for-the-badge)
![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=wayland&logoColor=black)

## 📋 Índice

- [✨ Características](#-características)
- [🖼️ Capturas](#️-capturas)
- [📦 Dependencias](#-dependencias)
- [⚡ Instalación Rápida](#-instalación-rápida)
- [📁 Estructura de Archivos](#-estructura-de-archivos)
- [🔧 Scripts y Automatización](#-scripts-y-automatización)
- [🎨 Componentes Temáticos](#-componentes-temáticos)
- [⚙️ Configuración Detallada](#️-configuración-detallada)
- [🚀 Uso Diario](#-uso-diario)
- [🎯 Personalización Avanzada](#-personalización-avanzada)
- [🔍 Troubleshooting](#-troubleshooting)
- [📚 Referencias](#-referencias)

## ✨ Características

### 🎨 **Tematización Automática**
- **Pywal Integration**: Colores automáticos generados desde wallpapers
- **Sync Global**: Todos los componentes se actualizan automáticamente
- **150+ Wallpapers**: Colección curada de fondos de pantalla
- **Hotkeys**: Cambio rápido de temas y wallpapers

### 🔒 **Sistema de Bloqueo Avanzado**
- **Hyprlock Matrix**: Reloj de palabras animado con efectos Matrix
- **Avatar de Usuario**: Soporte para ~/.face personalizada
- **Efectos Visuales**: Blur, sombras y animaciones suaves
- **Sonidos**: Notificaciones de bloqueo/desbloqueo

### 🖱️ **Cursor Dinámico**
- **Bibata Personalizado**: Cursor generado con colores de pywal
- **Auto-build**: Construcción automática con `cbmp` y `ctgen`
- **Integración Hyprland**: Aplicación automática en el compositor

### 🌐 **Navegador Personalizado**
- **Firefox Cascade**: Tema completo adaptativo
- **TabCenter Reborn**: Pestañas laterales con colores dinámicos
- **Side View**: Panel lateral tematizado
- **Backup Automático**: Protección de configuraciones

### 🎵 **Spotify Integrado**
- **Spicetify Theme**: Tema completo con colores de pywal
- **Efectos Visuales**: Gradientes, animaciones y glassmorphism
- **Auto-apply**: Aplicación automática al cambiar wallpaper

### 📱 **Terminal y Editor**
- **Kitty**: Configuración completa con colores adaptativos
- **Neovim**: Integración con Catppuccin y colores de pywal
- **JetBrains Mono**: Fuente con ligaduras y símbolos Nerd Font

### 🔔 **Notificaciones**
- **Dunst**: Sistema de notificaciones personalizado
- **Iconos**: Soporte completo para iconos de aplicaciones
- **Reglas**: Configuraciones específicas por aplicación

### 🚪 **Sistema de Logout**
- **Wlogout**: Menú de salida con comandos Hyprland
- **Efectos GTK**: CSS puro con propiedades oficiales
- **Keybinds**: Acceso rápido por teclado

## 🖼️ Capturas

| Componente | Preview |
|------------|---------|
| **Desktop** | ![Desktop](https://github.com/user-attachments/assets/65d38f86-e2b6-4b19-9cda-35ad997db4e1) |
| **Terminal** | ![Kitty](https://github.com/user-attachments/assets/77bb252b-0b17-40b0-9e11-dabcfb99c7fd) |
| **Lock Screen** | ![Lock](https://github.com/user-attachments/assets/524d6ae9-9edd-422e-978d-33f8640b9e5f) |
| **Rofi** | ![Rofi](https://github.com/user-attachments/assets/f4c49b38-bead-4927-9217-2b6e9bcdf1ab) |
| **Notifications** | ![SwayNC](https://github.com/user-attachments/assets/b0426902-e779-440b-b135-554ce29af81d) |
| **Editor** | ![Vim](https://github.com/user-attachments/assets/aa7a5ff1-3451-44f5-91de-530ba431340b) |
| **Logout** | ![Wlogout](https://github.com/user-attachments/assets/e0e13234-d9a2-4928-bea0-f4d216753297) |

## 📦 Dependencias

### 🔧 **Componentes Principales**

```bash
# Compositor y base
hyprland               # Compositor Wayland
hyprlock               # Locker nativo de Hyprland
wlogout                # Menú de logout para Wayland
dunst                  # Sistema de notificaciones
rofi-wayland           # Launcher de aplicaciones

# Terminal y shell
kitty                  # Emulador de terminal
zsh                    # Shell avanzado
```

### 🎨 **Tematización**

```bash
# Pywal y herramientas de color
python-pywal           # Generador de paletas de colores
python-pillow          # Procesamiento de imágenes para pywal
```

### 🖱️ **Cursor Personalizado**

```bash
# Herramientas de construcción de cursor
yarn                   # Gestor de paquetes de Node.js
npm                    # Node Package Manager
cbmp                   # Cursor bitmap processor (npm install -g cbmp)
ctgen                  # Cursor theme generator (cargo install ctgen)
```

### 📱 **Aplicaciones y Multimedia**

```bash
# Navegador y multimedia
firefox                # Navegador web
spotify                # Reproductor de música (AUR)
spicetify-cli          # CLI para personalizar Spotify

# Editor
neovim                 # Editor de texto moderno
```

### 🔧 **Herramientas del Sistema**

```bash
# Utilidades de imagen y sistema
grim                   # Captura de pantalla en Wayland
imagemagick            # Procesamiento de imágenes
file                   # Identificador de tipos de archivo
```

### 📦 **Instalación de Dependencias**

#### **Paquetes Oficiales (pacman)**
```bash
sudo pacman -S hyprland hyprlock wlogout dunst rofi-wayland \
               kitty zsh python-pywal python-pillow firefox \
               neovim grim imagemagick file yarn npm
```

#### **AUR (paru/yay)**
```bash
# Spotify y herramientas de cursor
paru -S spotify spicetify-cli

# Herramientas de cursor (alternativa)
paru -S cursor-toolbox  # Incluye ctgen
```

#### **NPM/Cargo**
```bash
# Herramientas de construcción de cursor
npm install -g cbmp
cargo install ctgen
```

#### **Spicetify Setup**
```bash
# Configuración inicial de Spicetify
spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
spicetify backup apply
```

## ⚡ Instalación Rápida

### 1. **Clonar y Posicionar Archivos**

```bash
# Navegar al directorio del usuario
cd ~/

# Los archivos del rice deben estar en /home/h3n/Home/USER/
# Estructura esperada:
# ~/Rice/
# ├── Scripts/
# ├── Wallpapers/
# ├── Bibata_Cursor/
# └── Notifications/
```

### 2. **Instalar Dependencias**

```bash
# Instalar paquetes base
sudo pacman -S hyprland hyprlock wlogout dunst rofi-wayland \
               kitty zsh python-pywal python-pillow firefox \
               neovim grim imagemagick file yarn npm

# Instalar desde AUR
paru -S spotify spicetify-cli cursor-toolbox

# Herramientas de cursor
npm install -g cbmp
cargo install ctgen
```

### 3. **Configurar Avatar de Usuario**

```bash
# Copiar tu foto de perfil
cp /ruta/a/tu/foto.jpg ~/.face

# O descargar desde GitHub
wget -O ~/.face 'https://github.com/tuusuario.png'
```

### 4. **Configurar Spicetify**

```bash
# Setup inicial
spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
spicetify backup apply
```

### 5. **Ejecutar Setup Inicial**

```bash
# Navegar a los scripts
cd ~/Rice/Scripts/

# Hacer ejecutables
chmod +x *.sh

# Configurar hyprlock con matrix
./setup_hyprlock.sh

# Aplicar primer wallpaper y generar colores
wal -i ~/Rice/Wallpapers/imagen_001.png

# Configurar cursor personalizado
./update-hyprland-cursor.sh

# Aplicar temas a todas las aplicaciones
./update-kitty-colors.sh
./update-dunst-colors.sh
./update-wlogout-colors.sh
./update-spicetify-colors.sh
./update-firefox-all.sh
```

## 📁 Estructura de Archivos

```
/home/h3n/Home/USER/
├── 📄 README.md                    # Esta documentación
├── 🖼️ *.png                        # Capturas de pantalla
│
├── 📁 Rice/
│   ├── 📁 Scripts/                 # Scripts de automatización
│   │   ├── 🔒 lockscreen.sh        # Script de bloqueo básico
│   │   ├── ⚙️ setup_hyprlock.sh    # Configuración inicial de hyprlock
│   │   ├── 🎨 generate_matrix_hyprlock.sh  # Generador de tema matrix
│   │   ├── ⏰ word_clock_matrix.sh # Reloj de palabras para lock
│   │   ├── 🎨 update_hyprlock_colors.sh   # Actualizar colores hyprlock
│   │   ├── 🖱️ update-hyprland-cursor.sh  # Generar cursor personalizado
│   │   ├── 🎯 update-hyprland-config.sh  # Actualizar config Hyprland
│   │   ├── 💻 update-kitty-colors.sh     # Actualizar colores Kitty
│   │   ├── 🔔 update-dunst-colors.sh     # Actualizar colores Dunst
│   │   ├── 🚪 update-wlogout-colors.sh   # Actualizar colores Wlogout
│   │   ├── 🎵 update-spicetify-colors.sh # Actualizar colores Spotify
│   │   ├── 🌐 update-firefox-colors.sh   # Actualizar colores Firefox
│   │   ├── 🌐 update-firefox-all.sh      # Actualizar todos los CSS Firefox
│   │   ├── 🌐 update-tabcenter-colors.sh # Actualizar TabCenter
│   │   ├── 🌐 update-sideview-colors.sh  # Actualizar Side View
│   │   ├── 🌐 update-tcr-colors.sh       # Actualizar TCR
│   │   ├── 📝 update-nvim-colors.sh      # Actualizar colores Neovim
│   │   └── 👤 check-user-avatar.sh       # Verificar avatar usuario
│   │
│   ├── 📁 Wallpapers/              # Colección de fondos (150+ imágenes)
│   │   ├── imagen_001.png
│   │   ├── imagen_002.png
│   │   └── ...
│   │
│   ├── 📁 Bibata_Cursor/           # Repositorio de cursor personalizable
│   │   ├── 📄 build.toml           # Configuración de construcción
│   │   ├── 🔧 build.sh             # Script de construcción
│   │   ├── 📁 svg/                 # Archivos fuente SVG
│   │   ├── 📁 bitmaps/             # Bitmaps generados
│   │   └── 📁 configs/             # Configuraciones por variante
│   │
│   └── 📁 Notifications/           # Sonidos del sistema
│       ├── 🔒 lock.wav             # Sonido de bloqueo
│       ├── 🔓 unlock.wav           # Sonido de desbloqueo
│       └── ❌ wrong.wav            # Sonido de error
│
└── 📊 Configuraciones generadas en ~/.config/
    ├── hypr/
    │   ├── hyprland.conf           # Configuración principal Hyprland
    │   ├── hyprlock.conf           # Configuración lock screen
    │   └── scripts/                # Scripts auxiliares
    ├── kitty/
    │   └── kitty.conf              # Configuración terminal
    ├── dunst/
    │   └── dunstrc                 # Configuración notificaciones
    ├── wlogout/
    │   ├── layout                  # Layout botones logout
    │   ├── style.css               # Estilos CSS
    │   └── icons/                  # Iconos personalizados
    ├── spicetify/
    │   └── Themes/pywal/           # Tema Spotify
    └── nvim/
        └── lua/plugins/colorscheme.lua  # Configuración colores Neovim
```

## 🔧 Scripts y Automatización

### 🎨 **Scripts de Tematización**

#### `setup_hyprlock.sh`
Configuración inicial del sistema de bloqueo Matrix.

**Funciones:**
- Crea directorios necesarios
- Configura scripts ejecutables
- Genera configuración inicial
- Crea hook automático de pywal
- Verifica avatar de usuario

**Uso:**
```bash
./setup_hyprlock.sh
```

#### `generate_matrix_hyprlock.sh`
Genera la configuración completa de hyprlock con efectos Matrix.

**Características:**
- Reloj de palabras animado
- Efectos de blur y sombras
- Colores dinámicos de pywal
- Soporte para avatar personalizado
- Animaciones suaves

#### `word_clock_matrix.sh`
Script del reloj de palabras que se ejecuta cada 500ms.

**Características:**
- Matriz de 11x11 caracteres
- Palabras resaltadas según la hora
- Colores adaptativos
- Formato 12 horas
- Efectos de atenuación

### 🖱️ **Scripts de Cursor**

#### `update-hyprland-cursor.sh`
Script completo para generar cursor personalizado con colores de pywal.

**Funciones principales:**
- ✅ Verificación de dependencias
- 🎨 Lectura de colores pywal
- 🔨 Generación de cursor con `cbmp` y `ctgen`
- ⚙️ Actualización de configuración Hyprland
- 🔄 Recarga automática del cursor
- 📋 Creación de scripts de automatización

**Dependencias verificadas:**
- `cbmp` (npm install -g cbmp)
- `ctgen` (cargo install ctgen)
- `npx` (Node.js)
- Archivos de pywal
- Directorio Bibata_Cursor

**Uso:**
```bash
# Verificar dependencias solamente
./update-hyprland-cursor.sh --check

# Ejecutar sin hacer cambios (dry-run)
./update-hyprland-cursor.sh --dry-run

# Aplicar cursor personalizado
./update-hyprland-cursor.sh
```

### 🎵 **Scripts de Aplicaciones**

#### `update-spicetify-colors.sh`
Configuración completa de Spotify con Spicetify.

**Archivos generados:**
- `color.ini`: Configuración de colores principal
- `user.css`: Estilos CSS personalizados
- `apply-theme.sh`: Script de aplicación
- `spicetify-aliases.sh`: Aliases útiles
- `README.md`: Documentación específica

**Características:**
- Gradientes y efectos visuales
- Scrollbar personalizada
- Animaciones suaves
- Controles mejorados

#### `update-kitty-colors.sh`
Configuración completa del terminal Kitty.

**Características incluidas:**
- Fuentes JetBrains Mono Nerd Font
- Colores adaptativos de pywal
- Configuración completa de keybinds
- Soporte para símbolos y emojis
- Configuración de tabs y ventanas

#### `update-firefox-all.sh`
Actualiza todos los componentes CSS de Firefox.

**Componentes actualizados:**
1. **cascade-colours.css**: Colores principales
2. **tabcenter-reborn.css**: TabCenter Reborn
3. **cascade-sideview.css**: Side View
4. **cascade-tcr.css**: TabCenter Reborn TCR

### 🔔 **Scripts de Sistema**

#### `update-dunst-colors.sh`
Configuración avanzada del sistema de notificaciones.

**Características:**
- Colores adaptativos con transparencia
- Soporte completo para iconos
- Configuración por urgencia
- Reglas específicas por aplicación
- Efectos visuales y animaciones

#### `update-wlogout-colors.sh`
Configuración completa del menú de logout para Hyprland.

**Características:**
- JSON válido para layout
- Comandos específicos de Hyprland
- CSS con propiedades GTK oficiales
- Efectos visuales avanzados
- Sistema de automatización

## 🎨 Componentes Temáticos

### 🔒 **Sistema de Bloqueo (Hyprlock)**

El sistema de bloqueo utiliza un diseño Matrix único con un reloj de palabras.

**Estructura visual:**
```
    [Avatar Usuario]
         ↓
   [Reloj de Palabras]
         ↓
   [Campo Contraseña]
```

**Características:**
- **Reloj Matrix**: Matriz de 11x11 con palabras resaltadas
- **Avatar**: Soporte para `~/.face` personalizada
- **Efectos**: Blur del fondo, sombras, animaciones
- **Sonidos**: Notificaciones de bloqueo/desbloqueo

### 🖱️ **Cursor Dinámico (Bibata-Wal)**

Sistema de cursor que se adapta automáticamente a los colores del wallpaper.

**Proceso de generación:**
1. Pywal genera colores desde el wallpaper
2. Script lee colores de `~/.cache/wal/colors.scss`
3. `cbmp` genera bitmaps con colores personalizados
4. `ctgen` construye el cursor final
5. Se instala automáticamente en `~/.local/share/icons/`
6. Hyprland se recarga con el nuevo cursor

**Colores utilizados:**
- **Border**: `color1` (borde principal)
- **Outline**: `color2` (contorno)
- **Watch**: `cursor` (animación de carga)

### 🌐 **Firefox Cascade Theme**

Tema completo para Firefox que incluye múltiples componentes.

**Componentes:**
1. **Cascade Colours**: Colores base del tema
2. **TabCenter Reborn**: Pestañas laterales
3. **Side View**: Panel lateral
4. **TCR Integration**: Integración TabCenter

**Archivos CSS actualizados:**
- `~/.mozilla/firefox/*/chrome/includes/cascade-colours.css`
- `~/.mozilla/firefox/*/chrome/includes/tabcenter-reborn.css`
- `~/.mozilla/firefox/*/chrome/includes/cascade-sideview.css`
- `~/.mozilla/firefox/*/chrome/includes/cascade-tcr.css`

### 🎵 **Spotify (Spicetify)**

Tema completo para Spotify con efectos visuales avanzados.

**Efectos incluidos:**
- Gradientes en botones y barras de progreso
- Glassmorphism en sidebar
- Cards con sombras personalizadas
- Scrollbar tematizada
- Animaciones suaves en hover

**Arquitectura:**
```
~/.config/spicetify/Themes/pywal/
├── color.ini              # Configuración de colores
├── user.css               # Estilos personalizados
├── apply-theme.sh         # Script de aplicación
├── spicetify-aliases.sh   # Aliases útiles
└── README.md              # Documentación
```

## ⚙️ Configuración Detallada

### 🔧 **Configuración de Hyprland**

#### **Keybinds Recomendados**

Agregar a `~/.config/hypr/hyprland.conf`:

```toml
# Sistema de bloqueo
bind = SUPER, L, exec, hyprlock

# Menu de logout
bind = SUPER SHIFT, E, exec, ~/.config/wlogout/launch-wlogout.sh

# Cambiar wallpaper y aplicar tema
bind = SUPER, W, exec, wal -i ~/Rice/Wallpapers/ --random
bind = SUPER SHIFT, W, exec, ~/Rice/Scripts/update-all-colors.sh

# Captura de pantalla con lock
bind = SUPER, P, exec, ~/Rice/Scripts/lockscreen.sh
```

#### **Variables de Entorno**

```toml
# Cursor personalizado
env = XCURSOR_THEME,Bibata-Wal
env = XCURSOR_SIZE,24
env = HYPRCURSOR_SIZE,24

# Terminal preferido
env = TERMINAL,kitty
```

### 🎨 **Automatización con Pywal**

#### **Hook Automático**

El sistema incluye un hook que se ejecuta automáticamente cuando cambias el wallpaper:

**Ubicación:** `~/.config/wal/templates/`

**Scripts ejecutados automáticamente:**
1. `update_hyprlock_colors.sh`
2. `update-hyprland-cursor.sh`
3. `update-kitty-colors.sh`
4. `update-dunst-colors.sh`
5. `update-spicetify-colors.sh`

#### **Script de Actualización Global**

Crear script para actualizar todos los componentes:

```bash
#!/bin/bash
# ~/Rice/Scripts/update-all-colors.sh

cd ~/Rice/Scripts/

echo "🎨 Actualizando todos los colores..."

./update_hyprlock_colors.sh
./update-hyprland-config.sh
./update-hyprland-cursor.sh
./update-kitty-colors.sh
./update-dunst-colors.sh
./update-wlogout-colors.sh
./update-spicetify-colors.sh
./update-firefox-all.sh

echo "✅ Todos los colores actualizados!"
```

### 📱 **Configuración de Aplicaciones**

#### **Kitty Terminal**

**Características configuradas:**
- Fuente: JetBrains Mono Nerd Font
- Tamaño: 12px con ajuste de línea 110%
- Transparencia: 95% de opacidad
- Soporte completo para emojis y símbolos
- Keybinds personalizados
- Configuración de tabs y ventanas

#### **Dunst Notifications**

**Configuración avanzada:**
- Posición: Esquina superior derecha
- Iconos: Soporte completo con múltiples rutas
- Transparencia: 80% de opacidad
- Animaciones: Transiciones suaves
- Reglas: Configuración específica para Spotify

#### **Neovim**

**Integración con Catppuccin:**
- Tema base: Catppuccin Mocha
- Colores personalizados de pywal
- Integración con plugins populares
- Actualización automática

## 🚀 Uso Diario

### 🎨 **Cambiar Tema Completo**

```bash
# Cambiar a wallpaper específico
wal -i ~/Rice/Wallpapers/imagen_001.png

# Wallpaper aleatorio
wal -i ~/Rice/Wallpapers/ --random

# Actualizar manualmente todos los componentes
cd ~/Rice/Scripts/
./update-all-colors.sh
```

### 🔒 **Sistema de Bloqueo**

```bash
# Bloqueo simple
hyprlock

# Bloqueo con captura (para testing)
~/Rice/Scripts/lockscreen.sh
```

### 🖱️ **Actualizar Cursor**

```bash
# Generar nuevo cursor con colores actuales
cd ~/Rice/Scripts/
./update-hyprland-cursor.sh

# Verificar estado
./update-hyprland-cursor.sh --check
```

### 🎵 **Spotify**

```bash
# Aplicar tema a Spotify
cd ~/.config/spicetify/Themes/pywal/
./apply-theme.sh

# Cargar aliases útiles
source ~/.config/spicetify/Themes/pywal/spicetify-aliases.sh

# Comandos disponibles después de cargar aliases
spicetify-update    # Actualizar colores
spicetify-status    # Ver estado
spicetify-edit css  # Editar CSS personalizado
```

### 🌐 **Firefox**

```bash
# Actualizar todos los CSS de Firefox
cd ~/Rice/Scripts/
./update-firefox-all.sh

# Actualizar componente específico
./update-firefox-colors.sh      # Colores principales
./update-tabcenter-colors.sh    # TabCenter Reborn
./update-sideview-colors.sh     # Side View
./update-tcr-colors.sh          # TCR
```

### 🔔 **Notificaciones**

```bash
# Actualizar configuración
cd ~/Rice/Scripts/
./update-dunst-colors.sh

# Recargar Dunst
killall dunst && dunst &

# Test de notificación
notify-send "Test" "Notificación de prueba"
```

## 🎯 Personalización Avanzada

### 🎨 **Modificar Colores Manualmente**

#### **Editar configuración de hyprlock:**
```bash
nano ~/.config/hypr/hyprlock.conf
```

#### **Personalizar cursor:**
```bash
# Editar configuración de construcción
nano ~/Rice/Bibata_Cursor/build.toml

# Regenerar con configuración personalizada
cd ~/Rice/Scripts/
./update-hyprland-cursor.sh
```

#### **CSS personalizado para Spotify:**
```bash
# Editar estilos
nano ~/.config/spicetify/Themes/pywal/user.css

# Aplicar cambios
spicetify apply
```

### 🖼️ **Agregar Nuevos Wallpapers**

```bash
# Copiar nuevos wallpapers
cp /ruta/a/nuevos/wallpapers/* ~/Rice/Wallpapers/

# Usar wallpaper específico
wal -i ~/Rice/Wallpapers/tu_nuevo_wallpaper.png
```

### 🔧 **Crear Scripts Personalizados**

#### **Template de script básico:**
```bash
#!/bin/bash
# ~/Rice/Scripts/mi-script-personalizado.sh

PYWAL_COLORS="$HOME/.cache/wal/colors.sh"

# Verificar pywal
if [ ! -f "$PYWAL_COLORS" ]; then
  echo "❌ No se encontró pywal"
  exit 1
fi

# Cargar colores
source "$PYWAL_COLORS"

# Tu lógica aquí
echo "🎨 Colores disponibles:"
echo "Background: $background"
echo "Foreground: $foreground"
echo "Color1: $color1"
# ... etc

# Aplicar a tu aplicación
echo "✅ Script completado"
```

### ⚡ **Automatización Avanzada**

#### **Systemd Service para auto-aplicar tema:**

```ini
# ~/.config/systemd/user/pywal-theme.service
[Unit]
Description=Apply pywal theme on wallpaper change
After=graphical-session.target

[Service]
Type=oneshot
ExecStart=/home/h3n/Rice/Scripts/update-all-colors.sh
Environment=DISPLAY=%i

[Install]
WantedBy=default.target
```

#### **Activar servicio:**
```bash
systemctl --user enable pywal-theme.service
systemctl --user start pywal-theme.service
```

## 🔍 Troubleshooting

### ❌ **Problemas Comunes**

#### **Cursor no se aplica**
```bash
# Verificar dependencias
cd ~/Rice/Scripts/
./update-hyprland-cursor.sh --check

# Limpiar cache y regenerar
rm -rf ~/.local/share/icons/Bibata-Wal
./update-hyprland-cursor.sh

# Verificar variables de entorno
echo $XCURSOR_THEME
hyprctl getoption cursor:no_hardware_cursors
```

#### **Hyprlock no muestra matriz**
```bash
# Verificar script del reloj
~/.config/hypr/scripts/word_clock_matrix.sh

# Verificar permisos
chmod +x ~/.config/hypr/scripts/word_clock_matrix.sh

# Regenerar configuración
cd ~/Rice/Scripts/
./setup_hyprlock.sh
```

#### **Spicetify no se aplica**
```bash
# Verificar instalación
spicetify -v

# Reconfigurar
spicetify config current_theme pywal
spicetify backup apply

# Verificar permisos de Spotify
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
```

#### **Firefox CSS no funciona**
```bash
# Verificar que userChrome.css está habilitado en about:config
# toolkit.legacyUserProfileCustomizations.stylesheets = true

# Verificar estructura de archivos
ls -la ~/.mozilla/firefox/*/chrome/includes/

# Ejecutar script específico
cd ~/Rice/Scripts/
./update-firefox-all.sh
```

### 🔧 **Comandos de Diagnóstico**

#### **Verificar estado general:**
```bash
cd ~/Rice/Scripts/

# Verificar avatar
./check-user-avatar.sh

# Estado de cursor
./update-hyprland-cursor.sh --check

# Estado de pywal
wal --version
ls -la ~/.cache/wal/
```

#### **Logs del sistema:**
```bash
# Logs de Hyprland
journalctl --user -u hyprland

# Logs de notificaciones
journalctl --user -u dunst

# Verificar procesos
ps aux | grep -E "(hyprland|dunst|kitty|spotify)"
```

### 🚑 **Recovery Scripts**

#### **Restaurar configuraciones:**
```bash
# Backup automático de Firefox (los scripts crean backups)
ls ~/.mozilla/firefox/*/chrome/includes/backup/

# Restaurar Firefox
cp ~/.mozilla/firefox/*/chrome/includes/backup/cascade-colours.css.bak.* \
   ~/.mozilla/firefox/*/chrome/includes/cascade-colours.css

# Restaurar Spicetify
spicetify restore

# Regenerar todo desde cero
cd ~/Rice/Scripts/
./setup_hyprlock.sh
wal -i ~/Rice/Wallpapers/imagen_001.png
./update-all-colors.sh
```

## 📚 Referencias

### 🔗 **Proyectos y Dependencias**

- **[Hyprland](https://hyprland.org/)** - Compositor Wayland dinámico
- **[Pywal](https://github.com/dylanaraps/pywal)** - Generador de paletas de colores
- **[Bibata Cursor](https://github.com/ful1e5/Bibata_Cursor)** - Cursor personalizable
- **[Spicetify](https://spicetify.app/)** - Personalizador de Spotify
- **[Firefox Cascade](https://github.com/andreasgrafen/cascade)** - Tema Firefox
- **[Kitty](https://sw.kovidgoyal.net/kitty/)** - Terminal moderno
- **[Dunst](https://dunst-project.org/)** - Sistema de notificaciones
- **[Wlogout](https://github.com/ArtsyMacaw/wlogout)** - Menú de logout

### 🛠️ **Herramientas de Construcción**

- **[cbmp](https://www.npmjs.com/package/cbmp)** - Cursor bitmap processor
- **[ctgen](https://github.com/ful1e5/cursor-toolbox)** - Cursor theme generator
- **[JetBrains Mono](https://www.jetbrains.com/mono/)** - Fuente con ligaduras

### 📖 **Documentación Adicional**

- **[Hyprland Wiki](https://wiki.hyprland.org/)** - Documentación oficial
- **[Arch Wiki](https://wiki.archlinux.org/)** - Referencia del sistema
- **[Wayland](https://wayland.freedesktop.org/)** - Protocolo de display

---

## 🤝 Contribuciones

Este es un proyecto personal, pero las sugerencias y mejoras son bienvenidas. Si encuentras algún problema o tienes ideas para mejorar el sistema, no dudes en compartirlas.

## 📄 Licencia

Este proyecto está disponible bajo la licencia MIT. Los componentes individuales mantienen sus respectivas licencias.

---

**Creado por [hen-x](https://github.com/hen-x) • GitHub: https://github.com/hen-x**

---

> 🌟 **¡Disfruta de tu escritorio personalizado!** 🌟
>
> Este sistema está diseñado para ser tanto funcional como visualmente impresionante. Cada componente ha sido cuidadosamente integrado para proporcionar una experiencia cohesiva y automática.
