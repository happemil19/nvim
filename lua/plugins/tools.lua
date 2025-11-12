return {
  -- Telescope с правильной настройкой fzf-native
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            height = 0.95,
            width = 0.95
          },
          mappings = {
            i = {
              ["<C-j>"] = require("telescope.actions").move_selection_next,
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
              ["<Esc>"] = require("telescope.actions").close,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            hidden = true,
          },
          live_grep = {
            theme = "dropdown",
          },
          buffers = {
            theme = "dropdown",
            sort_lastused = true,
          },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Find recent files" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "python", "bash", "json", "rust", "markdown",
          "yaml", "cpp", "c", "javascript", "typescript", "html", "css"
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        auto_install = true,
      })
    end,
  },

  -- Автопара скобок
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Комментирование
  {
    "numToStr/Comment.nvim",
    event = "BufReadPre",
    config = function()
      require("Comment").setup({
        padding = true,
        sticky = true,
        ignore = '^$',
        -- toggler = { line = '<leader>cc', block = '<leader>bc' },
        toggler = { line = 'gcc', block = 'gbc' },
        -- opleader = { line = '<leader>c', block = '<leader>b' },
        opleader = { line = 'gc', block = 'gb' },
        extra = { above = 'gcO', below = 'gco', eol = 'gcA' },
        mappings = { basic = true, extra = true },
        pre_hook = nil,
        post_hook = nil,
      })
    end,
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          interval = 1000,
          follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
      })
    end,
  },

  -- Fugitive
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
    dependencies = {
      "tpope/vim-rhubarb", -- Для GitHub URL
    },
  },

  -- GitHub integration для Fugitive
  {
    "tpope/vim-rhubarb",
    dependencies = { "tpope/vim-fugitive" },
  },

  -- Diffview
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = function()
      require("diffview").setup({})
    end,
  },

  -- LazyGit
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0 -- прозрачность окна
      vim.g.lazygit_floating_window_scaling_factor = 0.9 -- масштаб окна
      vim.g.lazygit_floating_window_border_chars = {'╭','─', '╮', '│', '╯','─','╰','│'} -- рамка окна
      vim.g.lazygit_floating_window_use_plenary = 0 -- использовать plenary.nvim (0 для использования встроенного)
      vim.g.lazygit_use_neovim_remote = 1 -- использовать neovim-remote, если установлено
    end,
  },

  -- Git-линтер
  {
    "f-person/git-blame.nvim",
    config = function()
      require("gitblame").setup({
        enabled = false, -- По умолчанию выключен, включается по требованию
      })
    end,
  },

  -- Which-key - подсказки по комбинациям клавиш
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      --@type false | "classic" | "modern" | "helix"
      preset = "classic",
      -- Delay before showing the popup. Can be a number or a function that returns a number.
      ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
      delay = function(ctx)
        return ctx.plugin and 0 or 1000
      end,
      filter = function(mapping)
        -- example to exclude mappings without a description
        -- return mapping.desc and mapping.desc ~= ""
        return true
      end,
      --- You can add any mappings here, or use `require('which-key').add()` later
      spec = {
        --- Example
        -- { "<leader>f", group = "file" }, -- group
        -- { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
        -- { "<leader>fb", function() print("hello") end, desc = "Foobar" },
        -- { "<leader>fn", desc = "New File" },
        -- { "<leader>f1", hidden = true }, -- hide this keymap
        -- { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings
        -- { "<leader>b", group = "buffers", expand = function()
        --     return require("which-key.extras").expand.buf()
        --   end
        -- },
        -- {
        --   -- Nested mappings are allowed and can be added in any order
        --   -- Most attributes can be inherited or overridden on any level
        --   -- There's no limit to the depth of nesting
        --   mode = { "n", "v" }, -- NORMAL and VISUAL mode
        --   { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
        --   { "<leader>w", "<cmd>w<cr>", desc = "Write" },
        -- }


        { "<leader>a", group = " Actions" },
        { "<leader>c", group = " Colors" },
        { "<leader>d", group = " Debug" },
        { "<leader>h", group = " Harpoon" },
        { "<leader>n", group = " Notes" },
        { "<leader>p", group = " Packer" },
        { "<leader>r", group = " Replace" },
        { "<leader>s", group = " Search" },
        { "<leader>t", group = " Terminal" },
        { "<leader>u", group = " UI" },
        { "<leader>w", group = " Windows" },
        { "<leader>x", group = " Trouble" },

        { "<leader>b", group = " Buffers" },
        { "<leader>bd", "<cmd>bd<CR>", desc = "Close buffer" },
        { "<leader>bn", "<cmd>bnext<CR>", desc = "Next buffer" },
        { "<leader>bp", "<cmd>bprevious<CR>", desc = "Previous buffer" },

        { "<leader>e", group = " Explorer" },
        { "<leader>ee", vim.cmd.Ex, desc = "File explorer" },
        { "<leader>en", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },

        { "<leader>q", group = " Quit" },
        { "<leader>qq", "<cmd>q<CR>", desc = "Quit" },
        { "<leader>qs", "<cmd>wq<CR>", desc = "Save and quit" },
        { "<leader>qd", "<cmd>q!<CR>", desc = "Force quit" },

        { "<leader>l", group = " LSP" },
        { "<leader>lr", vim.lsp.buf.rename, desc = "Rename" },
        { "<leader>la", vim.lsp.buf.code_action, desc = "Code action" },

        { "<leader>f", group = "File" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
        { "<leader>fw", "<cmd>w<cr>", desc = "Save File" },

        { "<leader>g", group = " Git" },
        { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
        { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
        { "<leader>gp", "<cmd>Git push<cr>", desc = "Push" },
        { "<leader>gP", "<cmd>Git pull<CR>", desc = "Pull" },
        { "<leader>gs", "<cmd>Git status<cr>", desc = "Status" },
        { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Diff" },
        -- { "<leader>gb", "<cmd>Git blame<CR>", desc = "Blame" },
        { "<leader>gj", function() require('gitsigns').next_hunk() end, desc = "Next hunk" },
        { "<leader>gk", function() require('gitsigns').prev_hunk() end, desc = "Prev hunk" },

        -- { "[d", vim.diagnostic.goto_prev, desc = "Prev diagnostic" },  -- Deprecated.
        -- { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },  -- Deprecated.

        -- LSP goto
        { "gD", vim.lsp.buf.declaration, desc = "Declaration" },
        { "gd", vim.lsp.buf.definition, desc = "Definition" },
        { "gi", vim.lsp.buf.implementation, desc = "Implementation" },
        { "gr", vim.lsp.buf.references, desc = "References" },
        { "K", vim.lsp.buf.hover, desc = "Hover" },

        {
          mode = { "v" },  -- VISUAL mode
          { "<leader>r", function()
              -- Простая версия замены текста
              vim.cmd('normal! "xy')
              local selected = vim.fn.getreg('x')
              if selected ~= '' then
                local escaped = vim.fn.escape(selected, '/\\')
                local replace_with = vim.fn.input('Replace "' .. selected .. '" with: ')
                if replace_with ~= '' then
                  vim.cmd(':%s/' .. escaped .. '/' .. replace_with .. '/gc')
                end
              end
            end, desc = "Replace selected text" },
          { "<leader>R", function()
              -- Функция замены без подтверждения
              vim.cmd('normal! "xy')
              local selected = vim.fn.getreg('x')
              if selected ~= '' then
                local escaped = vim.fn.escape(selected, '/\\')
                local replace_with = vim.fn.input('Replace ALL "' .. selected .. '" with: ')
                if replace_with ~= '' then
                  vim.cmd(':%s/' .. escaped .. '/' .. replace_with .. '/g')
                end
              end
            end, desc = "Replace selected text without confirmation" },
        },
      },
      -- show a warning when issues were detected with your mappings
      notify = true,
      -- Which-key automatically sets up triggers for your mappings.
      -- But you can disable this and setup the triggers manually.
      -- Check the docs for more info.
      triggers = {
        { "<auto>", mode = "nxso" },  -- { "<leader>", mode = { "n", "v" } },
      },

      -- triggers_blacklist = {
      --   -- список режимов, где which-key не показывается
      --   i = { "j", "k" },
      --   v = { "j", "k" },
      -- },

      -- Start hidden and wait for a key to be pressed before showing the popup
      -- Only used by enabled xo mapping modes.
      ---@param ctx { mode: string, operator: string }
      defer = function(ctx)
        return ctx.mode == "V" or ctx.mode == "<C-V>"
      end,
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        spelling = {
          enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
        presets = {
          operators = true, -- adds help for operators like d, y, ...
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      win = {
        -- don't allow the popup to overlap with the cursor
        no_overlap = true,
        -- width = 1,
        -- height = { min = 4, max = 25 },
        -- col = 0,
        -- row = math.huge,
        -- border = "none",
        padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
        title = true,
        title_pos = "center",
        zindex = 1000,
        -- Additional vim.wo and vim.bo options
        bo = {},
        wo = {
          -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
        },
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max width of the window
        width = { min = 20 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- left, center, right
      },
      keys = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
      },
      --- Mappings are sorted using configured sorters and natural sort of the keys
      --- Available sorters:
      --- * local: buffer-local mappings first
      --- * order: order of the items (Used by plugins like marks / registers)
      --- * group: groups last
      --- * alphanum: alpha-numerical first
      --- * mod: special modifier keys last
      --- * manual: the order the mappings were added
      --- * case: lower-case first
      sort = { "local", "order", "group", "alphanum", "mod" },
      ---@type number|fun(node):boolean?
      expand = 0, -- expand groups when <= n mappings
      -- expand = function(node)
      --   return not node.desc -- expand all nodes without a description
      -- end,
      -- Functions/Lua Patterns for formatting the labels
      ---@type table<string, ({[1]:string, [2]:string}|fun(str:string):string)[]>
      replace = {
        key = {
          function(key)
            return require("which-key.view").format(key)
          end,
          -- { "<Space>", "SPC" },
        },
        desc = {
          { "<Plug>%(?(.*)%)?", "%1" },
          { "^%+", "" },
          { "<[cC]md>", "" },
          { "<[cC][rR]>", "" },
          { "<[sS]ilent>", "" },
          { "^lua%s+", "" },
          { "^call%s+", "" },
          { "^:%s*", "" },
        },
      },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
        ellipsis = "…",
        -- set to false to disable all mapping icons,
        -- both those explicitly added in a mapping
        -- and those from rules
        mappings = true,
        --- See `lua/which-key/icons.lua` for more details
        --- Set to `false` to disable keymap icons from rules
        rules = {},
        -- use the highlights from mini.icons
        -- When `false`, it will use `WhichKeyIcon` instead
        colors = true,
        -- used by key format
        keys = {
          Up = " ",
          Down = " ",
          Left = " ",
          Right = " ",
          C = "󰘴 ",
          M = "󰘵 ",
          D = "󰘳 ",
          S = "󰘶 ",
          CR = "󰌑 ",
          Esc = "󱊷 ",
          ScrollWheelDown = "󱕐 ",
          ScrollWheelUp = "󱕑 ",
          NL = "󰌑 ",
          BS = "󰁮",
          Space = "󱁐 ",
          Tab = "󰌒 ",
          F1 = "󱊫",
          F2 = "󱊬",
          F3 = "󱊭",
          F4 = "󱊮",
          F5 = "󱊯",
          F6 = "󱊰",
          F7 = "󱊱",
          F8 = "󱊲",
          F9 = "󱊳",
          F10 = "󱊴",
          F11 = "󱊵",
          F12 = "󱊶",
        },
      },
      show_help = true, -- show a help message in the command line for using WhichKey
      show_keys = true, -- show the currently pressed key and its label as a message in the command line
      -- disable WhichKey for certain buf types and file types.
      disable = {
        ft = { "TelescopePrompt" },
        bt = { "nofile", "prompt" },
      },
      debug = false, -- enable wk.log in the current directory
    },
  }
}
