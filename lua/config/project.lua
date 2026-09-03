local M = {}

local function list_dirs(path)
  local entries = {}
  local stat = vim.loop.fs_stat(path)
  if not stat or stat.type ~= "directory" then
    return entries
  end

  local handle = vim.loop.fs_scandir(path)
  if not handle then
    return entries
  end

  while true do
    local name = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end

    local full_path = path .. "/" .. name
    local item = vim.loop.fs_stat(full_path)
    if item and item.type == "directory" then
      table.insert(entries, full_path)
    end
  end

  table.sort(entries)
  return entries
end

function M.pick_project()
  local cwd = vim.fn.getcwd()
  local parent = vim.fn.fnamemodify(cwd, ":h")
  local all = {}
  local seen = {}

  for _, dir in ipairs(list_dirs(parent)) do
    if not seen[dir] then
      seen[dir] = true
      table.insert(all, dir)
    end
  end

  if not seen[cwd] then
    table.insert(all, 1, cwd)
  end

  table.insert(all, 1, parent)

  vim.ui.select(all, {
    prompt = "Select project directory:",
    format_item = function(item)
      return vim.fn.fnamemodify(item, ":t")
    end,
  }, function(choice)
    if not choice then
      return
    end

    local target = vim.fs.normalize(choice)
    vim.fn.chdir(target)
    vim.cmd("cd " .. vim.fn.fnameescape(target))

    local ok, _ = pcall(vim.cmd, "Neotree reveal")
    if not ok then
      pcall(vim.cmd, "Neotree toggle")
    end

    vim.notify("Project: " .. target, vim.log.levels.INFO)
  end)
end

vim.api.nvim_create_user_command("Po", function()
  M.pick_project()
end, { desc = "Choose project directory" })

vim.cmd([[cnoreabbrev <expr> po getcmdtype() ==# ':' && getcmdline() ==# 'po' ? 'Po' : 'po']])

return M
