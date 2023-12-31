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
vim.opt.cursorlineopt = "both"

-- scroll limits for cursor walking before the screen will be centered by cursor
vim.opt.scrolloff = 8  -- vertical
vim.opt.sidescrolloff = 8  -- horizontal

-- folders
vim.opt.foldcolumn = '3'
-- vim.opt.fillchars = 'diff:/,fold: ,eob: ,foldopen:,foldsep: ,foldclose:'

vim.opt.mouse = "a"  -- turn on a mouse
vim.opt.background = 'dark'  -- select view of a theme
vim.opt.termguicolors = true
vim.opt.wrap = false  -- turn off wrap a text
