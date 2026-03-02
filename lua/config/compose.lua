-- Docker Compose: команды из любого буфера (поиск корня по compose-файлу вверх по путям).
-- Поддержка мержа конфигов: compose.yml + compose.dev.yml / compose.prod.yml через -f.

local M = {}

local compose_files = { "compose.yml", "compose.yaml", "docker-compose.yml", "docker-compose.yaml" }
M.override = nil -- "dev", "prod" и т.д. — подставляется как -f compose.yml -f compose.<override>.yml

function M.find_root()
  local start = vim.fn.expand("%:p:h")
  if start == "" or start == "." then
    start = vim.fn.getcwd()
  end
  local dir = start
  while dir ~= "/" and dir ~= "" do
    for _, name in ipairs(compose_files) do
      if vim.fn.filereadable(dir .. "/" .. name) == 1 then
        return dir
      end
    end
    dir = vim.fs.dirname(dir)
  end
  return nil
end

-- Строка аргументов -f для текущего root и выбранного override
function M.files_args(root)
  local base = nil
  for _, name in ipairs(compose_files) do
    if vim.fn.filereadable(root .. "/" .. name) == 1 then
      base = name
      break
    end
  end
  if not base then return nil end
  local args = " -f " .. vim.fn.shellescape(base)
  if M.override and M.override ~= "" then
    local override_yml = "compose." .. M.override .. ".yml"
    local override_yaml = "compose." .. M.override .. ".yaml"
    if vim.fn.filereadable(root .. "/" .. override_yml) == 1 then
      args = args .. " -f " .. vim.fn.shellescape(override_yml)
    elseif vim.fn.filereadable(root .. "/" .. override_yaml) == 1 then
      args = args .. " -f " .. vim.fn.shellescape(override_yaml)
    else
      vim.notify("Compose: не найден " .. override_yml .. " / " .. override_yaml, vim.log.levels.WARN)
    end
  end
  return args
end

function M.compose_cmd()
  if vim.fn.executable("podman-compose") == 1 and vim.fn.executable("docker") == 0 then
    return "podman-compose"
  end
  return "docker compose"
end

function M.run(subcmd)
  local root = M.find_root()
  if not root then
    vim.notify("Compose: не найден compose.yml / docker-compose.yml вверх по пути", vim.log.levels.WARN)
    return
  end
  local fargs = M.files_args(root)
  if not fargs then
    vim.notify("Compose: не найден базовый конфиг в " .. root, vim.log.levels.WARN)
    return
  end
  compose = compose or M.compose_cmd()
  local cmd = compose .. fargs .. " " .. subcmd
  local full = "cd " .. vim.fn.shellescape(root) .. " && " .. cmd
  vim.cmd("split | terminal " .. full)
end

-- Глобальные комбинации (работают без открытого compose-файла)
local compose = nil

local function dc(cmd)
  M.run(cmd)
end

-- up / down / ps / build / restart
vim.keymap.set("n", "<leader>dcu", function() dc("up -d") end, { desc = "Compose up -d" })
vim.keymap.set("n", "<leader>dcU", function() dc("up") end, { desc = "Compose up" })
vim.keymap.set("n", "<leader>dcd", function() dc("down") end, { desc = "Compose down" })
vim.keymap.set("n", "<leader>dcr", function() dc("restart") end, { desc = "Compose restart" })
vim.keymap.set("n", "<leader>dcp", function() dc("ps") end, { desc = "Compose ps" })
vim.keymap.set("n", "<leader>dcb", function() dc("build") end, { desc = "Compose build" })

-- logs -f: запрос сервиса (пусто = все)
vim.keymap.set("n", "<leader>dcl", function()
  local service = vim.fn.input("Service (empty=all): ")
  local sub = "logs -f"
  if service ~= "" then sub = sub .. " " .. vim.fn.shellescape(service) end
  M.run(sub)
end, { desc = "Compose logs -f [service]" })

-- exec
vim.keymap.set("n", "<leader>dce", function()
  local service = vim.fn.input("Service: ")
  if service == "" then return end
  local shell = vim.fn.input("Shell [sh]: ")
  if shell == "" then shell = "sh" end
  M.run("exec " .. vim.fn.shellescape(service) .. " " .. vim.fn.shellescape(shell))
end, { desc = "Compose exec" })

-- run
vim.keymap.set("n", "<leader>dcR", function()
  local service = vim.fn.input("Service: ")
  if service == "" then return end
  local cmd = vim.fn.input("Command [sh]: ")
  if cmd == "" then cmd = "sh" end
  M.run("run --rm " .. vim.fn.shellescape(service) .. " " .. vim.fn.shellescape(cmd))
end, { desc = "Compose run" })

-- выбор override для мержа: dev, prod и т.д. (compose.yml + compose.<override>.yml)
vim.keymap.set("n", "<leader>dco", function()
  local hint = M.override and (" [" .. M.override .. "]") or " [none]"
  local v = vim.fn.input("Override (dev/prod/...)" .. hint .. ": ")
  if v ~= "" then
    M.override = v
    vim.notify("Compose override: " .. v, vim.log.levels.INFO)
  else
    if M.override then
      M.override = nil
      vim.notify("Compose override: сброшен", vim.log.levels.INFO)
    end
  end
end, { desc = "Compose override (dev/prod)" })

return M
