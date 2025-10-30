-- Автоматическая установка lazy.nvim если не установлен
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Loading main modules
-- require('config.options')
-- require('config.keymaps')
-- require('config.plugins')
-- require('config.lsp')
-- require('config.cmp')
require("config.options")
require("config.keymaps")
require("config.lazy")
