-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
  spec = {
    -- Importar LazyVim y sus plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    
    -- Importar extras específicos para nuestros lenguajes
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
    
    -- Importar nuestros plugins personalizados
    { import = "plugins" },
  },
  defaults = {
    -- Por defecto, solo los plugins de LazyVim serán lazy-loaded
    lazy = false,
    -- Usar siempre la última versión git
    version = false,
  },
  install = { 
    colorscheme = { "pywal", "tokyonight", "habamax" } 
  },
  checker = {
    enabled = true, -- verificar actualizaciones periódicamente
    notify = false, -- no notificar actualizaciones
  },
  performance = {
    rtp = {
      -- deshabilitar algunos plugins rtp
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
