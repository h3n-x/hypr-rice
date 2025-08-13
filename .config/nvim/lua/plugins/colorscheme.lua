-- Configuración del colorscheme con integración pywal
-- Importa colores dinámicos desde ~/.cache/wal/

local M = {}

-- Función para leer colores de pywal
local function read_pywal_colors()
  local colors = {}
  local handle = io.open(os.getenv("HOME") .. "/.cache/wal/colors", "r")
  
  if handle then
    local i = 0
    for line in handle:lines() do
      colors["color" .. i] = line
      i = i + 1
    end
    handle:close()
  else
    -- Colores fallback si pywal no está disponible
    colors = {
      color0 = "#020104",
      color1 = "#3F2D81",
      color2 = "#4C3591",
      color3 = "#5B3CA1",
      color4 = "#5E48A5",
      color5 = "#7850C7",
      color6 = "#965ADD",
      color7 = "#d6a8e2",
      color8 = "#95759e",
      color9 = "#3F2D81",
      color10 = "#4C3591",
      color11 = "#5B3CA1",
      color12 = "#5E48A5",
      color13 = "#7850C7",
      color14 = "#965ADD",
      color15 = "#d6a8e2",
    }
  end
  
  -- Agregar colores especiales
  colors.background = colors.color0
  colors.foreground = colors.color7
  colors.cursor = colors.color7
  
  return colors
end

