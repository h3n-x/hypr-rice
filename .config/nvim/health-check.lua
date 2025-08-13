-- Health check para la configuración personalizada de Neovim
-- Ejecutar con: :lua require('health-check')

local M = {}

-- Función para verificar si un comando existe
local function command_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Función para verificar si un archivo existe
local function file_exists(path)
  return vim.fn.filereadable(path) == 1
end

-- Función para verificar si un directorio existe
local function dir_exists(path)
  return vim.fn.isdirectory(path) == 1
end

-- Verificar pywal
local function check_pywal()
  print("🎨 Verificando pywal...")
  
  if not command_exists("wal") then
    print("❌ pywal no está instalado")
    return false
  end
  
  local colors_file = os.getenv("HOME") .. "/.cache/wal/colors"
  if not file_exists(colors_file) then
    print("⚠️  Archivo de colores de pywal no encontrado: " .. colors_file)
    print("   Ejecuta: wal -i /ruta/a/imagen")
    return false
  end
  
  print("✅ pywal configurado correctamente")
  return true
end

-- Verificar GitHub Copilot
local function check_copilot()
  print("\n🤖 Verificando GitHub Copilot...")
  
  if not command_exists("gh") then
    print("❌ GitHub CLI no está instalado")
    return false
  end
  
  -- Verificar autenticación de gh
  local result = vim.fn.system("gh auth status 2>&1")
  if vim.v.shell_error ~= 0 then
    print("⚠️  GitHub CLI no está autenticado")
    print("   Ejecuta: gh auth login")
    return false
  end
  
  print("✅ GitHub CLI autenticado")
  return true
end

-- Verificar herramientas de Python
local function check_python_tools()
  print("\n🐍 Verificando herramientas de Python...")
  
  local tools = {
    "python3",
    "black",
    "isort",
    "ruff",
    "mypy",
    "pytest"
  }
  
  local all_ok = true
  for _, tool in ipairs(tools) do
    if command_exists(tool) then
      print("✅ " .. tool .. " disponible")
    else
      print("❌ " .. tool .. " no encontrado")
      all_ok = false
    end
  end
  
  if all_ok then
    print("✅ Todas las herramientas de Python están disponibles")
  else
    print("⚠️  Instala las herramientas faltantes con: pip install --user <herramienta>")
  end
  
  return all_ok
end

-- Verificar herramientas de desarrollo web
local function check_web_tools()
  print("\n🌐 Verificando herramientas de desarrollo web...")
  
  local tools = {
    "node",
    "npm",
    "prettier",
    "jq"
  }
  
  local all_ok = true
  for _, tool in ipairs(tools) do
    if command_exists(tool) then
      print("✅ " .. tool .. " disponible")
    else
      print("❌ " .. tool .. " no encontrado")
      all_ok = false
    end
  end
  
  if all_ok then
    print("✅ Todas las herramientas de desarrollo web están disponibles")
  else
    print("⚠️  Instala las herramientas faltantes")
  end
  
  return all_ok
end

-- Verificar herramientas de bash
local function check_bash_tools()
  print("\n🐚 Verificando herramientas de Bash...")
  
  local tools = {
    "shellcheck",
    "shfmt"
  }
  
  local all_ok = true
  for _, tool in ipairs(tools) do
    if command_exists(tool) then
      print("✅ " .. tool .. " disponible")
    else
      print("❌ " .. tool .. " no encontrado")
      all_ok = false
    end
  end
  
  if all_ok then
    print("✅ Todas las herramientas de Bash están disponibles")
  else
    print("⚠️  Instala con: sudo pacman -S shellcheck shfmt")
  end
  
  return all_ok
end

-- Verificar LSP servers
local function check_lsp_servers()
  print("\n🔧 Verificando LSP servers...")
  
  local mason_path = vim.fn.stdpath("data") .. "/mason/bin"
  local servers = {
    "pylsp",
    "ruff-lsp", 
    "bash-language-server",
    "css-lsp",
    "tailwindcss-language-server",
    "json-lsp",
    "marksman",
    "yaml-language-server",
    "lua-language-server"
  }
  
  local all_ok = true
  for _, server in ipairs(servers) do
    local server_path = mason_path .. "/" .. server
    if file_exists(server_path) then
      print("✅ " .. server .. " instalado")
    else
      print("⚠️  " .. server .. " no encontrado")
      all_ok = false
    end
  end
  
  if not all_ok then
    print("⚠️  Ejecuta :Mason en Neovim para instalar LSP servers faltantes")
  else
    print("✅ Todos los LSP servers están instalados")
  end
  
  return all_ok
