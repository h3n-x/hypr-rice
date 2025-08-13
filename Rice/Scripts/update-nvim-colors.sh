#!/bin/bash

# --------------------------------------------------------------
# Proyecto creado por hen-x
# GitHub: https://github.com/hen-x
# --------------------------------------------------------------

# Rutas de archivos
PYWAL_COLORS="$HOME/.cache/wal/colors.scss"
NVIM_COLORSCHEME="$HOME/.config/nvim/lua/plugins/colorscheme.lua"

# Verificar que existen los archivos necesarios
if [[ ! -f "$PYWAL_COLORS" ]]; then
  echo "Error: No se encontró el archivo de colores de pywal en $PYWAL_COLORS"
  exit 1
fi

if [[ ! -f "$NVIM_COLORSCHEME" ]]; then
  echo "Error: No se encontró el archivo de colorscheme de Neovim en $NVIM_COLORSCHEME"
  exit 1
fi

echo "Actualizando colores de Neovim con pywal..."

# Extraer colores del archivo SCSS de pywal
background=$(grep '\$background:' "$PYWAL_COLORS" | sed 's/.*: *//;s/;//')
foreground=$(grep '\$foreground:' "$PYWAL_COLORS" | sed 's/.*: *//;s/;//')
color0=$(grep '\$color0:' "$PYWAL_COLORS" | sed 's/.*: *//;s/;//')
color1=$(grep '\$color1:' "$PYWAL_COLORS" | sed 's/.*: *//;s/;//')
color2=$(grep '\$color2:' "$PYWAL_COLORS" | sed 's/.*: *//;s/;//')
color3=$(grep '\$color3:' "$PYWAL_COLORS" | sed 's/.*: *//;s/;//')
color4=$(grep '\$color4:' "$PYWAL_COLORS" | sed 's/.*: *//;s/;//')
color5=$(grep '\$color5:' "$PYWAL_COLORS" | sed 's/.*: *//;s/;//')
color6=$(grep '\$color6:' "$PYWAL_COLORS" | sed 's/.*: *//;s/;//')
color7=$(grep '\$color7:' "$PYWAL_COLORS" | sed 's/.*: *//;s/;//')
color8=$(grep '\$color8:' "$PYWAL_COLORS" | sed 's/.*: *//;s/;//')

# Mostrar colores extraídos
echo "Colores extraídos:"
echo "  Background: $background"
echo "  Foreground: $foreground"
echo "  Color0-8: $color0 $color1 $color2 $color3 $color4 $color5 $color6 $color7 $color8"

# Crear archivo temporal con la nueva configuración
cat >/tmp/nvim_colorscheme_new.lua <<EOF
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha",
			background = {
				light = "latte",
				dark = "mocha",
			},
			transparent_background = false,
			show_end_of_buffer = false,
			term_colors = true,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.15,
			},
			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			color_overrides = {
				mocha = {
					base = "$background", -- background
					mantle = "$background", -- background
					crust = "$background", -- background

					surface0 = "$color1", -- color1
					surface1 = "$color2", -- color2
					surface2 = "$color3", -- color3

					overlay0 = "$color4", -- color4
					overlay1 = "$color5", -- color5
					overlay2 = "$color6", -- color6

					text = "$foreground", -- foreground
					subtext1 = "$foreground", -- foreground
					subtext0 = "$color8", -- color8

					lavender = "$color6", -- color6
					blue = "$color2", -- color2
					sapphire = "$color3", -- color3
					sky = "$color5", -- color5
					teal = "$color1", -- color1
					green = "$color6", -- color6
					yellow = "$color7", -- color7
					peach = "$color4", -- color4
					maroon = "$color1", -- color1
					red = "$color6", -- color6
					mauve = "$color5", -- color5
					pink = "$color7", -- color7
					flamingo = "$color8", -- color8
					rosewater = "$color7", -- color7
				},
			},
			default_integrations = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = true,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
				},
				telescope = {
					enabled = true,
				},
				fzf = true,
				flash = true,
				alpha = true,
				dashboard = true,
				which_key = true,
				indent_blankline = {
					enabled = true,
					scope_color = "",
					colored_indent_levels = false,
				},
				markdown = true,
				mason = true,
				lsp_saga = true,
				dap = true,
				dap_ui = true,
				barbecue = {
					dim_dirname = true,
					bold_basename = true,
					dim_context = false,
					alt_background = false,
				},
			},
		},
	},

	-- Configure LazyVim to use catppuccin
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin",
		},
	},
}
EOF

# Mover el archivo temporal al destino final
mv /tmp/nvim_colorscheme_new.lua "$NVIM_COLORSCHEME"

echo "✓ Colores de Neovim actualizados exitosamente!"
echo "Los cambios se aplicarán la próxima vez que reinicies Neovim."

# Opcional: Recargar Neovim si está corriendo
if pgrep -x "nvim" >/dev/null; then
  echo "Neovim está corriendo. Puedes recargar la configuración con :source % o reiniciar Neovim."
fi
