return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard", -- можно использовать "soft", "hard" или "medium"
        transparent_mode = false,
        terminal_colors = true,
        undercurl = true,
        bold = true,
        italic = {
          strings = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines etc.
        overrides = {},
        dim_inactive = false,
      })

      -- Установка цветовой схемы
      vim.cmd.colorscheme("gruvbox")

      -- Установка фона (dark/light)
      vim.o.background = "dark" -- или "light" для светлой темы
    end,
  },

  -- Файловый менеджер
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 35 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
      })
    end,
  },

  -- Иконки
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- Статусная строка
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- local function git_branch()
      --   local branch = vim.b.git_branch or ""
      --   return branch ~= "" and " " .. branch or ""
      -- end
      require("lualine").setup({
        options = {
          theme = "gruvbox",
          component_separators = { left = "│", right = "│" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
}
