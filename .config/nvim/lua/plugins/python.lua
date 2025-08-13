-- Configuración específica para desarrollo en Python
-- Herramientas adicionales y mejoras para Python

return {
  -- Configuración específica para Python
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Configuración adicional para Python
        ruff = {
          init_options = {
            settings = {
              -- Args específicos para el proyecto
              args = {
                "--line-length=88",
                "--select=E,W,F,I,B,C4,UP,N,PL",
                "--ignore=E501,W503,PLR0913,PLR0915",
                "--fix",
              },
              -- Organizar imports automáticamente
              organizeImports = true,
              -- Arreglar automáticamente errores
              fixAll = true,
            }
          },
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
            {
              "<leader>cF",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.fixAll" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Fix All",
            },
          },
        },
      },
    },
  },

  -- Configuración avanzada de formateo para Python
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
      },
      formatters = {
        ruff_format = {
          command = "ruff",
          args = { "format", "--stdin-filename", "$FILENAME", "-" },
          stdin = true,
        },
        ruff_organize_imports = {
          command = "ruff",
          args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" },
          stdin = true,
        },
      },
    },
  },

  -- Linting avanzado para Python
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "ruff" },
      },
      linters = {
        ruff = {
          args = {
            "check",
            "--output-format=json",
            "--stdin-filename",
            function() return vim.api.nvim_buf_get_name(0) end,
            "-",
          },
        },
      },
    },
  },

  -- Mejor soporte para debugging Python
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      config = function()
        local path = require("mason-registry").get_package("debugpy"):get_install_path()
        require("dap-python").setup(path .. "/venv/bin/python")
        
        -- Configuraciones específicas para Python
        table.insert(require("dap").configurations.python, {
          type = "python",
          request = "launch",
          name = "Launch current file",
          program = "${file}",
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return '/usr/bin/python3'
            end
          end,
        })
      end,
    },
    keys = {
      { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Test Method", ft = "python" },
      { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Test Class", ft = "python" },
    },
  },

  -- Neotest para testing Python
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          dap = { justMyCode = false },
          runner = "pytest",
          python = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return '/usr/bin/python3'
            end
          end,
        },
      },
    },
  },

  -- Autocmds específicos para Python
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Autocomandos para archivos Python
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          -- Configuraciones específicas para Python
          vim.opt_local.textwidth = 88
          vim.opt_local.colorcolumn = "89"
          vim.opt_local.expandtab = true
          vim.opt_local.shiftwidth = 4
          vim.opt_local.tabstop = 4
          
          -- Keymaps específicos para Python
          local map = vim.keymap.set
          local opts = { buffer = true, silent = true }
          
          -- Ejecutar archivo Python
          map("n", "<leader>rp", "<cmd>!python3 %<cr>", vim.tbl_extend("force", opts, { desc = "Run Python file" }))
          
          -- Ejecutar tests con pytest
          map("n", "<leader>rt", "<cmd>!python3 -m pytest %<cr>", vim.tbl_extend("force", opts, { desc = "Run pytest on file" }))
          map("n", "<leader>rT", "<cmd>!python3 -m pytest<cr>", vim.tbl_extend("force", opts, { desc = "Run all tests" }))
          
          -- Crear entorno virtual
          map("n", "<leader>rv", "<cmd>!python3 -m venv venv<cr>", vim.tbl_extend("force", opts, { desc = "Create venv" }))
          
          -- Instalar requirements
          map("n", "<leader>ri", "<cmd>!pip install -r requirements.txt<cr>", vim.tbl_extend("force", opts, { desc = "Install requirements" }))
          
          -- Generar requirements
          map("n", "<leader>rg", "<cmd>!pip freeze > requirements.txt<cr>", vim.tbl_extend("force", opts, { desc = "Generate requirements" }))
          
          -- Black formatting
          map("n", "<leader>rb", "<cmd>!black %<cr>", vim.tbl_extend("force", opts, { desc = "Format with black" }))
          
          -- Isort imports
          map("n", "<leader>rs", "<cmd>!isort %<cr>", vim.tbl_extend("force", opts, { desc = "Sort imports" }))
        end,
      })
    end,
  },

  -- Mason: herramientas adicionales para Python
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Python type checking
        "mypy",
        
        -- Python linting adicional
        "flake8",
        
        -- Python formatting
        "black",
        "isort",
        
        -- Python debugging
        "debugpy",
      },
    },
  },
}
