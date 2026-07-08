local M = {}

local function setup_terminal_protocol_fixes()
  local term_group = vim.api.nvim_create_augroup("terminal_protocol_fixes", { clear = true })

  -- Work around duplicated Enter/Backspace/Tab in some terminals (e.g. Alacritty)
  -- caused by the kitty keyboard protocol "report event types" mode.
  --
  -- References:
  -- - https://github.com/alacritty/alacritty/issues/8385
  -- - https://github.com/neovim/neovim/issues/31814
  local function force_safe_keyboard_mode()
    -- Workaround: force kitty keyboard protocol into mode 1 (disambiguate only).
    -- This disables "report event types" (mode 3) which can cause duplicate
    -- Enter/Backspace/Tab in some terminals.
    io.stdout:write("\027[>1u")
  end

  local function restore_keyboard_mode()
    -- Restore previous mode (pop).
    io.stdout:write("\027[<1u")
  end

  vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "FocusGained" }, {
    group = term_group,
    callback = force_safe_keyboard_mode,
    desc = "Force kitty keyboard protocol mode 1 (avoid duplicate keys)",
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = term_group,
    callback = restore_keyboard_mode,
    desc = "Restore previous keyboard mode",
  })
end

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
  setup_terminal_protocol_fixes()
  setup_indent_autocmds()
  setup_git_autocmds()
end

if not M._setup_called then
  M.setup()
  M._setup_called = true
end

return M
