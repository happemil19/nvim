<<<<<<< HEAD
-- install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
   })
end
vim.opt.rtp:prepend(lazypath)

-- load plugins
require("lazy").setup("plugins")
=======
require("lazy").setup({
  -- Импортируем настройки плагинов
  spec = {
    { import = "plugins.lsp" },
    { import = "plugins.cmp" },
    { import = "plugins.ui" },
    { import = "plugins.tools" },
  },
})
>>>>>>> b704291 (reborning ;)
