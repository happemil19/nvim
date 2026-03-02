-- Запуск текущего файла через uv run (если проект uv) или python
local function find_project_root(filename)
  local markers = { ".git", "pyproject.toml", "setup.py" }
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

local function run_current_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then return end
  local root = find_project_root(file)
  local pyproject = root .. "/pyproject.toml"
  local cmd
  if vim.fn.filereadable(pyproject) == 1 then
    cmd = "cd " .. vim.fn.shellescape(root) .. " && uv run python " .. vim.fn.shellescape(file)
  else
    cmd = "python " .. vim.fn.shellescape(file)
  end
  vim.cmd("split | terminal " .. cmd)
end

vim.keymap.set("n", "<leader>rr", run_current_file, { buffer = true, desc = "Run Python file (uv run or python)" })