-- Función para aplicar colores pywal
local function apply_pywal_colors()
  local colors = read_pywal_colors()
  
  -- Configurar highlights básicos
  vim.api.nvim_set_hl(0, "Normal", { fg = colors.foreground, bg = colors.background })
  vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.foreground, bg = colors.color8 })
  vim.api.nvim_set_hl(0, "NormalNC", { fg = colors.foreground, bg = colors.background })
  
  -- Cursor
  vim.api.nvim_set_hl(0, "Cursor", { fg = colors.background, bg = colors.cursor })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.color8 })
  vim.api.nvim_set_hl(0, "CursorColumn", { bg = colors.color8 })
  
  -- Selección
  vim.api.nvim_set_hl(0, "Visual", { bg = colors.color1 })
  vim.api.nvim_set_hl(0, "VisualNOS", { bg = colors.color1 })
  
  -- Búsqueda
  vim.api.nvim_set_hl(0, "Search", { fg = colors.background, bg = colors.color3 })
  vim.api.nvim_set_hl(0, "IncSearch", { fg = colors.background, bg = colors.color5 })
  
  -- Línea de estado
  vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.foreground, bg = colors.color8 })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = colors.color8, bg = colors.color0 })
  
  -- Números de línea
  vim.api.nvim_set_hl(0, "LineNr", { fg = colors.color8 })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.color6, bold = true })
  
  -- Fold
  vim.api.nvim_set_hl(0, "Folded", { fg = colors.color8, bg = colors.color0 })
  vim.api.nvim_set_hl(0, "FoldColumn", { fg = colors.color8, bg = colors.background })
  
  -- Sign column
  vim.api.nvim_set_hl(0, "SignColumn", { fg = colors.color8, bg = colors.background })
  
  -- Splits
  vim.api.nvim_set_hl(0, "VertSplit", { fg = colors.color8 })
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.color8 })
  
  -- Tabs
  vim.api.nvim_set_hl(0, "TabLine", { fg = colors.color8, bg = colors.color0 })
  vim.api.nvim_set_hl(0, "TabLineFill", { fg = colors.color8, bg = colors.color0 })
  vim.api.nvim_set_hl(0, "TabLineSel", { fg = colors.foreground, bg = colors.color1 })
  
  -- Popup menu
  vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.foreground, bg = colors.color8 })
  vim.api.nvim_set_hl(0, "PmenuSel", { fg = colors.background, bg = colors.color6 })
  vim.api.nvim_set_hl(0, "PmenuSbar", { bg = colors.color8 })
  vim.api.nvim_set_hl(0, "PmenuThumb", { bg = colors.color6 })
  
  -- Diff
  vim.api.nvim_set_hl(0, "DiffAdd", { fg = colors.color2, bg = colors.background })
  vim.api.nvim_set_hl(0, "DiffChange", { fg = colors.color3, bg = colors.background })
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = colors.color1, bg = colors.background })
  vim.api.nvim_set_hl(0, "DiffText", { fg = colors.color4, bg = colors.background })
  
  -- Syntax highlighting
  vim.api.nvim_set_hl(0, "Comment", { fg = colors.color8, italic = true })
  vim.api.nvim_set_hl(0, "Constant", { fg = colors.color1 })
  vim.api.nvim_set_hl(0, "String", { fg = colors.color2 })
  vim.api.nvim_set_hl(0, "Character", { fg = colors.color2 })
  vim.api.nvim_set_hl(0, "Number", { fg = colors.color1 })
  vim.api.nvim_set_hl(0, "Boolean", { fg = colors.color1 })
  vim.api.nvim_set_hl(0, "Float", { fg = colors.color1 })
  vim.api.nvim_set_hl(0, "Identifier", { fg = colors.foreground })
  vim.api.nvim_set_hl(0, "Function", { fg = colors.color4 })
  vim.api.nvim_set_hl(0, "Statement", { fg = colors.color5 })
  vim.api.nvim_set_hl(0, "Conditional", { fg = colors.color5 })
  vim.api.nvim_set_hl(0, "Repeat", { fg = colors.color5 })
  vim.api.nvim_set_hl(0, "Label", { fg = colors.color5 })
  vim.api.nvim_set_hl(0, "Operator", { fg = colors.color6 })
  vim.api.nvim_set_hl(0, "Keyword", { fg = colors.color5 })
  vim.api.nvim_set_hl(0, "Exception", { fg = colors.color5 })
  vim.api.nvim_set_hl(0, "PreProc", { fg = colors.color3 })
  vim.api.nvim_set_hl(0, "Include", { fg = colors.color3 })
  vim.api.nvim_set_hl(0, "Define", { fg = colors.color3 })
  vim.api.nvim_set_hl(0, "Macro", { fg = colors.color3 })
  vim.api.nvim_set_hl(0, "PreCondit", { fg = colors.color3 })
  vim.api.nvim_set_hl(0, "Type", { fg = colors.color6 })
  vim.api.nvim_set_hl(0, "StorageClass", { fg = colors.color6 })
  vim.api.nvim_set_hl(0, "Structure", { fg = colors.color6 })
  vim.api.nvim_set_hl(0, "Typedef", { fg = colors.color6 })
  vim.api.nvim_set_hl(0, "Special", { fg = colors.color4 })
  vim.api.nvim_set_hl(0, "SpecialChar", { fg = colors.color4 })
  vim.api.nvim_set_hl(0, "Tag", { fg = colors.color4 })
  vim.api.nvim_set_hl(0, "Delimiter", { fg = colors.foreground })
  vim.api.nvim_set_hl(0, "SpecialComment", { fg = colors.color4 })
  vim.api.nvim_set_hl(0, "Debug", { fg = colors.color4 })
  vim.api.nvim_set_hl(0, "Underlined", { fg = colors.color4, underline = true })
  vim.api.nvim_set_hl(0, "Error", { fg = colors.color1, bold = true })
  vim.api.nvim_set_hl(0, "Todo", { fg = colors.color3, bold = true })
  
  -- LSP highlights
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.color1 })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = colors.color3 })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = colors.color4 })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = colors.color6 })
  
  -- Treesitter highlights específicos para nuestros lenguajes
  -- Python
  vim.api.nvim_set_hl(0, "@keyword.python", { fg = colors.color5 })
  vim.api.nvim_set_hl(0, "@function.python", { fg = colors.color4 })
  vim.api.nvim_set_hl(0, "@string.python", { fg = colors.color2 })
  
  -- JSON
  vim.api.nvim_set_hl(0, "@property.json", { fg = colors.color6 })
  vim.api.nvim_set_hl(0, "@string.json", { fg = colors.color2 })
  
  -- CSS
  vim.api.nvim_set_hl(0, "@property.css", { fg = colors.color6 })
  vim.api.nvim_set_hl(0, "@number.css", { fg = colors.color1 })
  vim.api.nvim_set_hl(0, "@string.css", { fg = colors.color2 })
  
  -- Markdown
  vim.api.nvim_set_hl(0, "@markup.heading.markdown", { fg = colors.color5, bold = true })
  vim.api.nvim_set_hl(0, "@markup.link.markdown", { fg = colors.color4, underline = true })
  vim.api.nvim_set_hl(0, "@markup.raw.markdown", { fg = colors.color2 })
  
  -- Bash
  vim.api.nvim_set_hl(0, "@keyword.bash", { fg = colors.color5 })
  vim.api.nvim_set_hl(0, "@string.bash", { fg = colors.color2 })
end

return {
  -- Configuración básica de LazyVim
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        apply_pywal_colors()
      end,
    },
  },
  
  -- Plugin para soporte de pywal (opcional, como fallback)
  {
    "dylanaraps/wal.vim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Aplicar colores de pywal al cargar
      apply_pywal_colors()
      
      -- Crear comando para recargar colores
      vim.api.nvim_create_user_command("PywalReload", function()
        apply_pywal_colors()
        vim.notify("Pywal colors reloaded!", vim.log.levels.INFO)
      end, { desc = "Reload pywal colors" })
      
      -- Auto-recargar cuando cambien los colores de pywal
      local pywal_group = vim.api.nvim_create_augroup("PywalColors", { clear = true })
      vim.api.nvim_create_autocmd({ "FocusGained", "VimEnter" }, {
        group = pywal_group,
        callback = function()
          local handle = io.open(os.getenv("HOME") .. "/.cache/wal/colors", "r")
          if handle then
            handle:close()
            apply_pywal_colors()
          end
        end,
      })
    end,
  },
  
  -- TokyoNight como tema de respaldo
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
    },
  },
}
