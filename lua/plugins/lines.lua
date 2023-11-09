return {
   {
      "lukas-reineke/virt-column.nvim",
      opts = {},
   },
   {
      "m4xshen/smartcolumn.nvim",
      opts = {
         colorcolumn = { "80" },
         disabled_filetypes = {
            "netrw",
            "NvimTree",
            "Lazy",
            "mason",
            "help",
            "text",
            "markdown",
            "tex",
            "html",
         },
         scope = "file",
         custom_colorcolumn = { python = { "80", "100" } },
      },
   },
   {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
         options = {
            theme = "ayu_dark",
            globalstatus = true,
            component_separators = nil,
            section_separators = nil,
            disabled_filetypes = {}
         },
         sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff',
               {
                  'diagnostics',
                  symbols = {
                     error = 'E', -- ' ',
                     warn  = 'W', -- ' ',
                     info  = 'I', -- ' ',
                     hint  = 'H', -- ' '
                  },
               },
            },
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
         },
      },
      init = function()
         vim.opt.showmode = false
      end,
   },
   {
      "akinsho/bufferline.nvim",
      version = "v3.*",
      dependencies = "nvim-tree/nvim-web-devicons",
      opts = {
         options = {
            separator_style = "slope",
            mode = "tabs",
            offsets = {
               {
                  filetype = "NvimTree",
                  text = " File Explorer",
                  highlight = "Directory",
                  separator = false,
               },
            },
         },
      },
   },
   {
      "utilyre/barbecue.nvim",
      name = "barbecue",
      version = "*",
      theme = "",
      dependencies = {
         "SmiteshP/nvim-navic",
         "nvim-tree/nvim-web-devicons",
      },
      opts = {
         show_dirname = false,
         show_basename = false,
      },
   },
   {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
       "nvim-tree/nvim-web-devicons",
      },
      config = function()
       require("nvim-tree").setup {}
      end,
   },
}
