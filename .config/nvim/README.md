# Configuración Personalizada de Neovim con LazyVim

Esta es una configuración completa y personalizada de Neovim usando LazyVim, optimizada para desarrollo en **Python**, **JSON**, **Markdown**, **CSS/Tailwind CSS**, y **Bash** en **Arch Linux** con **Hyprland**.

## 🌟 Características Principales

### 🎨 Integración con Pywal
- Colores dinámicos que se actualizan automáticamente con pywal
- Soporte para archivos de colores en `~/.cache/wal/colors`
- Comando `:PywalReload` para recargar colores manualmente
- Keymap `<leader>wr` para recargar colores rápidamente

### 🤖 GitHub Copilot
- Autocompletado inteligente con IA
- Integración completa con nvim-cmp
- CopilotChat para conversaciones con IA
- Prompts específicos para cada lenguaje
- Keymaps optimizados para aceptar sugerencias

### 🛠️ LSP y Herramientas por Lenguaje

#### Python 🐍
- **LSP**: pylsp + ruff (configuración oficial LazyVim)
- **Formateo**: black + isort
- **Linting**: ruff + mypy
- **Debug**: nvim-dap con debugpy
- **Testing**: neotest con pytest
- **Keymaps**: `<leader>rp` (ejecutar), `<leader>tt` (test)

#### Bash 🐚
- **LSP**: bashls
- **Linting**: shellcheck
- **Formateo**: shfmt
- **Keymaps**: `<leader>rb` (ejecutar), `<leader>cx` (hacer ejecutable)

#### CSS/Tailwind 🎨
- **LSP**: cssls + tailwindcss
- **Formateo**: prettier
- **Linting**: stylelint
- **Colorizer**: mostrar colores en tiempo real
- **IntelliSense**: autocompletado de clases Tailwind

#### JSON 📄
- **LSP**: jsonls con esquemas
- **Formateo**: jq + prettier
- **Validación**: esquemas automáticos para package.json, tsconfig, etc.
- **Keymaps**: `<leader>jq` (formatear), `<leader>jv` (validar)

#### Markdown 📝
- **LSP**: marksman
- **Preview**: markdown-preview + glow
- **Formateo**: prettier
- **TOC**: generación automática de tabla de contenidos
- **Keymaps**: `<leader>mp` (preview), `<leader>mt` (TOC)

## 📁 Estructura de Archivos

```
~/.config/nvim/
├── init.lua                    # Punto de entrada
├── lua/
│   ├── config/
│   │   ├── autocmds.lua       # Auto comandos personalizados
│   │   ├── keymaps.lua        # Mapeos de teclas
│   │   ├── lazy.lua           # Bootstrap de lazy.nvim
│   │   └── options.lua        # Opciones de Neovim
│   └── plugins/
│       ├── colorscheme.lua    # Integración con pywal
│       ├── copilot.lua        # GitHub Copilot
│       ├── core.lua           # Configuración básica LazyVim
│       ├── extras.lua         # Herramientas adicionales
│       ├── lsp.lua            # Configuración LSP
│       └── treesitter.lua     # Highlighting y autocompletado
└── README.md                  # Este archivo
```

## ⚡ Instalación Rápida

### Prerrequisitos

1. **Neovim >= 0.10.0**
```bash
sudo pacman -S neovim
```

2. **Dependencias básicas**
```bash
# Herramientas esenciales
sudo pacman -S git curl unzip tar gzip

# Ripgrep y fd para búsquedas
sudo pacman -S ripgrep fd

# Node.js para algunos LSP servers
sudo pacman -S nodejs npm

# Python y herramientas
sudo pacman -S python python-pip
pip install --user debugpy black isort ruff mypy pytest

# Herramientas de formateo
sudo pacman -S jq prettier shellcheck shfmt

# Para Markdown preview
sudo pacman -S glow
```

3. **Pywal** (para colores dinámicos)
```bash
sudo pacman -S python-pywal
```

4. **Fuentes con iconos**
```bash
sudo pacman -S ttf-nerd-fonts-symbols-mono
# O instala tu fuente Nerd Font preferida
```

### Instalación

1. **Respaldar configuración existente** (si la tienes):
```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup
```

2. **Los archivos ya están en su lugar** en `/home/h3n/.config/nvim/`

3. **Primera ejecución**:
```bash
nvim
```

LazyVim instalará automáticamente todos los plugins y herramientas necesarias.

## 🔧 Configuración Adicional

### GitHub Copilot

