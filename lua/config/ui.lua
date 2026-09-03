local M = {}

local function is_project_dir(path)
  if not path or path == "" then
    return false
  end

  local stat = vim.loop.fs_stat(path)
  if not stat or stat.type ~= "directory" then
    return false
  end

  for _, marker in ipairs({ ".git", "pom.xml", "build.gradle", "mvnw", "package.json" }) do
    if vim.loop.fs_stat(path .. "/" .. marker) then
      return true
    end
  end

  return false
end

function M.project_name()
  if #vim.fn.argv() == 0 and not is_project_dir(vim.fn.getcwd()) then
    return ""
  end

  local dir = vim.fn.getcwd()
  return vim.fn.fnamemodify(dir, ":t") or "project"
end

function M.lsp_status()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    return "LSP: none (idle)"
  end

  local parts = {}
  for _, client in ipairs(clients) do
    local state = client.is_stopped and "stopped" or "running"
    table.insert(parts, client.name .. " (" .. state .. ")")
  end

  return "LSP: " .. table.concat(parts, ", ")
end

function M.mode()
  local modes = {
    n = { name = "NORMAL", highlight = "StatusModeNormal" },
    i = { name = "INSERT", highlight = "StatusModeInsert" },
    R = { name = "REPLACE", highlight = "StatusModeReplace" },
    v = { name = "VISUAL", highlight = "StatusModeVisual" },
    V = { name = "V-LINE", highlight = "StatusModeVisual" },
    ["\022"] = { name = "V-BLOCK", highlight = "StatusModeVisual" },
    c = { name = "COMMAND", highlight = "StatusModeCommand" },
    t = { name = "TERMINAL", highlight = "StatusModeTerminal" },
    s = { name = "SELECT", highlight = "StatusModeVisual" },
    S = { name = "S-LINE", highlight = "StatusModeVisual" },
    ["\019"] = { name = "S-BLOCK", highlight = "StatusModeVisual" },
  }

  local mode = modes[vim.fn.mode(1)] or modes.n
  return string.format("%%#%s# %s %%*", mode.highlight, mode.name)
end

function M.nvim_version()
  local version = vim.version()
  return string.format("%d.%d.%d", version.major, version.minor, version.patch)
end

vim.api.nvim_set_hl(0, "Normal", { bg = "#1f2329" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "#1f2329" })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3e4451" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#2c323c", fg = "#abb2bf" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#2c323c", fg = "#7c8596" })
vim.api.nvim_set_hl(0, "StatusModeNormal", { bg = "#61afef", fg = "#1f2329", bold = true })
vim.api.nvim_set_hl(0, "StatusModeInsert", { bg = "#98c379", fg = "#1f2329", bold = true })
vim.api.nvim_set_hl(0, "StatusModeReplace", { bg = "#e06c75", fg = "#1f2329", bold = true })
vim.api.nvim_set_hl(0, "StatusModeVisual", { bg = "#c678dd", fg = "#1f2329", bold = true })
vim.api.nvim_set_hl(0, "StatusModeCommand", { bg = "#e5c07b", fg = "#1f2329", bold = true })
vim.api.nvim_set_hl(0, "StatusModeTerminal", { bg = "#56b6c2", fg = "#1f2329", bold = true })
vim.api.nvim_set_hl(0, "Title", { fg = "#E06C75", bold = true })

vim.o.laststatus = 3
vim.o.winbar = "%#StatusLine# %{%v:lua.require'config.ui'.project_name()%}%=%#StatusLine# [ erdos-vim ] [ neovim ] %{%v:lua.require'config.ui'.nvim_version()%} %*"
vim.o.statusline = " %{%v:lua.require'config.ui'.mode()%} %#StatusLine#%{%v:lua.require'config.ui'.lsp_status()%}%=%#StatusLineNC# %f%*"

return M
