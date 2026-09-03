return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
    config = function()
      vim.keymap.set("i", "<C-CR>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion",
      })
    end,
  },

  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    build = "bundled_build.lua",
    config = function()
      require("mcphub").setup({
        config = vim.fn.stdpath("config") .. "/mcp-servers.json",
        use_bundled_binary = true,
        auto_approve = false,
        extensions = {
          copilotchat = {
            enabled = true,
            convert_tools_to_functions = true,
            convert_resources_to_functions = true,
            add_mcp_prefix = false,
          },
        },
      })
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "ravitemer/mcphub.nvim" },
    opts = {
      auto_insert_mode = true,
      tools = { "file", "glob", "grep" },
      resources = "buffer:active",
      window = {
        layout = "vertical",
        width = 0.45,
      },
    },
    cmd = { "CopilotChat", "CopilotChatOpen" },
  },
}