1. **Instalar GitHub CLI**:
```bash
sudo pacman -S github-cli
```

2. **Autenticarse**:
```bash
gh auth login
```

3. **Activar Copilot** en Neovim:
```
:Copilot auth
```

### Pywal

1. **Generar colores** desde tu wallpaper:
```bash
wal -i /ruta/a/tu/wallpaper.jpg
```

2. **Recargar colores** en Neovim:
```
:PywalReload
```
O usar el keymap `<leader>wr`

## ⌨️ Keymaps Principales

### Generales
- `<Space>` - Leader key
- `<C-s>` - Guardar archivo
- `<C-h/j/k/l>` - Navegar entre ventanas
- `<S-h/l>` - Navegar entre buffers
- `<leader>ff` - Buscar archivos
- `<leader>fg` - Buscar texto
- `<leader>qq` - Salir

### Copilot
- `<C-J>` - Aceptar sugerencia
- `<C-L>` - Aceptar palabra
- `<C-]>` - Siguiente sugerencia
- `<C-[>` - Sugerencia anterior
- `<leader>aa` - Toggle Copilot Chat
- `<leader>ae` - Explicar código
- `<leader>af` - Corregir código
- `<leader>ao` - Optimizar código

### Por Lenguaje

#### Python
- `<leader>rp` - Ejecutar archivo Python
- `<leader>tt` - Ejecutar test
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue debug

#### Bash
- `<leader>rb` - Ejecutar script
- `<leader>cx` - Hacer ejecutable

#### JSON
- `<leader>jq` - Formatear con jq
- `<leader>jv` - Validar JSON

#### CSS
- `<leader>cc` - Toggle colorizer
- `<leader>cs` - Formatear CSS

#### Markdown
- `<leader>mp` - Preview
- `<leader>mg` - Glow preview
- `<leader>mt` - Generar TOC

### LSP
- `gd` - Ir a definición
- `gr` - Referencias
- `K` - Hover info
- `<leader>ca` - Code actions
- `<leader>cr` - Rename
- `<leader>cf` - Format
- `]d` / `[d` - Siguiente/anterior diagnóstico

## 🎨 Personalización

### Cambiar Colores

Los colores se actualizan automáticamente desde pywal. Para cambiar:

1. Generar nuevos colores:
```bash
wal -i nueva_imagen.jpg
```

2. Recargar en Neovim:
```
:PywalReload
```

### Agregar Nuevos Lenguajes

1. Editar `lua/plugins/lsp.lua` para agregar nuevos servidores LSP
2. Actualizar `lua/plugins/treesitter.lua` para nuevos parsers
3. Modificar `lua/config/autocmds.lua` para configuraciones específicas

### Personalizar Keymaps

Editar `lua/config/keymaps.lua` para agregar o modificar keymaps.

## 🔍 Troubleshooting

### Error al iniciar Neovim
```bash
# Limpiar cache y reiniciar
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
nvim
```

### LSP no funciona
```bash
# Verificar Mason
:Mason
# Reinstalar server problemático
:MasonInstall python-lsp-server
```

### Copilot no funciona
```bash
# Verificar autenticación
:Copilot status
# Re-autenticar si es necesario
:Copilot auth
```

### Colores de pywal no se aplican
```bash
# Verificar que pywal está instalado y configurado
wal --version
ls ~/.cache/wal/colors
# Recargar en Neovim
:PywalReload
```

## 📚 Comandos Útiles

- `:Lazy` - Administrar plugins
- `:Mason` - Administrar LSP servers
- `:LspInfo` - Info de LSP servers activos
- `:Telescope` - Explorar con Telescope
- `:ConformInfo` - Info de formatters
- `:PywalReload` - Recargar colores pywal
- `:CopilotToggle` - Toggle Copilot
- `:Glow` - Preview Markdown con Glow

## 🚀 Funciones Avanzadas

### Auto-formato al Guardar
Habilitado por defecto para todos los lenguajes configurados.

### Diagnostics en Tiempo Real
Los errores y warnings se muestran en tiempo real mientras escribes.

### Snippets Personalizados
Snippets específicos para cada lenguaje incluidos y configurados.

### Integración con Git
Signos de Git en la columna lateral y comandos integrados.

### Session Management
Las sesiones se guardan automáticamente y se pueden restaurar.

---

¡Disfruta de tu nueva configuración de Neovim! 🎉

Para soporte adicional o reportar problemas, revisa los logs:
```bash
:messages
```

O abre un debug log:
```bash
nvim --log-file debug.log
```
