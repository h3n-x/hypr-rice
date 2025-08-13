# 🚀 Guía de Instalación Paso a Paso

> **Instalación completa del sistema de rice Hyprland + Arch Linux desde cero**

## 📋 Índice

- [⚡ Instalación Express (15 minutos)](#-instalación-express-15-minutos)
- [🔧 Instalación Detallada](#-instalación-detallada)
- [🎨 Configuración Inicial](#-configuración-inicial)
- [🧪 Verificación y Testing](#-verificación-y-testing)
- [📱 Post-Instalación](#-post-instalación)
- [🚑 Resolución de Problemas](#-resolución-de-problemas)

## ⚡ Instalación Express (15 minutos)

### 🚀 **Para usuarios experimentados**

```bash
# 1. Instalar dependencias base
sudo pacman -S hyprland hyprlock wlogout dunst rofi-wayland kitty zsh \
               python-pywal python-pillow firefox neovim grim imagemagick \
               file yarn npm pipewire pipewire-pulse wireplumber

# 2. Instalar herramientas AUR
paru -S spotify spicetify-cli cursor-toolbox

# 3. Instalar herramientas de cursor
npm install -g cbmp
cargo install ctgen

# 4. Configurar Spicetify
sudo chmod a+wr /opt/spotify /opt/spotify/Apps -R
spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
spicetify backup apply

# 5. Copiar archivos del rice (asumiendo que ya tienes los archivos)
# Los archivos deben estar en ~/Rice/

# 6. Configurar avatar
cp /ruta/a/tu/foto.jpg ~/.face

# 7. Ejecutar setup
cd ~/Rice/Scripts/
chmod +x *.sh
./setup_hyprlock.sh
wal -i ~/Rice/Wallpapers/imagen_001.png
./update-hyprland-cursor.sh
./update-kitty-colors.sh
./update-dunst-colors.sh
./update-wlogout-colors.sh
./update-spicetify-colors.sh
./update-firefox-all.sh

# 8. Habilitar userChrome en Firefox
# about:config → toolkit.legacyUserProfileCustomizations.stylesheets → true
```

## 🔧 Instalación Detallada

### 📋 **Paso 0: Preparación del Sistema**

#### **Verificar sistema base**
```bash
# Verificar que estás en Arch Linux
cat /etc/os-release

# Actualizar sistema
sudo pacman -Syu

# Verificar usuario en grupos necesarios
groups $USER
# Debe incluir: wheel, audio, video
```

#### **Instalar AUR helper si no lo tienes**
```bash
# Instalar paru (recomendado)
cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ~
```

### 📦 **Paso 1: Instalación de Paquetes Base**

#### **1.1 Sistema Hyprland**
```bash
echo "🏗️ Instalando compositor Hyprland..."
sudo pacman -S hyprland hyprlock hypridle xdg-desktop-portal-hyprland
```

#### **1.2 Herramientas Wayland**
```bash
echo "🌊 Instalando herramientas Wayland..."
sudo pacman -S wl-clipboard grim slurp swappy
```

#### **1.3 Sistema de tematización**
```bash
echo "🎨 Instalando sistema de colores..."
sudo pacman -S python-pywal python-pillow imagemagick feh
```

#### **1.4 Aplicaciones principales**
```bash
echo "📱 Instalando aplicaciones..."
sudo pacman -S kitty zsh firefox neovim nodejs npm
```

#### **1.5 Sistema de notificaciones y menús**
```bash
echo "🔔 Instalando notificaciones y menús..."
sudo pacman -S dunst libnotify rofi rofi-wayland wlogout
```

#### **1.6 Audio PipeWire**
```bash
echo "🔊 Instalando sistema de audio..."
sudo pacman -S pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol pamixer
```

#### **1.7 Fuentes y iconos**
```bash
echo "🎯 Instalando fuentes e iconos..."
sudo pacman -S ttf-jetbrains-mono-nerd ttf-fira-code noto-fonts noto-fonts-emoji
sudo pacman -S papirus-icon-theme adwaita-icon-theme hicolor-icon-theme
```

#### **1.8 Herramientas de desarrollo**
```bash
echo "🛠️ Instalando herramientas de desarrollo..."
sudo pacman -S base-devel rust cargo yarn git file unzip wget curl
```

### 🎭 **Paso 2: Paquetes AUR**

#### **2.1 Spotify y Spicetify**
```bash
echo "🎵 Instalando Spotify y Spicetify..."
paru -S spotify spicetify-cli
```

#### **2.2 Herramientas de cursor**
```bash
echo "🖱️ Instalando herramientas de cursor..."
paru -S cursor-toolbox
```

#### **2.3 Temas adicionales (opcional)**
```bash
echo "🎨 Instalando temas adicionales..."
paru -S catppuccin-gtk-theme nordic-theme tela-icon-theme
```

### 📱 **Paso 3: Herramientas NPM/Cargo**

#### **3.1 Herramientas de cursor**
```bash
echo "⚙️ Instalando herramientas de construcción de cursor..."
npm install -g cbmp
cargo install ctgen
```

#### **3.2 Verificar instalación**
```bash
echo "✅ Verificando herramientas de cursor..."
which cbmp  # Debe mostrar ruta
which ctgen # Debe mostrar ruta
cbmp --version
ctgen --version
```

### 🎨 **Paso 4: Configuración de Aplicaciones**

#### **4.1 Configurar Spicetify**
```bash
echo "🎵 Configurando Spicetify..."

# Dar permisos a Spotify
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R

# Configuración inicial
spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
spicetify backup apply

# Verificar
spicetify config
```

#### **4.2 Configurar PipeWire**
```bash
echo "🔊 Configurando PipeWire..."

# Habilitar servicios
systemctl --user enable pipewire.service
systemctl --user enable pipewire-pulse.service
systemctl --user enable wireplumber.service

# Iniciar servicios
systemctl --user start pipewire.service
systemctl --user start pipewire-pulse.service
systemctl --user start wireplumber.service

# Verificar
pactl info | grep "Server Name"
```

#### **4.3 Configurar Firefox**
```bash
echo "🌐 Preparando Firefox..."

# Crear perfil si no existe (ejecutar Firefox una vez)
timeout 10s firefox --headless || true

# Encontrar directorio de perfil
FIREFOX_PROFILE=$(find ~/.mozilla/firefox -name "*.default-release" -type d | head -1)
echo "Perfil de Firefox: $FIREFOX_PROFILE"

# Crear estructura de directorios
mkdir -p "$FIREFOX_PROFILE/chrome"
mkdir -p "$FIREFOX_PROFILE/chrome/includes"

echo "⚠️ IMPORTANTE: Habilita userChrome.css en Firefox:"
echo "1. Abre Firefox"
echo "2. Ve a about:config"
echo "3. Busca: toolkit.legacyUserProfileCustomizations.stylesheets"
echo "4. Cambia el valor a: true"
echo "5. Reinicia Firefox"
```

### 📁 **Paso 5: Configuración del Rice**

#### **5.1 Crear estructura de directorios**
```bash
echo "📁 Creando estructura de directorios..."

# Crear directorios principales
mkdir -p ~/Rice/{Scripts,Wallpapers,Notifications}
mkdir -p ~/.config/hypr/scripts
mkdir -p ~/.config/kitty
mkdir -p ~/.config/dunst
mkdir -p ~/.config/wlogout

echo "✅ Estructura de directorios creada"
```

#### **5.2 Configurar avatar de usuario**
```bash
echo "👤 Configurando avatar de usuario..."

# Opción 1: Copiar imagen local
read -p "¿Tienes una imagen local para avatar? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Ruta completa a tu imagen: " USER_IMAGE
    if [ -f "$USER_IMAGE" ]; then
        cp "$USER_IMAGE" ~/.face
        echo "✅ Avatar configurado desde: $USER_IMAGE"
    else
        echo "❌ Archivo no encontrado: $USER_IMAGE"
    fi
else
    # Opción 2: Usar imagen por defecto
    echo "📥 Descargando avatar por defecto..."
    wget -O ~/.face "https://raw.githubusercontent.com/NvChad/nvchad.github.io/src/static/img/logo/logo.png" 2>/dev/null || {
        echo "⚠️ No se pudo descargar avatar. Usa: cp /ruta/a/tu/imagen.jpg ~/.face"
    }
fi

# Verificar avatar
if [ -f ~/.face ]; then
    echo "✅ Avatar configurado: ~/.face"
    file ~/.face
else
    echo "⚠️ Avatar no configurado. El sistema usará icono por defecto."
fi
```

#### **5.3 Copiar archivos del rice**
```bash
echo "📋 Configurando archivos del rice..."

# Nota: Aquí necesitas tener los archivos del rice disponibles
# Si tienes un repositorio git, clónalo:
# git clone https://github.com/tu-usuario/tu-rice.git ~/Rice

# Si tienes los archivos en otro lugar, cópialos:
# cp -r /ruta/a/rice/* ~/Rice/

echo "⚠️ IMPORTANTE: Asegúrate de tener los siguientes archivos en ~/Rice/:"
echo "  - Scripts/ (todos los scripts .sh)"
echo "  - Wallpapers/ (imágenes .png)"
echo "  - Bibata_Cursor/ (repositorio completo)"
echo "  - Notifications/ (archivos .wav)"

# Hacer scripts ejecutables
if [ -d ~/Rice/Scripts ]; then
    chmod +x ~/Rice/Scripts/*.sh
    echo "✅ Scripts hechos ejecutables"
else
    echo "❌ Directorio ~/Rice/Scripts no encontrado"
fi
```

## 🎨 Configuración Inicial

### 🔧 **Paso 6: Setup del Sistema de Bloqueo**

```bash
echo "🔒 Configurando sistema de bloqueo Matrix..."

cd ~/Rice/Scripts/

# Verificar que el script existe
if [ -f setup_hyprlock.sh ]; then
    ./setup_hyprlock.sh
    echo "✅ Sistema de bloqueo configurado"
else
    echo "❌ Script setup_hyprlock.sh no encontrado"
    echo "Creando configuración básica de hyprlock..."
    
    # Crear configuración básica si no existe el script
    mkdir -p ~/.config/hypr
    cat > ~/.config/hypr/hyprlock.conf << 'EOF'
general {
    disable_loading_bar = false
    grace = 2
    hide_cursor = true
}

background {
    monitor =
    path = ~/Rice/Wallpapers/imagen_001.png
    blur_passes = 3
    blur_size = 8
}

input-field {
    monitor =
    size = 300, 50
    position = 0, -20
    halign = center
    valign = center
}
EOF
    echo "✅ Configuración básica de hyprlock creada"
fi
```

### 🎨 **Paso 7: Aplicar Primer Tema**

```bash
echo "🎨 Aplicando primer tema..."

# Verificar que hay wallpapers
if [ -d ~/Rice/Wallpapers ] && [ "$(ls -A ~/Rice/Wallpapers/*.png 2>/dev/null)" ]; then
    # Aplicar primer wallpaper
    FIRST_WALLPAPER=$(ls ~/Rice/Wallpapers/*.png | head -1)
    echo "📸 Aplicando wallpaper: $FIRST_WALLPAPER"
    wal -i "$FIRST_WALLPAPER"
    
    # Verificar que pywal funcionó
    if [ -f ~/.cache/wal/colors.sh ]; then
        echo "✅ Pywal configurado correctamente"
        source ~/.cache/wal/colors.sh
        echo "🎨 Colores generados:"
        echo "  Background: $background"
        echo "  Foreground: $foreground"
    else
        echo "❌ Error al generar colores con pywal"
        exit 1
    fi
else
    echo "❌ No se encontraron wallpapers en ~/Rice/Wallpapers/"
    echo "Creando wallpaper de prueba..."
    mkdir -p ~/Rice/Wallpapers
    # Crear imagen sólida de prueba
    convert -size 1920x1080 xc:"#2E3440" ~/Rice/Wallpapers/test.png
    wal -i ~/Rice/Wallpapers/test.png
fi
```

### 🖱️ **Paso 8: Configurar Cursor Personalizado**

```bash
echo "🖱️ Configurando cursor personalizado..."

cd ~/Rice/Scripts/

# Verificar dependencias de cursor
if command -v cbmp &> /dev/null && command -v ctgen &> /dev/null; then
    if [ -f update-hyprland-cursor.sh ]; then
        # Verificar dependencias primero
        ./update-hyprland-cursor.sh --check
        if [ $? -eq 0 ]; then
            echo "🔨 Generando cursor personalizado..."
            ./update-hyprland-cursor.sh
        else
            echo "❌ Faltan dependencias para el cursor"
            echo "Usando cursor por defecto"
        fi
    else
        echo "⚠️ Script de cursor no encontrado, usando cursor por defecto"
    fi
else
    echo "❌ cbmp o ctgen no instalados, usando cursor por defecto"
fi
```

### 📱 **Paso 9: Configurar Aplicaciones**

```bash
echo "📱 Configurando aplicaciones..."

cd ~/Rice/Scripts/

# Array de scripts para ejecutar
scripts=(
    "update-kitty-colors.sh"
    "update-dunst-colors.sh"
    "update-wlogout-colors.sh"
    "update-spicetify-colors.sh"
)

# Ejecutar cada script si existe
for script in "${scripts[@]}"; do
    if [ -f "$script" ]; then
        echo "⚙️ Ejecutando: $script"
        ./"$script"
        if [ $? -eq 0 ]; then
            echo "✅ $script completado"
        else
            echo "❌ Error en $script"
        fi
    else
        echo "⚠️ Script no encontrado: $script"
    fi
done

# Firefox requiere configuración manual
echo "🌐 Configurando Firefox..."
if [ -f update-firefox-all.sh ]; then
    ./update-firefox-all.sh
    echo "✅ CSS de Firefox actualizado"
    echo "⚠️ RECUERDA: Habilitar userChrome.css en about:config"
else
    echo "⚠️ Script de Firefox no encontrado"
fi
```

### ⚙️ **Paso 10: Configurar Hyprland**

```bash
echo "⚙️ Configurando Hyprland..."

# Crear configuración básica si no existe
if [ ! -f ~/.config/hypr/hyprland.conf ]; then
    echo "📝 Creando configuración base de Hyprland..."
    cat > ~/.config/hypr/hyprland.conf << 'EOF'
# Configuración de Hyprland - Rice System
monitor=,preferred,auto,1

input {
    kb_layout = es
    follow_mouse = 1
    touchpad {
        natural_scroll = no
    }
    sensitivity = 0
}

general {
    gaps_in = 5
    gaps_out = 20
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
    layout = dwindle
}

decoration {
    rounding = 10
    blur {
        enabled = true
        size = 3
        passes = 1
    }
    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

animations {
    enabled = yes
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# Variables de entorno
env = XCURSOR_SIZE,24
env = XCURSOR_THEME,Bibata-Wal

# Keybinds
$mainMod = SUPER
bind = $mainMod, Q, exec, kitty
bind = $mainMod, C, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, kitty -e ranger
bind = $mainMod, V, togglefloating,
bind = $mainMod, R, exec, rofi -show drun
bind = $mainMod, L, exec, hyprlock
bind = $mainMod SHIFT, E, exec, wlogout
bind = $mainMod, W, exec, wal -i ~/Rice/Wallpapers --random

# Autostart
exec-once = dunst &
exec-once = hyprpaper &
EOF
    echo "✅ Configuración de Hyprland creada"
else
    echo "✅ Configuración de Hyprland ya existe"
fi

# Aplicar colores si existe el script
if [ -f ~/Rice/Scripts/update-hyprland-config.sh ]; then
    ~/Rice/Scripts/update-hyprland-config.sh
    echo "✅ Colores de Hyprland actualizados"
fi
```

## 🧪 Verificación y Testing

### ✅ **Paso 11: Verificar Instalación**

```bash
echo "🧪 Verificando instalación completa..."

# Crear script de verificación temporal
cat > /tmp/verify_installation.sh << 'EOF'
#!/bin/bash

echo "=== VERIFICACIÓN DE INSTALACIÓN ==="

# Función para verificar comando
check_cmd() {
    if command -v "$1" &> /dev/null; then
        echo "✅ $1 instalado"
    else
        echo "❌ $1 NO instalado"
    fi
}

# Función para verificar archivo
check_file() {
    if [ -f "$1" ]; then
        echo "✅ $1 existe"
    else
        echo "❌ $1 NO existe"
    fi
}

echo "--- Comandos Principales ---"
check_cmd hyprland
check_cmd hyprlock
check_cmd wal
check_cmd kitty
check_cmd dunst
check_cmd rofi
check_cmd firefox
check_cmd spotify
check_cmd spicetify

echo -e "\n--- Herramientas de Cursor ---"
check_cmd cbmp
check_cmd ctgen

echo -e "\n--- Archivos de Configuración ---"
check_file ~/.config/hypr/hyprland.conf
check_file ~/.config/hypr/hyprlock.conf
check_file ~/.cache/wal/colors.sh
check_file ~/.face

echo -e "\n--- Archivos del Rice ---"
check_file ~/Rice/Scripts/setup_hyprlock.sh
check_file ~/Rice/Wallpapers/imagen_001.png

echo -e "\n--- Servicios ---"
if systemctl --user is-active pipewire &> /dev/null; then
    echo "✅ PipeWire activo"
else
    echo "❌ PipeWire inactivo"
fi

if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo "✅ Hyprland ejecutándose"
else
    echo "⚠️ Hyprland no detectado (normal si no estás en sesión Hyprland)"
fi

echo -e "\n=== FIN DE VERIFICACIÓN ==="
EOF

chmod +x /tmp/verify_installation.sh
/tmp/verify_installation.sh
rm /tmp/verify_installation.sh
```

### 🎮 **Paso 12: Testing Funcional**

```bash
echo "🎮 Realizando tests funcionales..."

# Test 1: Pywal
echo "📸 Test 1: Cambio de wallpaper"
if [ -d ~/Rice/Wallpapers ] && [ "$(ls -A ~/Rice/Wallpapers/*.png 2>/dev/null)" ]; then
    RANDOM_WALLPAPER=$(ls ~/Rice/Wallpapers/*.png | shuf -n 1)
    wal -i "$RANDOM_WALLPAPER"
    if [ $? -eq 0 ]; then
        echo "✅ Test pywal: OK"
    else
        echo "❌ Test pywal: FAIL"
    fi
else
    echo "⚠️ Test pywal: Sin wallpapers para testear"
fi

# Test 2: Hyprlock (solo configuración)
echo "🔒 Test 2: Configuración de hyprlock"
if [ -f ~/.config/hypr/hyprlock.conf ]; then
    echo "✅ Test hyprlock config: OK"
else
    echo "❌ Test hyprlock config: FAIL"
fi

# Test 3: Spicetify
echo "🎵 Test 3: Spicetify"
if command -v spicetify &> /dev/null; then
    spicetify config &> /dev/null
    if [ $? -eq 0 ]; then
        echo "✅ Test spicetify: OK"
    else
        echo "❌ Test spicetify: FAIL"
    fi
else
    echo "❌ Test spicetify: No instalado"
fi

# Test 4: Audio
echo "🔊 Test 4: Sistema de audio"
if command -v pactl &> /dev/null; then
    pactl info &> /dev/null
    if [ $? -eq 0 ]; then
        echo "✅ Test audio: OK"
    else
        echo "❌ Test audio: FAIL"
    fi
else
    echo "❌ Test audio: pactl no disponible"
fi

echo "🎯 Tests completados!"
```

## 📱 Post-Instalación

### 🔧 **Configuración Adicional Recomendada**

#### **Shell ZSH (opcional pero recomendado)**
```bash
echo "🐚 Configurando ZSH..."

# Cambiar shell por defecto
chsh -s $(which zsh)

# Instalar Oh My Zsh (opcional)
read -p "¿Instalar Oh My Zsh? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ Oh My Zsh instalado"
fi

# Configuración básica de zsh
if [ ! -f ~/.zshrc ]; then
    cat > ~/.zshrc << 'EOF'
# Configuración básica ZSH para Rice System
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Aliases para el rice
alias rice-update="cd ~/Rice/Scripts && ./update-all-colors.sh"
alias rice-cursor="cd ~/Rice/Scripts && ./update-hyprland-cursor.sh"
alias rice-wallpaper="wal -i ~/Rice/Wallpapers --random"

# PATH para herramientas
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
EOF
    echo "✅ Configuración básica de ZSH creada"
fi
```

#### **Autostart para Hyprland**
```bash
echo "🚀 Configurando autostart..."

# Crear script de autostart
mkdir -p ~/.config/hypr/scripts
cat > ~/.config/hypr/scripts/autostart.sh << 'EOF'
#!/bin/bash
# Autostart script para Rice System

# Servicios base
dunst &
hyprpaper &

# Aplicar último wallpaper de pywal
wal -R &

# Aplicaciones de usuario (opcional)
# firefox &
# spotify &

echo "✅ Autostart completado"
EOF

chmod +x ~/.config/hypr/scripts/autostart.sh

# Agregar a la configuración de Hyprland si no está
if ! grep -q "autostart.sh" ~/.config/hypr/hyprland.conf; then
    echo "exec-once = ~/.config/hypr/scripts/autostart.sh" >> ~/.config/hypr/hyprland.conf
    echo "✅ Autostart agregado a Hyprland"
fi
```

#### **Crear aliases útiles**
```bash
echo "⚡ Creando aliases útiles..."

# Crear script de aliases
cat > ~/Rice/Scripts/rice-aliases.sh << 'EOF'
#!/bin/bash
# Aliases útiles para Rice System

# Aplicar wallpaper aleatorio y actualizar todo
alias rice-random="wal -i ~/Rice/Wallpapers --random && cd ~/Rice/Scripts && ./update-all-colors.sh"

# Aplicar wallpaper específico
alias rice-wall="wal -i"

# Actualizar componentes individuales
alias rice-hyprlock="cd ~/Rice/Scripts && ./update_hyprlock_colors.sh"
alias rice-cursor="cd ~/Rice/Scripts && ./update-hyprland-cursor.sh"
alias rice-kitty="cd ~/Rice/Scripts && ./update-kitty-colors.sh"
alias rice-spotify="cd ~/Rice/Scripts && ./update-spicetify-colors.sh"
alias rice-firefox="cd ~/Rice/Scripts && ./update-firefox-all.sh"

# Utilidades
alias rice-colors="cat ~/.cache/wal/colors.sh"
alias rice-status="cd ~/Rice/Scripts && ./verify-dependencies.sh"

echo "Aliases para Rice System cargados!"
echo "Comandos disponibles:"
echo "  rice-random  - Wallpaper aleatorio + actualizar todo"
echo "  rice-wall    - Aplicar wallpaper específico"
echo "  rice-cursor  - Actualizar cursor"
echo "  rice-status  - Verificar estado del sistema"
EOF

chmod +x ~/Rice/Scripts/rice-aliases.sh

# Agregar a .zshrc o .bashrc
SHELL_RC="$HOME/.zshrc"
[ ! -f "$SHELL_RC" ] && SHELL_RC="$HOME/.bashrc"

if [ -f "$SHELL_RC" ]; then
    if ! grep -q "rice-aliases.sh" "$SHELL_RC"; then
        echo "source ~/Rice/Scripts/rice-aliases.sh" >> "$SHELL_RC"
        echo "✅ Aliases agregados a $SHELL_RC"
    fi
fi
```

### 📚 **Documentación Local**

```bash
echo "📚 Creando documentación local..."

# Crear guía de uso rápido
cat > ~/Rice/QUICK_START.md << 'EOF'
# 🚀 Guía de Uso Rápido - Rice System

## Comandos Esenciales

### 🎨 Cambiar Tema
```bash
# Wallpaper aleatorio
wal -i ~/Rice/Wallpapers --random

# Wallpaper específico
wal -i ~/Rice/Wallpapers/imagen_001.png

# Actualizar todos los componentes
cd ~/Rice/Scripts && ./update-all-colors.sh
```

### 🔒 Sistema de Bloqueo
```bash
# Bloquear pantalla
hyprlock

# Test de bloqueo con captura
~/Rice/Scripts/lockscreen.sh
```

### 🖱️ Cursor
```bash
# Regenerar cursor con colores actuales
cd ~/Rice/Scripts && ./update-hyprland-cursor.sh
```

### 🎵 Spotify
```bash
# Aplicar tema de Spotify
cd ~/.config/spicetify/Themes/pywal && ./apply-theme.sh
```

## Ubicaciones Importantes

- **Configuraciones**: `~/.config/`
- **Scripts**: `~/Rice/Scripts/`
- **Wallpapers**: `~/Rice/Wallpapers/`
- **Colores pywal**: `~/.cache/wal/`
- **Avatar**: `~/.face`

## Troubleshooting Rápido

### Problema: Cursor no se aplica
```bash
cd ~/Rice/Scripts
./update-hyprland-cursor.sh --check
```

### Problema: Spicetify no funciona
```bash
sudo chmod a+wr /opt/spotify /opt/spotify/Apps -R
spicetify backup apply
```

### Problema: Firefox CSS no se aplica
- Ir a `about:config`
- Buscar: `toolkit.legacyUserProfileCustomizations.stylesheets`
- Cambiar a: `true`
- Reiniciar Firefox
EOF

echo "✅ Documentación local creada en ~/Rice/QUICK_START.md"
```

## 🚑 Resolución de Problemas

### ❌ **Problemas Comunes Durante la Instalación**

#### **Error: No se puede instalar desde AUR**
```bash
# Verificar paru/yay
which paru || which yay

# Reinstalar paru si es necesario
cd /tmp && rm -rf paru
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si
```

#### **Error: cbmp o ctgen no funcionan**
```bash
# Verificar Node.js y npm
node --version && npm --version

# Reinstalar cbmp
npm uninstall -g cbmp
npm cache clean --force
npm install -g cbmp

# Verificar Rust y cargo
rustc --version && cargo --version

# Reinstalar ctgen
cargo uninstall ctgen
cargo install ctgen
```

#### **Error: Spicetify no puede modificar Spotify**
```bash
# Verificar que Spotify está instalado
spotify --version

# Aplicar permisos correctos
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
sudo chmod a+wr -R /opt/spotify/

# Verificar permisos
ls -la /opt/spotify/Apps/
```

#### **Error: PipeWire no funciona**
```bash
# Detener servicios previos
systemctl --user stop pulseaudio.service
systemctl --user disable pulseaudio.service

# Reiniciar PipeWire
systemctl --user restart pipewire.service
systemctl --user restart pipewire-pulse.service
systemctl --user restart wireplumber.service

# Verificar estado
systemctl --user status pipewire.service
pactl info
```

### 🔧 **Script de Diagnóstico Completo**

```bash
# Crear script de diagnóstico
cat > ~/Rice/Scripts/diagnose.sh << 'EOF'
#!/bin/bash
echo "🔍 DIAGNÓSTICO COMPLETO DEL SISTEMA"
echo "=================================="

echo -e "\n📋 INFORMACIÓN DEL SISTEMA"
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "Kernel: $(uname -r)"
echo "Usuario: $(whoami)"
echo "Desktop: $XDG_CURRENT_DESKTOP"
echo "Wayland: $WAYLAND_DISPLAY"

echo -e "\n🏗️ HYPRLAND"
if command -v hyprctl &> /dev/null; then
    echo "✅ Hyprland instalado"
    if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
        echo "✅ Hyprland ejecutándose"
        echo "Versión: $(hyprctl version | head -1)"
    else
        echo "⚠️ Hyprland no ejecutándose"
    fi
else
    echo "❌ Hyprland no instalado"
fi

echo -e "\n🎨 PYWAL"
if command -v wal &> /dev/null; then
    echo "✅ Pywal instalado ($(wal --version))"
    if [ -f ~/.cache/wal/colors.sh ]; then
        echo "✅ Colores generados"
        echo "Último wallpaper: $(grep wallpaper ~/.cache/wal/colors.sh | cut -d'"' -f2)"
    else
        echo "❌ Sin colores generados"
    fi
else
    echo "❌ Pywal no instalado"
fi

echo -e "\n🖱️ CURSOR"
echo "Tema actual: $XCURSOR_THEME"
echo "Tamaño: $XCURSOR_SIZE"
if command -v cbmp &> /dev/null && command -v ctgen &> /dev/null; then
    echo "✅ Herramientas de cursor disponibles"
    if [ -d ~/.local/share/icons/Bibata-Wal ]; then
        echo "✅ Cursor personalizado instalado"
    else
        echo "❌ Cursor personalizado no encontrado"
    fi
else
    echo "❌ Herramientas de cursor no disponibles"
fi

echo -e "\n🎵 SPOTIFY"
if command -v spotify &> /dev/null; then
    echo "✅ Spotify instalado"
    if command -v spicetify &> /dev/null; then
        echo "✅ Spicetify instalado ($(spicetify -v))"
        echo "Tema actual: $(spicetify config | grep current_theme | cut -d'=' -f2)"
    else
        echo "❌ Spicetify no instalado"
    fi
else
    echo "❌ Spotify no instalado"
fi

echo -e "\n🔊 AUDIO"
if systemctl --user is-active pipewire &> /dev/null; then
    echo "✅ PipeWire activo"
    if command -v pactl &> /dev/null; then
        echo "Server: $(pactl info | grep "Server Name" | cut -d':' -f2)"
    fi
else
    echo "❌ PipeWire inactivo"
fi

echo -e "\n📁 ARCHIVOS DEL RICE"
[ -d ~/Rice ] && echo "✅ Directorio Rice" || echo "❌ Directorio Rice"
[ -d ~/Rice/Scripts ] && echo "✅ Scripts" || echo "❌ Scripts"
[ -d ~/Rice/Wallpapers ] && echo "✅ Wallpapers ($(ls ~/Rice/Wallpapers/*.png 2>/dev/null | wc -l) archivos)" || echo "❌ Wallpapers"
[ -f ~/.face ] && echo "✅ Avatar usuario" || echo "❌ Avatar usuario"

echo -e "\n🧪 CONFIGURACIONES"
[ -f ~/.config/hypr/hyprland.conf ] && echo "✅ Hyprland config" || echo "❌ Hyprland config"
[ -f ~/.config/hypr/hyprlock.conf ] && echo "✅ Hyprlock config" || echo "❌ Hyprlock config"
[ -f ~/.config/kitty/kitty.conf ] && echo "✅ Kitty config" || echo "❌ Kitty config"

echo -e "\n🔚 DIAGNÓSTICO COMPLETADO"
EOF

chmod +x ~/Rice/Scripts/diagnose.sh
echo "✅ Script de diagnóstico creado: ~/Rice/Scripts/diagnose.sh"
```

### 📞 **Obtener Ayuda**

```bash
echo "📞 INFORMACIÓN DE SOPORTE"
echo "========================"
echo "Si encuentras problemas durante la instalación:"
echo ""
echo "1. Ejecuta el diagnóstico:"
echo "   ~/Rice/Scripts/diagnose.sh"
echo ""
echo "2. Verifica logs del sistema:"
echo "   journalctl --user -u hyprland -f"
echo "   journalctl --user -u pipewire -f"
echo ""
echo "3. Consulta la documentación:"
echo "   - README.md: Información general"
echo "   - DEPENDENCIES.md: Guía de dependencias"
echo "   - QUICK_START.md: Uso rápido"
echo ""
echo "4. Comunidad y recursos:"
echo "   - Hyprland Wiki: https://wiki.hyprland.org/"
echo "   - Arch Wiki: https://wiki.archlinux.org/"
echo "   - r/unixporn: https://reddit.com/r/unixporn"
```

## 🎉 **¡Instalación Completa!**

```bash
echo "🎉 ¡INSTALACIÓN COMPLETADA EXITOSAMENTE!"
echo "======================================="
echo ""
echo "✅ Sistema de rice Hyprland + Arch Linux configurado"
echo "✅ Tematización automática con pywal habilitada"
echo "✅ Cursor dinámico configurado"
echo "✅ Aplicaciones tematizadas"
echo ""
echo "🚀 PRÓXIMOS PASOS:"
echo "1. Reinicia tu sesión para aplicar todos los cambios"
echo "2. Inicia Hyprland"
echo "3. Prueba cambiar wallpaper: wal -i ~/Rice/Wallpapers --random"
echo "4. Prueba el bloqueo de pantalla: hyprlock"
echo "5. Lee la documentación en ~/Rice/QUICK_START.md"
echo ""
echo "🎨 ¡Disfruta de tu nuevo escritorio personalizado!"
```

---

## 📚 Referencias

- **[README.md](README.md)** - Documentación principal
- **[DEPENDENCIES.md](DEPENDENCIES.md)** - Guía completa de dependencias
- **[Hyprland Wiki](https://wiki.hyprland.org/)** - Documentación oficial
- **[Pywal GitHub](https://github.com/dylanaraps/pywal)** - Documentación pywal

---

**Creado por [hen-x](https://github.com/hen-x) • Guía de instalación completa**
