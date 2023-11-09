local function map(mode, lhs, rhs, opts)
   -- set default value if not specify
   if opts.noremap == nil then
      opts.noremap = true
   end
   if opts.silent == nil then
      opts.silent = true
   end

   vim.keymap.set(mode, lhs, rhs, opts)
end


-- Define your leader key: (I use space. Change this to whatever you like.)
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Add a new mapping:
--    vim.keymap.set({mode}, {lhs}, {rhs}, {opts})
--
-- {mode} (string or table) mode short-name
--    "": Normal, Visual, Select, Operator-pending mode
--    "n": Normal mode
--    "v": Visual and Select mode
--    "s": Select mode
--    "x": Visual mode
--    "o": Operator-pending mode
--    "i": Insert mode
--    "t": Terminal mode
--    "!": Insert Insert and Command-line mode
--
-- {lhs}: (string) left-hand side of the mapping, the keys we want to map
--
-- {rhs}: (string or function) right-hand side of the mapping, the keys or function we want to execute after pressing {lhs}
--
-- {opts}: (table) optional parameters
--    silent: define a mapping that will not be echoed on the command line
--    noremap: disable recursive mapping
--
-- See all available options with :h map-arguments.


-- better up/down
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- center half/full screen up/down
map("n", "<C-u>", "<C-u>zz", {})
map("n", "<C-d>", "<C-d>zz", {})
map("n", "<C-b>", "<C-b>zz", {})
map("n", "<C-f>", "<C-f>zz", {})

-- center search results
map("n", "n", "nzz", {})
map("n", "N", "Nzz", {})

-- leader movements
map("n", "<Leader>w", ":write<CR>", {})
map("n", "<Leader>s", ":source %<CR>", {})

-- system clipboard
map({ "n", "v" }, "<Leader>y", '"+y', {})
map({ "n" }, "<Leader>Y", '"+y$', {})

map({ "n", "v" }, "<Leader>p", '"+p', {})
map({ "n", "v" }, "<Leader>P", '"+P', {})

-- better window movements
map("n", "<C-k>", "<C-w>k", {})
map("n", "<C-j>", "<C-w>j", {})
map("n", "<C-h>", "<C-w>h", {})
map("n", "<C-l>", "<C-w>l", {})
map("n", "<C-c>", "<C-w>c", {})

-- better escape using jk in insert and terminal mode
map({"i", "v"}, "jk", "<ESC>", {})
map("t", "jk", "<C-\\><C-n>", {})

-- better indent
map("v", "<", "<gv", {})
map("v", ">", ">gv", {})

-- paste over currently selected text without yanking it
map("v", "p", '"_dP', {})

-- buffers navigate
map("n", "bn", ":bn<CR>", {})
map("n", "bp", ":bp<CR>", {})

-- tabs navigate
map("n", "tn", ":tabnext<CR>", {})
map("n", "tp", ":tabprevious<CR>", {})
map("n", "tc", ":tabnew<CR>", {})
map("n", "tx", ":tabclose<CR>", {})

-- split windows
map("n", "vs", ":vs<CR>", {})
map("n", "sp", ":sp<CR>", {})

-- Toggle visibility of nvim tree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", {})

-- Resizing panes
map("n", "<Left>", ":vertical resize +1<CR>", {})
map("n", "<Right>", ":vertical resize -1<CR>", {})
map("n", "<Up>", ":resize -1<CR>", {})
map("n", "<Down>", ":resize +1<CR>", {})
