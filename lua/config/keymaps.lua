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
