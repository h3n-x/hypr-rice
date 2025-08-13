-- Keymaps personalizados
-- Configuración optimizada para desarrollo en Python, JSON, Markdown, CSS/Tailwind, Bash

local map = vim.keymap.set

-- Mejorar navegación en líneas largas
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Mover a ventana usando <ctrl> hjkl
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Redimensionar ventana usando <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Mover líneas
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Navegación de buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Guardar archivo
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Mejor indentación
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Escape mejorado
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Navegación mejorada de búsqueda
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })

-- Break points para undo
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Nuevo archivo
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Comentarios mejorados
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Mapas específicos para desarrollo
-- Python: ejecutar archivo actual
map("n", "<leader>rp", "<cmd>!python3 %<cr>", { desc = "Run Python File" })

-- Bash: hacer ejecutable y correr
map("n", "<leader>rb", "<cmd>!chmod +x % && ./%<cr>", { desc = "Make Executable and Run" })

-- JSON: formatear con jq
map("n", "<leader>jq", "<cmd>%!jq .<cr>", { desc = "Format JSON with jq" })

-- Markdown: vista previa
map("n", "<leader>mp", "<cmd>MarkdownPreview<cr>", { desc = "Markdown Preview" })

-- CSS/Tailwind: abrir en navegador para vista previa
map("n", "<leader>cp", "<cmd>!xdg-open %<cr>", { desc = "Open in Browser" })

-- Terminal integrado
map("n", "<leader>ft", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
map("n", "<c-/>", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })

-- Mapas específicos para ventanas
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- Mapas para tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Copilot específicos
map("i", "<C-J>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false, desc = "Accept Copilot" })
map("i", "<C-L>", "<Plug>(copilot-accept-word)", { desc = "Accept Copilot Word" })
map("i", "<C-;>", "<Plug>(copilot-next)", { desc = "Next Copilot Suggestion" })
map("i", "<C-,>", "<Plug>(copilot-previous)", { desc = "Previous Copilot Suggestion" })
map("i", "<C-o>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot" })

-- Pywal: recargar colores
map("n", "<leader>wr", "<cmd>source ~/.config/nvim/lua/plugins/colorscheme.lua<cr>", { desc = "Reload Pywal Colors" })
