-- Configuración de GitHub Copilot
-- Autocompletado inteligente con IA para los lenguajes que utilizamos

return {
  -- GitHub Copilot oficial
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Configuraciones básicas
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      
      -- Habilitar para nuestros lenguajes específicos
      vim.g.copilot_filetypes = {
        ["*"] = false,
        python = true,
        javascript = true,
        typescript = true,
        json = true,
        jsonc = true,
        css = true,
        scss = true,
        sass = true,
        html = true,
        markdown = true,
        sh = true,
        bash = true,
        zsh = true,
        yaml = true,
        toml = true,
        lua = true,
      }
      
      -- Configurar keymaps específicos (ya definidos en keymaps.lua)
      local keymap = vim.keymap.set
      
      -- Keymap para aceptar sugerencia
      keymap("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        silent = true,
        desc = "Accept Copilot suggestion"
      })
      
      -- Keymap para aceptar palabra
      keymap("i", "<C-L>", "<Plug>(copilot-accept-word)", { 
        silent = true,
        desc = "Accept Copilot word"
      })
      
      -- Keymap para siguiente sugerencia
      keymap("i", "<C-]>", "<Plug>(copilot-next)", { 
        silent = true,
        desc = "Next Copilot suggestion"
      })
      
      -- Keymap para sugerencia anterior
      keymap("i", "<C-[>", "<Plug>(copilot-previous)", { 
        silent = true,
        desc = "Previous Copilot suggestion"
      })
      
      -- Keymap para descartar sugerencia
      keymap("i", "<C-\\>", "<Plug>(copilot-dismiss)", { 
        silent = true,
        desc = "Dismiss Copilot suggestion"
      })
      
      -- Comando para habilitar/deshabilitar Copilot
      vim.api.nvim_create_user_command("CopilotToggle", function()
        if vim.g.copilot_enabled == 0 then
          vim.g.copilot_enabled = 1
          vim.notify("Copilot enabled", vim.log.levels.INFO)
        else
          vim.g.copilot_enabled = 0
          vim.notify("Copilot disabled", vim.log.levels.WARN)
        end
      end, { desc = "Toggle Copilot" })
    end,
  },
  
  -- Copilot Chat para conversaciones con AI
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    event = "VeryLazy",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      question_header = "## Usuario ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
      prompts = {
        -- Prompts específicos para nuestros lenguajes
        Explain = {
          prompt = "/COPILOT_EXPLAIN Escribe una explicación del código activo como párrafos de texto.",
        },
        Review = {
          prompt = "/COPILOT_REVIEW Revisa el código seleccionado y proporciona sugerencias de mejora concisas.",
        },
        Fix = {
          prompt = "/COPILOT_GENERATE Hay un problema en este código. Reescríbelo para corregir el error.",
        },
        Optimize = {
          prompt = "/COPILOT_GENERATE Optimiza el código seleccionado para mejorar el rendimiento y la legibilidad.",
        },
        Docs = {
          prompt = "/COPILOT_GENERATE Agrega documentación al código seleccionado.",
        },
        Tests = {
          prompt = "/COPILOT_GENERATE Genera tests unitarios para el código seleccionado.",
        },
        FixDiagnostic = {
          prompt = "/COPILOT_GENERATE Ayúdame a resolver el siguiente problema de diagnóstico:",
        },
        -- Prompts específicos para Python
        PythonOptimize = {
          prompt = "/COPILOT_GENERATE Optimiza este código Python siguiendo las mejores prácticas de PEP 8 y mejora el rendimiento:",
        },
        PythonTests = {
          prompt = "/COPILOT_GENERATE Crea tests unitarios completos para esta función Python usando pytest:",
        },
        -- Prompts específicos para CSS
        CSSModern = {
          prompt = "/COPILOT_GENERATE Moderniza este CSS usando flexbox, grid y propiedades CSS modernas:",
        },
        -- Prompts específicos para Bash
        BashSafe = {
          prompt = "/COPILOT_GENERATE Mejora este script Bash agregando manejo de errores y buenas prácticas de seguridad:",
        },
        -- Prompts específicos para JSON
        JSONValidate = {
          prompt = "/COPILOT_GENERATE Valida y corrige este JSON, asegurándote de que tenga la estructura correcta:",
        },
        -- Prompts específicos para Markdown
        MarkdownFormat = {
          prompt = "/COPILOT_GENERATE Mejora el formato de este Markdown y agrega estructura si es necesario:",
        },
      },
      auto_follow_cursor = false,
      show_help = false,
      mappings = {
        complete = {
          detail = "Usar @<Tab> o /<Tab> para opciones.",
          insert = "<Tab>",
        },
        close = {
          normal = "q",
          insert = "<C-c>"
        },
        reset = {
          normal = "<C-r>",
          insert = "<C-r>"
        },
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-s>"
        },
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>"
        },
        yank_diff = {
          normal = "gy",
          register = '"',
        },
        show_diff = {
          normal = "gd"
        },
        show_system_prompt = {
          normal = "gp"
        },
        show_user_selection = {
          normal = "gs"
        },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      chat.setup(opts)
      
      -- Configurar keymaps para CopilotChat
      vim.keymap.set({ "n", "v" }, "<leader>aa", function()
        return require("CopilotChat").toggle()
      end, { desc = "Toggle Copilot Chat" })
      
      vim.keymap.set({ "n", "v" }, "<leader>ax", function()
        return require("CopilotChat").reset()
      end, { desc = "Reset Copilot Chat" })
      
      vim.keymap.set("n", "<leader>aq", function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input)
        end
      end, { desc = "Quick Chat" })
      
      -- Prompts específicos con keymaps
      vim.keymap.set({ "n", "v" }, "<leader>ae", ":CopilotChatExplain<cr>", { desc = "Explain code" })
      vim.keymap.set({ "n", "v" }, "<leader>ar", ":CopilotChatReview<cr>", { desc = "Review code" })
      vim.keymap.set({ "n", "v" }, "<leader>af", ":CopilotChatFix<cr>", { desc = "Fix code" })
      vim.keymap.set({ "n", "v" }, "<leader>ao", ":CopilotChatOptimize<cr>", { desc = "Optimize code" })
      vim.keymap.set({ "n", "v" }, "<leader>ad", ":CopilotChatDocs<cr>", { desc = "Add documentation" })
      vim.keymap.set({ "n", "v" }, "<leader>at", ":CopilotChatTests<cr>", { desc = "Generate tests" })
      vim.keymap.set({ "n", "v" }, "<leader>aD", ":CopilotChatFixDiagnostic<cr>", { desc = "Fix diagnostic" })
      
      -- Prompts específicos por lenguaje
      vim.keymap.set({ "n", "v" }, "<leader>apo", ":CopilotChatPythonOptimize<cr>", { desc = "Python: Optimize" })
      vim.keymap.set({ "n", "v" }, "<leader>apt", ":CopilotChatPythonTests<cr>", { desc = "Python: Tests" })
      vim.keymap.set({ "n", "v" }, "<leader>acm", ":CopilotChatCSSModern<cr>", { desc = "CSS: Modernize" })
      vim.keymap.set({ "n", "v" }, "<leader>abs", ":CopilotChatBashSafe<cr>", { desc = "Bash: Safety" })
      vim.keymap.set({ "n", "v" }, "<leader>ajv", ":CopilotChatJSONValidate<cr>", { desc = "JSON: Validate" })
      vim.keymap.set({ "n", "v" }, "<leader>amf", ":CopilotChatMarkdownFormat<cr>", { desc = "Markdown: Format" })
    end,
  },
  

}
