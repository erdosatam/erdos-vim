local M = {}

local project_session_dir = vim.fn.stdpath("data") .. "/sessions"

local function get_project_key(project_dir)
  return vim.fn.fnamemodify(project_dir or vim.fn.getcwd(), ":t") or "project"
end

local function get_session_path(project_dir)
  vim.fn.mkdir(project_session_dir, "p")
  return project_session_dir .. "/" .. get_project_key(project_dir) .. ".vim"
end

local function remove_copilot_chat_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) == "copilot-chat" then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

local function is_project_like_dir(path)
  if path == nil or path == "" then
    return false
  end

  local stat = vim.loop.fs_stat(path)
  if not stat or stat.type ~= "directory" then
    return false
  end

  local markers = { ".git", "pom.xml", "build.gradle", "mvnw", "package.json" }
  for _, marker in ipairs(markers) do
    if vim.loop.fs_stat(path .. "/" .. marker) then
      return true
    end
  end

  return false
end

function M.save_session()
  local session_path = get_session_path(vim.fn.getcwd())
  local files = vim.fn.argv()
  remove_copilot_chat_buffers()
  if #files > 0 then
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,localoptions,tabpages,winsize,terminal,globals"
    vim.cmd("mksession! " .. vim.fn.fnameescape(session_path))
    return
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and vim.api.nvim_buf_get_name(buf) ~= "" then
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,localoptions,tabpages,winsize,terminal,globals"
      vim.cmd("mksession! " .. vim.fn.fnameescape(session_path))
      return
    end
  end
end

function M.restore_session(project_dir)
  local session_path = get_session_path(project_dir)
  if vim.fn.filereadable(session_path) == 0 then
    return
  end

  remove_copilot_chat_buffers()
  vim.cmd("source " .. vim.fn.fnameescape(session_path))
  remove_copilot_chat_buffers()
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    M.save_session()
  end,
})

vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "*",
  callback = function()
    if is_project_like_dir(vim.fn.getcwd()) then
      M.restore_session(vim.fn.getcwd())
    end
  end,
})

return M
