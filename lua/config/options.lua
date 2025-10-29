<<<<<<< HEAD
-- You can set options via Lua in two ways: vim.opt and vim.o series. I recommend using vim.opt series because it is more Lua-style, you can:
--
--    use :append(), :prepend() and :remove() to manipulate options
--    set its value to Lua table
--
-- (see the differences between them with :h lua-guide-options)
-- 
-- You can set options with vim.opt.option-name = value.


-- enable line number and relative line number
vim.opt.number = true
vim.opt.relativenumber = true

-- width of a tab
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- use number of spaces to insert a <Tab>
vim.opt.expandtab = true

-- force all horizontal splits to go below current window
vim.opt.splitbelow = true
-- force all vertical splits to go to the right of current window
vim.opt.splitright = true

-- highlight the line number of the cursor
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- disable cursor-styling
-- vim.opt.guicursor = ""

vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.background = 'dark'
=======
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.expandtab = true
-- vim.opt.smartindent = true

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.showmatch = true
vim.opt.showcmd = true

-- UI
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

-- Navigation
vim.opt.ruler = true
vim.opt.scrollbind = false
vim.opt.cursorbind = false
vim.opt.scrolloff = 4
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.mouse = "a"
vim.opt.wrap = false
>>>>>>> b704291 (reborning ;)
