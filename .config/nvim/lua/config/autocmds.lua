-- Auto Commands personalizados
-- Configuración específica para los lenguajes que utilizamos

local function augroup(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- Verificar si necesitamos recargar el archivo cuando cambia
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Resaltar al copiar
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- Redimensionar splits si la ventana se redimensiona
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Ir a la última posición cuando se abre un buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].custom_last_loc then
      return
    end
    vim.b[buf].custom_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Cerrar algunos tipos de archivo con <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- Wrap y spell checking para archivos de texto
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Configuraciones específicas para Python
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("python_config"),
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
    -- Configurar textwidth para PEP 8
    vim.opt_local.textwidth = 88
    vim.opt_local.colorcolumn = "88"
  end,
})

-- Configuraciones específicas para JSON
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("json_config"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- Configuraciones específicas para CSS/SCSS
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("css_config"),
  pattern = { "css", "scss", "sass" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.iskeyword:append("-")
  end,
})

-- Configuraciones específicas para Markdown
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("markdown_config"),
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.linebreak = true
    vim.opt_local.conceallevel = 2
    vim.opt_local.textwidth = 80
  end,
})

-- Configuraciones específicas para Bash
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("bash_config"),
  pattern = { "sh", "bash", "zsh" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- Auto crear directorio cuando se guarda un archivo
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Recargar colores de pywal automáticamente
vim.api.nvim_create_autocmd("Signal", {
  group = augroup("pywal_reload"),
  pattern = "SIGUSR1",
  callback = function()
    vim.cmd("source ~/.config/nvim/lua/plugins/colorscheme.lua")
    vim.cmd("colorscheme pywal")
  end,
})

-- Formateo automático al guardar para nuestros lenguajes
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("format_on_save"),
  pattern = { "*.py", "*.json", "*.css", "*.scss", "*.md", "*.sh" },
  callback = function()
    if vim.g.autoformat then
      LazyVim.format({ force = true })
    end
  end,
})

-- Configurar indentación específica para diferentes archivos de configuración
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("config_files"),
  pattern = { "yaml", "yml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- Configuración específica para archivos de Hyprland
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("hyprland_config"),
  pattern = { "*/hypr/*.conf", "hyprland.conf" },
  callback = function()
    vim.bo.filetype = "hyprlang"
  end,
})
