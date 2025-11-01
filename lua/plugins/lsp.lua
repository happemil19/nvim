return {
  -- Mason - установка LSP серверов
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },

  -- Мост между Mason и LSPConfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",           -- Lua
          "pyright",          -- Python
          "bashls",           -- Bash
          "jsonls",           -- JSON
          "rust_analyzer",    -- Rust (оставляем, но настраиваем правильно)
          "cssls",            -- CSS
          "html",             -- HTML
          "emmet_ls",         -- Emmet
          "yamlls",           -- YAML
          "ts_ls",            -- TypeScript
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP конфигурация с использованием современного API
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Общие настройки для всех LSP клиентов
      local on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<leader>f', function() 
          vim.lsp.buf.format({ async = true }) 
        end, bufopts)
        vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, bufopts)
      end

      -- Функция для поиска корневой директории проекта
      local function find_project_root(filename)
        -- Ищем маркеры проектов в родительских директориях
        local markers = {
          '.git',
          '.luarc.json',
          'pyproject.toml', 
          'setup.py',
          'package.json',
          'tsconfig.json',
          'Cargo.toml',  -- Rust проект
          'rust-project.json'
        }

        local dir = vim.fs.dirname(filename)
        while dir ~= '/' and dir ~= '' do
          for _, marker in ipairs(markers) do
            local path = dir .. '/' .. marker
            if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1 then
              return dir
            end
          end
          dir = vim.fs.dirname(dir)
        end

        return vim.fs.dirname(filename)
      end

      -- Функция для проверки Rust проекта
      local function is_rust_project(root_dir)
        if not root_dir then return false end

        -- Проверяем наличие Cargo.toml в корне проекта
        local cargo_toml = root_dir .. '/Cargo.toml'
        local rust_project = root_dir .. '/rust-project.json'

        return vim.fn.filereadable(cargo_toml) == 1 or 
               vim.fn.filereadable(rust_project) == 1
      end

      -- Функция для проверки, есть ли уже LSP клиент для буфера
      local function has_lsp_client(bufnr, server_name)
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        for _, client in ipairs(clients) do
          if client.name == server_name then
            return true
          end
        end
        return false
      end

      -- Автозапуск LSP серверов при открытии файлов
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "lua", "python", "sh", "bash", "json", "jsonc",
          "html", "css", "scss", "less", "yaml", "yml",
          "javascript", "javascriptreact", "typescript", "typescriptreact",
          "rust"  -- Добавляем Rust
        },
        callback = function(args)
          local bufnr = args.buf
          local filetype = vim.bo[bufnr].filetype
          local filename = vim.api.nvim_buf_get_name(bufnr)

          local root_dir = find_project_root(filename)

          -- Запускаем соответствующий LSP сервер в зависимости от типа файла
          if filetype == "lua" and not has_lsp_client(bufnr, "lua_ls") then
            vim.lsp.start({
              name = "lua_ls",
              cmd = { "lua-language-server" },
              -- root_dir = root_dir,
              root_dir = vim.fs.dirname(vim.fs.find({ ".git", "init.lua" }, { upward = true })[1]),
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                Lua = {
                  runtime = {
                    version = "LuaJIT",
                    special = {
                      require = "require",
                    }
                  },
                  diagnostics = {
                    globals = {
                      -- Neovim globals
                      "vim",
                      -- Testing globals
                      "describe", "it", "before_each", "after_each", "pending",
                      -- Plugin manager globals
                      "lazy", "packer", "paq",
                    },
                    disable = { "undefined-global" },
                  },
                  workspace = {
                    library = {
                      vim.api.nvim_get_runtime_file("", true),
                      -- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                      -- [vim.fn.expand("$VIMRUNTIME/lua/vim")] = true,
                      -- [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                      -- [vim.fn.stdpath("config") .. "/lua"] = true,
                      -- [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua"] = true,
                      checkThirdParty = false,
                      maxPreload = 10000,
                    },
                  },
                  telemetry = { enable = false },
                },
              },
            })
          elseif filetype == "python" and not has_lsp_client(bufnr, "pyright") then
            vim.lsp.start({
              name = "pyright",
              cmd = { "pyright-langserver", "--stdio" },
              root_dir = root_dir,
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                python = {
                  analysis = {
                    typeCheckingMode = "basic",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                  },
                },
              },
            })
          elseif (filetype == "typescript" or filetype == "typescriptreact" or 
                 filetype == "javascript" or filetype == "javascriptreact") and 
                 not has_lsp_client(bufnr, "ts_ls") then
            vim.lsp.start({
              name = "ts_ls",
              cmd = { "typescript-language-server", "--stdio" },
              root_dir = root_dir,
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                typescript = {
                  inlayHints = {
                    includeInlayParameterNameHints = "literal",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                },
                javascript = {
                  inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                },
              },
            })
          elseif filetype == "rust" and not has_lsp_client(bufnr, "rust_analyzer") then
            -- Запускаем Rust LSP ТОЛЬКО если это Rust проект
            if is_rust_project(root_dir) then
              vim.lsp.start({
                name = "rust_analyzer",
                cmd = { "rust-analyzer" },
                root_dir = root_dir,
                filetypes = {"rust"},
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                  ["rust-analyzer"] = {
                    checkOnSave = {
                      command = "clippy",
                    },
                    cargo = {
                      allFeatures = true,
                    },
                  },
                },
              })
            else
              -- Не запускаем rust-analyzer для одиночных Rust файлов
              vim.notify("Rust LSP не запущен: не найден Cargo.toml", vim.log.levels.INFO)
            end
          elseif (filetype == "sh" or filetype == "bash") and not has_lsp_client(bufnr, "bashls") then
            vim.lsp.start({
              name = "bashls",
              cmd = { "bash-language-server", "start" },
              root_dir = root_dir,
              capabilities = capabilities,
              on_attach = on_attach,
            })
          elseif (filetype == "json" or filetype == "jsonc") and not has_lsp_client(bufnr, "jsonls") then
            vim.lsp.start({
              name = "jsonls",
              cmd = { "vscode-json-language-server", "--stdio" },
              root_dir = root_dir,
              capabilities = capabilities,
              on_attach = on_attach,
            })
          elseif filetype == "html" and not has_lsp_client(bufnr, "html") then
            vim.lsp.start({
              name = "html",
              cmd = { "vscode-html-language-server", "--stdio" },
              root_dir = root_dir,
              capabilities = capabilities,
              on_attach = on_attach,
            })
          elseif (filetype == "css" or filetype == "scss" or filetype == "less") and not has_lsp_client(bufnr, "cssls") then
            vim.lsp.start({
              name = "cssls",
              cmd = { "vscode-css-language-server", "--stdio" },
              root_dir = root_dir,
              capabilities = capabilities,
              on_attach = on_attach,
            })
          elseif (filetype == "yaml" or filetype == "yml") and not has_lsp_client(bufnr, "yamlls") then
            vim.lsp.start({
              name = "yamlls",
              cmd = { "yaml-language-server", "--stdio" },
              root_dir = root_dir,
              capabilities = capabilities,
              on_attach = on_attach,
            })
          end
        end,
      })

      -- Настройки диагностики
      vim.diagnostic.config({
        virtual_text = {
          source = "if_many",
          prefix = "●",
        },
        signs = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
        },
      })

      -- Значки для диагностики
      -- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      -- for type, icon in pairs(signs) do
      --   local hl = "DiagnosticSign" .. type
      --   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      -- end

      -- Keymaps для диагностики
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })
    end,
  },
}
