-- Opciones de Neovim personalizadas
-- Configuración optimizada para Arch Linux + Hyprland

-- Configuración del líder
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- LazyVim auto format
vim.g.autoformat = true

-- Snacks animations
vim.g.snacks_animate = true

-- LazyVim picker (usar telescope)
vim.g.lazyvim_picker = "telescope"

-- LazyVim completion engine (usar nvim-cmp)
vim.g.lazyvim_cmp = "nvim-cmp"

-- Usar AI cmp si está disponible
vim.g.ai_cmp = true

-- Configuración de detección de root
vim.g.root_spec = { "lsp", { ".git", "lua", "package.json", "pyproject.toml", "setup.py" }, "cwd" }

-- Servidores LSP a ignorar para detección de root
vim.g.root_lsp_ignore = { "copilot" }

-- Ocultar advertencias de depreciación
vim.g.deprecation_warnings = false

-- Mostrar symbols de Trouble en lualine
vim.g.trouble_lualine = true

-- Configuraciones locales
local opt = vim.opt

-- Configuraciones básicas
opt.autowrite = true -- Auto guardar
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sincronizar con clipboard del sistema
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Ocultar markup para bold e italic
opt.confirm = true -- Confirmar para guardar cambios antes de salir
opt.cursorline = true -- Resaltar línea actual
opt.expandtab = true -- Usar espacios en lugar de tabs
opt.fillchars = {
  foldopen = "-",
  foldclose = "+",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Configuraciones específicas para nuestros lenguajes
opt.foldlevel = 99
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.jumpoptions = "view"
opt.laststatus = 3 -- statusline global
opt.linebreak = true -- Dividir líneas en puntos convenientes
opt.list = true -- Mostrar algunos caracteres invisibles
opt.mouse = "a" -- Habilitar modo ratón
opt.number = true -- Números de línea
opt.pumblend = 10 -- Transparencia popup
opt.pumheight = 10 -- Máximo número de entradas en popup
opt.relativenumber = true -- Números de línea relativos
opt.ruler = false -- Deshabilitar ruler por defecto
opt.scrolloff = 4 -- Líneas de contexto
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Redondear indent
opt.shiftwidth = 2 -- Tamaño de un indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- No mostrar modo (tenemos statusline)
opt.sidescrolloff = 8 -- Columnas de contexto
opt.signcolumn = "yes" -- Siempre mostrar signcolumn
opt.smartcase = true -- No ignorar case con mayúsculas
opt.smartindent = true -- Insertar indents automáticamente
opt.spelllang = { "en", "es" } -- Idiomas para spell checking
opt.splitbelow = true -- Nuevas ventanas abajo
opt.splitkeep = "screen"
opt.splitright = true -- Nuevas ventanas a la derecha
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.tabstop = 2 -- Número de espacios que cuenta un tab
opt.termguicolors = true -- Soporte true color
opt.timeoutlen = 300 -- Tiempo para trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Guardar swap file y trigger CursorHold
opt.virtualedit = "block" -- Permitir cursor donde no hay texto en visual block
opt.wildmode = "longest:full,full" -- Modo de completado command-line
opt.winminwidth = 5 -- Ancho mínimo de ventana
opt.wrap = false -- Deshabilitar line wrap

-- Configuraciones específicas para Neovim >= 0.10
if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
  opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
  opt.foldmethod = "expr"
  opt.foldtext = ""
else
  opt.foldmethod = "indent"
  opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
end

-- Configuración específica para Markdown
vim.g.markdown_recommended_style = 0

-- Configuraciones específicas para Python
vim.g.python3_host_prog = "/usr/bin/python3"

-- Configuraciones específicas para archivos de configuración
vim.filetype.add({
  extension = {
    conf = "dosini",
    scss = "scss",
  },
  filename = {
    [".env"] = "sh",
    ["pyproject.toml"] = "toml",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "sh",
  },
})

-- Configuración de commentstring para diferentes tipos de archivo
-- Fallback cuando ts-comments no esté disponible
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    local commentstrings = {
      lua = "-- %s",
      python = "# %s",
      sh = "# %s",
      bash = "# %s",
      zsh = "# %s",
      fish = "# %s",
      css = "/* %s */",
      scss = "/* %s */",
      sass = "/* %s */",
      less = "/* %s */",
      html = "<!-- %s -->",
      xml = "<!-- %s -->",
      javascript = "// %s",
      typescript = "// %s",
      javascriptreact = "// %s",
      typescriptreact = "// %s",
      vue = "// %s",
      svelte = "// %s",
      json = "",
      jsonc = "// %s",
      yaml = "# %s",
      yml = "# %s",
      toml = "# %s",
      ini = "# %s",
      dosini = "# %s",
      conf = "# %s",
      vim = '" %s',
      vimdoc = '" %s',
      markdown = "<!-- %s -->",
      tex = "% %s",
      latex = "% %s",
      rust = "// %s",
      go = "// %s",
      c = "// %s",
      cpp = "// %s",
      java = "// %s",
      php = "// %s",
      ruby = "# %s",
      perl = "# %s",
      r = "# %s",
      matlab = "% %s",
      sql = "-- %s",
      gitcommit = "# %s",
      gitrebase = "# %s",
      gitconfig = "# %s",
      dockerfile = "# %s",
      make = "# %s",
      cmake = "# %s",
    }
    
    local ft = vim.bo.filetype
    if commentstrings[ft] and vim.bo.commentstring == "" then
      vim.bo.commentstring = commentstrings[ft]
    end
  end,
})
