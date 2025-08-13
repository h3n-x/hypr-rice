-- Configuración de Treesitter y autocompletado
-- Syntax highlighting y text objects para nuestros lenguajes

return {
  -- Configuración principal de nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "LazyFile", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0,
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    opts = {
      -- Habilitar highlighting
      highlight = { 
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      
      -- Habilitar indentación
      indent = { enable = true },
      
      -- Parsers para nuestros lenguajes específicos
      ensure_installed = {
        -- Básicos
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        
        -- Específicos para nuestros lenguajes
        "css",
        "scss",
        "json5",
        "dockerfile",
        "gitignore",
        "gitcommit",
        "requirements", -- Para requirements.txt de Python
      },
      
      -- Selección incremental
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      
      -- Text objects
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- Funciones
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            -- Clases
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            -- Parámetros
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            -- Comentarios
            ["a/"] = "@comment.outer",
            ["i/"] = "@comment.inner",
            -- Bloques
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            -- Condicionales
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            -- Loops
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            -- Asignaciones
            ["a="] = "@assignment.outer",
            ["i="] = "@assignment.inner",
            ["l="] = "@assignment.lhs",
            ["r="] = "@assignment.rhs",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.inner",
            ["]i"] = "@conditional.outer",
            ["]l"] = "@loop.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.inner",
            ["]I"] = "@conditional.outer",
            ["]L"] = "@loop.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.inner",
            ["[i"] = "@conditional.outer",
            ["[l"] = "@loop.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.inner",
            ["[I"] = "@conditional.outer",
            ["[L"] = "@loop.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>sn"] = "@parameter.inner",
            ["<leader>sf"] = "@function.outer",
          },
          swap_previous = {
            ["<leader>sp"] = "@parameter.inner",
            ["<leader>sF"] = "@function.outer",
          },
        },
      },
      
      -- Configuración específica por lenguaje
      python = {
        highlight = {
          enable = true,
          custom_captures = {
            ["function.call"] = "Function",
            ["method.call"] = "Method",
          },
        },
      },
      
      css = {
        highlight = {
          enable = true,
          custom_captures = {
            ["property"] = "Property",
            ["value"] = "String",
          },
        },
      },
      
      json = {
        highlight = {
          enable = true,
          custom_captures = {
            ["key"] = "Property",
            ["value.string"] = "String",
            ["value.number"] = "Number",
          },
        },
      },
      
      markdown = {
        highlight = {
          enable = true,
          custom_captures = {
            ["heading"] = "Title",
            ["link"] = "Underlined",
            ["code"] = "String",
          },
        },
      },
      
      bash = {
        highlight = {
          enable = true,
          custom_captures = {
            ["command"] = "Function",
            ["option"] = "Parameter",
          },
        },
      },
    },
    
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  
  -- Text objects adicionales
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    enabled = true,
    config = function()
      if LazyVim.is_loaded("nvim-treesitter") then
        local opts = LazyVim.opts("nvim-treesitter")
        require("nvim-treesitter.configs").setup({ textobjects = opts.textobjects })
      end
      
      -- Configuración especial para diff mode
      local move = require("nvim-treesitter.textobjects.move")
      local configs = require("nvim-treesitter.configs")
      for name, fn in pairs(move) do
        if name:find("goto") == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name]
              for key, query in pairs(config or {}) do
                if q == query and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
  
  -- Auto-close tags para HTML/JSX
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {
      filetypes = {
        "html",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "svelte",
        "vue",
        "tsx",
        "jsx",
        "rescript",
        "xml",
        "php",
        "markdown",
        "astro",
        "glimmer",
        "handlebars",
        "hbs",
      },
    },
  },
  
  -- Autocompletado con nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local lspkind = require("lspkind")
      
      return {
        auto_brackets = {}, -- configurar por LSP
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping(
            cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }),
            { "i", "c" }
          ),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.snippet.active({ direction = 1 }) then
              vim.schedule(function()
                vim.snippet.jump(1)
              end)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.snippet.active({ direction = -1 }) then
              vim.schedule(function()
                vim.snippet.jump(-1)
              end)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { 
            name = "nvim_lsp", 
            priority = 900,
            group_index = 1,
          },
          { 
            name = "luasnip", 
            priority = 800,
            group_index = 1,
          },
          { 
            name = "path", 
            priority = 700,
            group_index = 2,
          },
        }, {
          { 
            name = "buffer", 
            priority = 600,
            group_index = 2,
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            },
          },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            symbol_map = {
              Copilot = "",
              Text = "󰉿",
              Method = "󰆧",
              Function = "󰊕",
              Constructor = "",
              Field = "󰜢",
              Variable = "󰀫",
              Class = "󰠱",
              Interface = "",
              Module = "",
              Property = "󰜢",
              Unit = "󰑭",
              Value = "󰎠",
              Enum = "",
              Keyword = "󰌋",
              Snippet = "",
              Color = "󰏘",
              File = "󰈙",
              Reference = "󰈇",
              Folder = "󰉋",
              EnumMember = "",
              Constant = "󰏿",
              Struct = "󰙅",
              Event = "",
              Operator = "󰆕",
              TypeParameter = "",
            },
            before = function(entry, vim_item)
              -- Personalización específica por fuente
              if entry.source.name == "copilot" then
                vim_item.kind = "Copilot"
                vim_item.kind_hl_group = "CmpItemKindCopilot"
              end
              return vim_item
            end,
          }),
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
    
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      
      local cmp = require("cmp")
      cmp.setup(opts)
      
      -- Autocompletado para command line
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path" },
          { name = "cmdline" },
        },
      })
      
      -- Autocompletado para búsqueda
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },
  
  -- LuaSnip para snippets
  {
    "L3MON4D3/LuaSnip",
    build = (function()
      if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
        return
      end
      return "make install_jsregexp"
    end)(),
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          
          -- Snippets personalizados para nuestros lenguajes
          local ls = require("luasnip")
          local s = ls.snippet
          local t = ls.text_node
          local i = ls.insert_node
          
          -- Snippets para Python
          ls.add_snippets("python", {
            s("def", {
              t("def "), i(1, "function_name"), t("("), i(2), t("):"),
              t({"", "    "}), i(3, "pass"),
            }),
            s("class", {
              t("class "), i(1, "ClassName"), t("("), i(2, "object"), t("):"),
              t({"", "    def __init__(self, "}), i(3), t("):"),
              t({"", "        "}), i(4, "pass"),
            }),
            s("if", {
              t("if "), i(1, "condition"), t(":"),
              t({"", "    "}), i(2, "pass"),
            }),
            s("for", {
              t("for "), i(1, "item"), t(" in "), i(2, "iterable"), t(":"),
              t({"", "    "}), i(3, "pass"),
            }),
            s("try", {
              t({"try:", "    "}), i(1, "pass"),
              t({"", "except "}), i(2, "Exception"), t({" as e:", "    "}), i(3, "pass"),
            }),
          })
          
          -- Snippets para Bash
          ls.add_snippets("sh", {
            s("shebang", {
              t("#!/bin/bash"),
              t({"", ""}),
            }),
            s("if", {
              t("if [ "), i(1, "condition"), t(" ]; then"),
              t({"", "    "}), i(2, "# commands"),
              t({"", "fi"}),
            }),
            s("for", {
              t("for "), i(1, "var"), t(" in "), i(2, "list"), t("; do"),
              t({"", "    "}), i(3, "# commands"),
              t({"", "done"}),
            }),
            s("function", {
              t("function "), i(1, "name"), t("() {"),
              t({"", "    "}), i(2, "# commands"),
              t({"", "}"}),
            }),
          })
          
          -- Snippets para CSS
          ls.add_snippets("css", {
            s("media", {
              t("@media ("), i(1, "max-width: 768px"), t(") {"),
              t({"", "    "}), i(2, "/* styles */"),
              t({"", "}"}),
            }),
            s("flex", {
              t({"display: flex;", "justify-content: "}), i(1, "center"), t(";"),
              t({"", "align-items: "}), i(2, "center"), t(";"),
            }),
            s("grid", {
              t({"display: grid;", "grid-template-columns: "}), i(1, "repeat(3, 1fr)"), t(";"),
              t({"", "gap: "}), i(2, "1rem"), t(";"),
            }),
          })
          
          -- Snippets para Markdown
          ls.add_snippets("markdown", {
            s("link", {
              t("["), i(1, "text"), t("]("), i(2, "url"), t(")"),
            }),
            s("img", {
              t("!["), i(1, "alt text"), t("]("), i(2, "url"), t(")"),
            }),
            s("code", {
              t("```"), i(1, "language"),
              t({"", ""}), i(2, "code"),
              t({"", "```"}),
            }),
            s("table", {
              t("| "), i(1, "Header 1"), t(" | "), i(2, "Header 2"), t(" |"),
              t({"", "|----------|----------|"}),
              t({"", "| "}), i(3, "Cell 1"), t(" | "), i(4, "Cell 2"), t(" |"),
            }),
          })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },
}
