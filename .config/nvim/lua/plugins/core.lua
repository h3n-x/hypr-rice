-- Configuración del core de LazyVim
-- Configuraciones básicas y personalizaciones

return {
  -- Configuración básica de LazyVim
  {
    "LazyVim/LazyVim",
    opts = {
      -- Usar nuestro colorscheme personalizado con pywal
      colorscheme = function()
        -- El colorscheme se configura en colorscheme.lua
        if pcall(require, "wal") then
          vim.cmd("colorscheme wal")
        else
          vim.cmd("colorscheme tokyonight")
        end
      end,
      -- Configuraciones de iconos
      icons = {
        misc = {
          dots = "󰇘",
        },
        ft = {
          octo = "",
          python = "",
          json = "",
          css = "",
          scss = "",
          markdown = "",
          bash = "",
          sh = "",
          zsh = "",
        },
        dap = {
          Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
          Breakpoint          = " ",
          BreakpointCondition = " ",
          BreakpointRejected  = { " ", "DiagnosticError" },
          LogPoint            = ".>",
        },
        diagnostics = {
          Error = " ",
          Warn  = " ",
          Hint  = " ",
          Info  = " ",
        },
        git = {
          added    = " ",
          modified = " ",
          removed  = " ",
        },
        kinds = {
          Array         = " ",
          Boolean       = "󰨙 ",
          Class         = " ",
          Codeium       = "󰘦 ",
          Color         = " ",
          Control       = " ",
          Collapsed     = " ",
          Constant      = "󰏿 ",
          Constructor   = " ",
          Copilot       = " ",
          Enum          = " ",
          EnumMember    = " ",
          Event         = " ",
          Field         = " ",
          File          = " ",
          Folder        = " ",
          Function      = "󰊕 ",
          Interface     = " ",
          Key           = " ",
          Keyword       = " ",
          Method        = "󰊕 ",
          Module        = " ",
          Namespace     = "󰦮 ",
          Null          = " ",
          Number        = "󰎠 ",
          Object        = " ",
          Operator      = " ",
          Package       = " ",
          Property      = " ",
          Reference     = " ",
          Snippet       = "󱄽 ",
          String        = " ",
          Struct        = "󰆼 ",
          Text          = " ",
          TypeParameter = " ",
          Unit          = " ",
          Value         = " ",
          Variable      = "󰀫 ",
        },
      },
      -- Filtros de kind específicos para nuestros lenguajes
      kind_filter = {
        default = {
          "Class",
          "Constructor",
          "Enum",
          "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          "Package",
          "Property",
          "Struct",
          "Trait",
        },
        markdown = false,
        help = false,
        python = {
          "Class",
          "Constructor",
          "Enum",
          "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          "Property",
          "Struct",
          "Trait",
          "Variable",
        },
        css = {
          "Property",
          "Value",
          "Color",
          "Function",
          "Variable",
        },
        json = {
          "Property",
          "Value",
          "String",
          "Number",
          "Boolean",
          "Array",
          "Object",
        },
        bash = {
          "Function",
          "Variable",
          "Keyword",
          "Text",
        },
        lua = {
          "Class",
          "Constructor",
          "Enum",
          "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          "Property",
          "Struct",
          "Trait",
        },
      },
    },
  },
  
  -- Configuración de Snacks
  {
    "snacks.nvim",
    opts = {
      -- Dashboard personalizado
      dashboard = {
        preset = {
          header = [[
    ██╗  ██╗██████╗ ███╗   ██╗    ██████╗ ███████╗██╗   ██╗
    ██║  ██║╚════██╗████╗  ██║    ██╔══██╗██╔════╝██║   ██║
    ███████║ █████╔╝██╔██╗ ██║    ██║  ██║█████╗  ██║   ██║
    ██╔══██║ ╚═══██╗██║╚██╗██║    ██║  ██║██╔══╝  ╚██╗ ██╔╝
    ██║  ██║██████╔╝██║ ╚████║    ██████╔╝███████╗ ╚████╔╝ 
    ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═══╝    ╚═════╝ ╚══════╝  ╚═══╝  
 ]],
          -- stylua: ignore
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "p", desc = "Projects", action = ":Telescope projects" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "w", desc = "Reload Pywal", action = ":PywalReload" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      -- Otras configuraciones de snacks
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = false },
      toggle = { map = LazyVim.safe_keymap_set },
      words = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
    },
  },
  
  -- Configuración de which-key para nuestros keymaps
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>a", group = "AI/Copilot" },
        { "<leader>ap", group = "Python" },
        { "<leader>ac", group = "CSS" },
        { "<leader>ab", group = "Bash" },
        { "<leader>aj", group = "JSON" },
        { "<leader>am", group = "Markdown" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Debug" },
        { "<leader>f", group = "File/Find" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Hunk" },
        { "<leader>j", group = "JSON" },
        { "<leader>m", group = "Markdown" },
        { "<leader>r", group = "Run" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Test" },
        { "<leader>u", group = "UI" },
        { "<leader>w", group = "Workspace/Pywal" },
        { "<leader>x", group = "Diagnostics" },
        { "[", group = "Prev" },
        { "]", group = "Next" },
        { "g", group = "Goto" },
        { "gs", group = "Surround" },
        { "z", group = "Fold" },
      },
    },
  },
  
  -- Configuración de bufferline para mejor aspecto
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = "slant",
        always_show_bufferline = true,
        show_close_icon = true,
        show_buffer_close_icons = true,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = " "
          for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and " " or (e == "warning" and " " or "")
            s = s .. n .. sym
          end
          return s
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
        },
      },
    },
  },
  
  -- Configuración de lualine
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Agregar información específica para nuestros lenguajes
      table.insert(opts.sections.lualine_x, {
        function()
          local ft = vim.bo.filetype
          if ft == "python" then
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
              return "🐍 " .. vim.fn.fnamemodify(venv, ":t")
            end
          elseif ft == "json" then
            return "📄 JSON"
          elseif ft == "css" or ft == "scss" then
            return "🎨 CSS"
          elseif ft == "markdown" then
            return "📝 MD"
          elseif ft == "sh" or ft == "bash" then
            return "🐚 BASH"
          end
          return ""
        end,
        color = { fg = "#7850C7" },
      })
      
      return opts
    end,
  },
}
