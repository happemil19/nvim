-- Python: ruff (lint + format), mypy, интеграция с uv
return {
  -- Асинхронный линтинг: ruff + mypy
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require("lint")

      -- Поиск корня проекта (как в lsp.lua)
      local function find_project_root(filename)
        local markers = { ".git", "pyproject.toml", "setup.py", "ruff.toml" }
        local dir = vim.fs.dirname(filename)
        while dir ~= "/" and dir ~= "" do
          for _, marker in ipairs(markers) do
            local path = dir .. "/" .. marker
            if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1 then
              return dir
            end
          end
          dir = vim.fs.dirname(dir)
        end
        return vim.fs.dirname(filename)
      end

      lint.linters_by_ft = {
        python = { "ruff", "mypy" },
      }

      -- Запуск линтеров с cwd = корень проекта (важно для mypy и ruff)
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        pattern = "*.py",
        callback = function(args)
          local bufnr = args.buf
          local filename = vim.api.nvim_buf_get_name(bufnr)
          if filename == "" then return end
          local root = find_project_root(filename)
          lint.try_lint(nil, { cwd = root })
        end,
      })
    end,
  },

  -- Форматирование: ruff format (встроенный в conform)
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufWritePre" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_format" },
        },
      })

      -- Форматирование: <leader>fm в Python-буфере
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          vim.keymap.set("n", "<leader>fm", function()
            require("conform").format({ async = true, lsp_fallback = true })
          end, { buffer = true, desc = "Format with Ruff" })
        end,
      })
    end,
  },
}
