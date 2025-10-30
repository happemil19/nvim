local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Main combo
keymap("n", "<leader>e", vim.cmd.Ex, { desc = "File explorer" })
keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- Movement between windows
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window resizing
keymap("n", "<Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffers
keymap("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close buffer" })

keymap("v", "<C-r>", "<cmd>hy:%s/<c-r>h//gc<left><left><left><CR>", { desc = "Easier search and replace" })
keymap("n", "<F3>", "<cmd>set hlsearch!", { desc = "clean last search highlighting" })