end

-- Verificar configuración de archivos
local function check_config_files()
  print("\n📁 Verificando archivos de configuración...")
  
  local config_dir = vim.fn.stdpath("config")
  local required_files = {
    "init.lua",
    "lua/config/lazy.lua",
    "lua/config/options.lua", 
    "lua/config/keymaps.lua",
    "lua/config/autocmds.lua",
    "lua/plugins/colorscheme.lua",
    "lua/plugins/copilot.lua",
    "lua/plugins/lsp.lua",
    "lua/plugins/treesitter.lua",
    "lua/plugins/extras.lua",
    "lua/plugins/core.lua"
  }
  
  local all_ok = true
  for _, file in ipairs(required_files) do
    local file_path = config_dir .. "/" .. file
    if file_exists(file_path) then
      print("✅ " .. file)
    else
      print("❌ " .. file .. " faltante")
      all_ok = false
    end
  end
  
  if all_ok then
    print("✅ Todos los archivos de configuración están presentes")
  else
    print("❌ Algunos archivos de configuración faltan")
  end
  
  return all_ok
end

-- Verificar plugins instalados
local function check_plugins()
  print("\n🔌 Verificando plugins...")
  
  local lazy_ok, lazy = pcall(require, "lazy")
  if not lazy_ok then
    print("❌ Lazy.nvim no está disponible")
    return false
  end
  
  local essential_plugins = {
    "LazyVim/LazyVim",
    "github/copilot.vim",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp"
  }
  
  local plugins = lazy.plugins()
  local plugin_names = {}
  for _, plugin in pairs(plugins) do
    table.insert(plugin_names, plugin.name or plugin[1])
  end
  
  local all_ok = true
  for _, plugin in ipairs(essential_plugins) do
    local found = false
    for _, installed in ipairs(plugin_names) do
      if installed:find(plugin) then
        found = true
        break
      end
    end
    
    if found then
      print("✅ " .. plugin)
    else
      print("❌ " .. plugin .. " no encontrado")
      all_ok = false
    end
  end
  
  if all_ok then
    print("✅ Todos los plugins esenciales están instalados")
  else
    print("⚠️  Ejecuta :Lazy sync para instalar plugins faltantes")
  end
  
  return all_ok
end

-- Función principal de health check
function M.check()
  print("🔍 HEALTH CHECK - Configuración Personalizada de Neovim")
  print("==================================================")
  print("Verificando configuración para:")
  print("• Python 🐍")
  print("• JSON 📄") 
  print("• Markdown 📝")
  print("• CSS/Tailwind 🎨")
  print("• Bash 🐚")
  print("==================================================\n")
  
  local results = {}
  results.pywal = check_pywal()
  results.copilot = check_copilot()
  results.python = check_python_tools()
  results.web = check_web_tools()
  results.bash = check_bash_tools()
  results.config = check_config_files()
  results.lsp = check_lsp_servers()
  results.plugins = check_plugins()
  
  print("\n📊 RESUMEN:")
  print("==================================================")
  
  local total = 0
  local passed = 0
  
  for category, result in pairs(results) do
    total = total + 1
    if result then
      passed = passed + 1
      print("✅ " .. category:upper())
    else
      print("❌ " .. category:upper())
    end
  end
  
  print("==================================================")
  print(string.format("📈 Resultado: %d/%d verificaciones pasaron", passed, total))
  
  if passed == total then
    print("🎉 ¡Configuración completamente funcional!")
  else
    print("⚠️  Revisa las verificaciones fallidas arriba")
    print("💡 Ejecuta el script de instalación: ~/.config/nvim/install.sh")
  end
  
  return passed == total
end

-- Comando para ejecutar desde Neovim
vim.api.nvim_create_user_command("HealthCheck", function()
  M.check()
end, { desc = "Verificar configuración personalizada" })

return M
