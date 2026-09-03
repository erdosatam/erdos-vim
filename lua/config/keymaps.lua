vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neotree" })
vim.keymap.set("n", "ff", ":Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "gg", function()
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.85)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " LazyGit ",
    title_pos = "center",
  })

  vim.fn.termopen({ "lazygit" }, {
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        elseif vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end)
    end,
  })

  vim.bo[buf].buflisted = false
  vim.cmd("startinsert")
end, { desc = "Open LazyGit" })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Move left" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Move down" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Move up" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Move right" })
vim.cmd([[cnoreabbrev <expr> ca getcmdtype() ==# ':' && getcmdline() ==# 'ca' ? 'lua vim.lsp.buf.code_action()' : 'ca']])
vim.cmd([[cnoreabbrev <expr> gi getcmdtype() ==# ':' && getcmdline() ==# 'gi' ? 'lua vim.lsp.buf.implementation()' : 'gi']])
vim.cmd([[cnoreabbrev <expr> gr getcmdtype() ==# ':' && getcmdline() ==# 'gr' ? 'lua vim.lsp.buf.references()' : 'gr']])
vim.cmd([[cnoreabbrev <expr> gco getcmdtype() ==# ':' && getcmdline() ==# 'gco' ? 'CopilotChatOpen' : 'gco']])

vim.keymap.set("n", "<leader>/", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "Search in buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Close buffer" })
