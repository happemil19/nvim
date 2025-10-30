require("lazy").setup({
  -- Импортируем настройки плагинов
  spec = {
    { import = "plugins.lsp" },
    { import = "plugins.cmp" },
    { import = "plugins.ui" },
    { import = "plugins.tools" },
  },
})
