local M = {}

local function setup_git_autocmds()
  local git_group = vim.api.nvim_create_augroup("git_integration", { clear = true })

  -- Автоматически обновлять gitsigns при изменениях
  vim.api.nvim_create_autocmd({"BufWritePost", "TextChanged"}, {
    pattern = "*",
    callback = function()
      if vim.b.gitsigns_head then
        require('gitsigns').refresh()
      end
    end,
    group = git_group,
    desc = "Refresh gitsigns on file change"
  })

  -- Настройки для fugitive buffers
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "fugitive",
    callback = function()
      -- Закрытие fugitive buffer с q
      vim.keymap.set('n', 'q', '<cmd>bd<CR>', { buffer = true, desc = "Close fugitive buffer" })
    end,
    group = git_group,
    desc = "Settings for fugitive buffers"
  })

  -- Показывать текущую ветку в статусной строке (если используете lualine)
  vim.api.nvim_create_autocmd({"BufEnter", "DirChanged"}, {
    pattern = "*",
    callback = function()
      vim.b.git_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\\n'")
    end,
    group = git_group,
    desc = "Update git branch info"
  })
  --
  -- Пользовательские Git команды
  vim.api.nvim_create_user_command("GitAddCommit", function()
    vim.cmd("Git add .")
    vim.cmd("Git commit")
  end, { desc = "Add all and commit" })

  vim.api.nvim_create_user_command("GitAddCommitPush", function()
    vim.cmd("Git add .")
    vim.cmd("Git commit")
    vim.cmd("Git push")
  end, { desc = "Add all, commit and push" })
end

local function setup_indent_autocmds()
  local indent_group = vim.api.nvim_create_augroup("custom_indentation", { clear = true })

  -- Функция для применения настроек отступов
  local function set_indentation(ts, sw)
    vim.bo.tabstop = ts
    vim.bo.shiftwidth = sw
    vim.bo.autoindent = true
    vim.bo.expandtab = true
    -- vim.bo.softtabstop = ts
    -- vim.bo.smartindent = true
  end

  -- 4 пробела
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "css", "sh", "dockerfile", "cpp", "perl" },
    callback = function()
      set_indentation(4, 4)
    end,
    group = indent_group,
    desc = "Set 4-space indentation"
  })

  -- 2 пробела
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "html", "htmldjango", "typescript" },
    callback = function()
      set_indentation(2, 2)
    end,
    group = indent_group,
    desc = "Set 2-space indentation"
  })

  -- Можно добавить дополнительные настройки отступов
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua" },
    callback = function()
      set_indentation(2, 2)
    end,
    group = indent_group,
    desc = "Set 2-space indentation for Lua"
  })

  -- Makefiles должны использовать табы
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "make" },
    callback = function()
      set_indentation(4, 4)
    end,
    group = indent_group,
    desc = "Set tab indentation for Makefiles"
  })

  -- Автокоманды для Fugitive
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "fugitive",
    callback = function()
      -- Keymaps для fugitive buffers
      vim.keymap.set('n', 'q', '<cmd>bd<CR>', { buffer = true, desc = "Close fugitive buffer" })
    end,
  })
end

function M.setup()
  setup_indent_autocmds()
  setup_git_autocmds()
end

if not M._setup_called then
  M.setup()
  M._setup_called = true
end

return M
