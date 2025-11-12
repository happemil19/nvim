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

keymap("n", "<F3>", "<cmd>set hlsearch!", { desc = "clean last search highlighting" })

-- Улучшенная замена текста с обработкой ошибок
local function replace_text(confirm)
  -- Проверяем, есть ли выделение
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' and mode ~= '' then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end

  -- Сохраняем выделенный текст
  vim.cmd('normal! "xy')
  local selected = vim.fn.getreg('x')

  if selected == '' or selected == nil then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end

  -- Убираем лишние пробелы и переносы
  selected = selected:gsub('^%s+', ''):gsub('%s+$', ''):gsub('\n', '\\n')

  if selected == '' then
    vim.notify("Selected text is empty", vim.log.levels.WARN)
    return
  end

  -- Экранируем специальные символы для regex
  local escaped = vim.fn.escape(selected, '/\\.*$^~[]()')

  -- Запрашиваем замену
  local replace_with = vim.fn.input('Replace "' .. selected .. '" with: ')

  if replace_with == '' then
    vim.notify("Replace cancelled", vim.log.levels.INFO)
    return
  end

  -- Экранируем замену
  local escaped_replace = vim.fn.escape(replace_with, '/\\')

  -- Выполняем замену
  local command = ':%s/' .. escaped .. '/' .. escaped_replace .. '/'
  if confirm then
    command = command .. 'gc'
  else
    command = command .. 'g'
  end

  vim.cmd(command)
end

-- Keymaps для замены
keymap("v", "<leader>r", function() replace_text(true) end, { desc = "Replace selected text with confirmation" })
keymap("v", "<leader>R", function() replace_text(false) end, { desc = "Replace selected text without confirmation" })

-- Git keymaps
keymap("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
keymap("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
keymap("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git diff" })
keymap("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
keymap("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
keymap("n", "<leader>gP", "<cmd>Git pull<CR>", { desc = "Git pull" })
keymap("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
keymap("n", "<leader>gB", "<cmd>GitBlameToggle<CR>", { desc = "Toggle git blame" })

-- Gitsigns keymaps
keymap("n", "<leader>gj", function() require('gitsigns').next_hunk() end, { desc = "Next hunk" })
keymap("n", "<leader>gk", function() require('gitsigns').prev_hunk() end, { desc = "Previous hunk" })
keymap("n", "<leader>gh", function() require('gitsigns').preview_hunk() end, { desc = "Preview hunk" })
keymap("n", "<leader>gr", function() require('gitsigns').reset_hunk() end, { desc = "Reset hunk" })
keymap("n", "<leader>gR", function() require('gitsigns').reset_buffer() end, { desc = "Reset buffer" })
keymap("n", "<leader>gS", function() require('gitsigns').stage_hunk() end, { desc = "Stage hunk" })
keymap("n", "<leader>gu", function() require('gitsigns').undo_stage_hunk() end, { desc = "Undo stage hunk" })

-- Diffview keymaps
keymap("n", "<leader>gD", "<cmd>DiffviewOpen<CR>", { desc = "Open diffview" })
keymap("n", "<leader>gC", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" })
keymap("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "File history" })

-- Быстрое добавление
keymap("n", "<leader>ga", "<cmd>Git add %<CR>", { desc = "Git add current file" })
keymap("n", "<leader>gA", "<cmd>Git add .<CR>", { desc = "Git add all" })

-- Быстрое добавление и коммит
keymap("n", "<leader>gac", "<cmd>GitAddCommit<CR>", { desc = "Git add all and commit" })
keymap("n", "<leader>gap", "<cmd>GitAddCommitPush<CR>", { desc = "Git add all, commit and push" })

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })

-- LSP
keymap('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
keymap('n', 'K', vim.lsp.buf.hover, { desc = "Hover documentation" })
keymap('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename symbol" })
keymap('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code action" })
