local M = {}

function M.setup()
  -- Создаем augroup
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
end

if not M._setup_called then
  M.setup()
  M._setup_called = true
end

return M
