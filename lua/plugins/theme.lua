return {
   {
      'Mofiqul/vscode.nvim',
      opts = {
         transparent = true,

          -- Enable italic comment
          italic_comments = true,

          -- Disable nvim-tree background color
          disable_nvimtree_bg = true,

          -- Override colors (see ./lua/vscode/colors.lua)
          color_overrides = {
              vscLineNumber = '#FFFFFF',
          },
      },
   },
   {
      "utilyre/barbecue.nvim",
      name = "barbecue",
      version = "*",
      dependencies = {
         "SmiteshP/nvim-navic",
         "nvim-tree/nvim-web-devicons", -- optional dependency
      },
      opts = {
        -- configurations go here
      },
   },
   {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
   }

}
