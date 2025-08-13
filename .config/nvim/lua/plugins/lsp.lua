-- Configuración LSP simplificada siguiendo patrones oficiales de LazyVim
-- Python, Bash, CSS/Tailwind, JSON, Markdown

return {
  -- Configuración principal de nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      -- Configuración de diagnósticos
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      
      -- Habilitar inlay hints
      inlay_hints = {
        enabled = true,
        exclude = {},
      },
      
      -- Configuración de capabilities
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      
      -- Configuración de servidores LSP específicos
      servers = {
        -- Python: Pylsp con configuración completa
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = {
                  ignore = {'W391'},
                  maxLineLength = 88
                },
                pyflakes = { enabled = true },
                mccabe = { enabled = true },
                pylint = { enabled = false },
                rope_autoimport = { enabled = true },
                rope_completion = { enabled = true },
                jedi_completion = {
                  enabled = true,
                  include_params = true,
                },
                jedi_hover = { enabled = true },
                jedi_references = { enabled = true },
                jedi_signature_help = { enabled = true },
                jedi_symbols = { enabled = true },
                black = { enabled = true },
                isort = { enabled = true },
              }
            }
          }
        },
        
        -- Python: Ruff para linting y formateo rápido
        ruff = {
          init_options = {
            settings = {
              args = {
                "--line-length=88",
                "--select=E,W,F,I,B,C4,UP",
                "--ignore=E501,W503",
              },
            }
          }
        },
        
        -- Bash Language Server
        bashls = {
          filetypes = { "sh", "bash", "zsh" },
          settings = {
            bashIde = {
              globPattern = "**/*@(.sh|.inc|.bash|.command|.zsh)",
            },
          },
        },
        
        -- CSS Language Server
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            less = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },
        
        -- Tailwind CSS Language Server
        tailwindcss = {
          filetypes = {
            "css",
            "scss",
            "sass",
            "html",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
          },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  "tw`([^`]*)",
                  'tw="([^"]*)',
                  'tw={"([^"}]*)',
                  "tw\\.\\w+`([^`]*)",
                  "tw\\(.*?\\)`([^`]*)",
                },
              },
            },
          },
        },
        
        -- JSON Language Server
        jsonls = {
          settings = {
            json = {
              schemas = {
                {
                  fileMatch = { "package.json" },
                  url = "https://json.schemastore.org/package.json",
                },
                {
                  fileMatch = { "tsconfig*.json" },
                  url = "https://json.schemastore.org/tsconfig.json",
                },
                {
                  fileMatch = { ".eslintrc", ".eslintrc.json" },
                  url = "https://json.schemastore.org/eslintrc.json",
                },
                {
                  fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
                  url = "https://json.schemastore.org/prettierrc.json",
                },
                {
                  fileMatch = { "pyproject.toml" },
                  url = "https://json.schemastore.org/pyproject.json",
                },
              },
              validate = { enable = true },
            },
          },
        },
        
        -- Markdown Language Server
        marksman = {
          filetypes = { "markdown" },
          settings = {
            marksman = {
              completeWithoutTrigger = true,
            },
          },
        },
        
        -- YAML Language Server
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.yml",
                ["https://json.schemastore.org/ansible-playbook.json"] = "*play*.yml",
              },
              validate = true,
              completion = true,
              hover = true,
            },
          },
        },
        
        -- Lua Language Server (para configuración de Neovim)
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
      
      -- Configuración específica de setup
      setup = {
        -- Configuración especial para ruff y pylsp
        ruff = function(server, server_opts)
          LazyVim.lsp.on_attach(function(client, buffer)
            if client.name == "ruff" then
              -- Deshabilitar hover para ruff, lo maneja pylsp
              client.server_capabilities.hoverProvider = false
            end
          end)
          return false -- Continuar con setup normal
        end,
      },
    },
  },
  
  -- Mason para instalar automáticamente los LSP servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- Python tools
        "python-lsp-server",
        "ruff",
        "black",
        "isort",
        "debugpy",
        
        -- Bash tools
        "bash-language-server",
        "shellcheck",
        "shfmt",
        
        -- CSS/Web tools
        "css-lsp",
        "tailwindcss-language-server",
        "prettier",
        
        -- JSON tools
        "json-lsp",
        
        -- Markdown tools
        "marksman",
        
        -- YAML tools
        "yaml-language-server",
        
        -- General tools
        "lua-language-server",
        "stylua",
      },
    },
  },
  
  -- Configuración adicional para formateo con conform.nvim
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black", "isort" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        css = { "prettier" },
        scss = { "prettier" },
        sass = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
      },
      formatters = {
        black = {
          prepend_args = { "--line-length", "88" },
        },
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
      },
    },
  },
  
  -- Configuración adicional para linting con nvim-lint
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "ruff" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
        yaml = { "yamllint" },
        markdown = { "markdownlint" },
      },
    },
  },
}