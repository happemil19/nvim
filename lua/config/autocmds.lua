-- Create an autocommand event handler:
--    nvim_create_autocmd({event}, {*opts})
--
-- {event}: (string or array) events that will trigger the handler
--    BufEnter: after entering a buffer
--    CmdlineLeave: before leaving the command-line
--
-- See all available events with :h autocmd-events.
-- 
-- {opts}: options
--    pattern (string or array): pattern to match
--    callback (function or string): Lua function called when the event is triggered
--
-- See all available options with :h nvim_create_autocmd.


-- tab format for .lua file
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = { "*.lua" },
   callback = function()
      vim.opt.shiftwidth = 3
      vim.opt.tabstop = 3
      vim.opt.softtabstop = 3
   end,
})

-- tab format for .py, .html, .css file
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = { "*.py", "*.html", "*.css" },
   callback = function()
      vim.opt.shiftwidth = 4
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
   end,
})

-- only highlight when searching
vim.api.nvim_create_autocmd("CmdlineEnter", {
   callback = function()
      local cmd = vim.v.event.cmdtype
      if cmd == "/" or cmd == "?" then
         vim.opt.hlsearch = true
      end
   end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
   callback = function()
      local cmd = vim.v.event.cmdtype
      if cmd == "/" or cmd == "?" then
         vim.opt.hlsearch = false
      end
   end,
})

-- keep and load file foldering
vim.api.nvim_create_autocmd("BufWinLeave", {
   desc = "save view (folds), when closing file",
   command = "mkview",
})
vim.api.nvim_create_autocmd("BufWinEnter", {
   desc = "load view (folds), when opening file",
   command = "silent! loadview"
})

-- keymap for .cpp file
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = { "*.cpp", "*.cc" },
   callback = function()
      vim.keymap.set(
         "n",
         "<Leader>e",
         ":split | terminal g++ % -o %.out && ./%.out<CR>",
         { silent = true }
      )
   end,
})

-- keymap for .go file
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = { "*.go" },
   callback = function()
      vim.keymap.set(
         "n",
         "<Leader>e",
         ":split | terminal go run %<CR>",
         { silent = true }
      )
   end,
})

-- keymaps for .py file
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = { "*.py" },
   callback = function()
      vim.keymap.set(
         "n",
         "<Leader>e",
         ":split | terminal python3 %<CR>",
         { silent = true }
      )
   end,
})
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = { "*.py" },
   callback = function()
      vim.keymap.set(
         "n",
         "<Leader>ev",
         ":vsplit | terminal python3 %<CR>",
         { silent = true }
      )
   end,
})

-- turn on spell check for markdown and text file
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = { "*.md" },
   callback = function()
      vim.opt_local.spell = true
      vim.opt_local.spelllang = {'en', 'ru_ru'}
   end,
})
