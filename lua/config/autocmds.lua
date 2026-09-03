local function has_project_session()
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") or "project"
  local session_path = vim.fn.stdpath("data") .. "/sessions/" .. project_name .. ".vim"
  return vim.fn.filereadable(session_path) == 1
end

local function show_erdos_vim_splash()
  if #vim.fn.argv() > 0 or has_project_session() then
    return
  end

  vim.api.nvim_set_hl(0, "ErdosTitle", { fg = "#E06C75", bold = true, italic = false })

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "ERDOS-VIM" })

  local width = 12
  local row = math.floor(vim.o.lines / 8)
  local col = math.floor((vim.o.columns - width) / 2)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = 1,
    style = "minimal",
    border = "single",
  })

  vim.api.nvim_win_set_option(win, "winhl", "Normal:ErdosTitle")

  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, 2500)
end

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = show_erdos_vim_splash,
})
