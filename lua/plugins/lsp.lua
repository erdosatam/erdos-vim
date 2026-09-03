return {
  {
    "williamboman/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "jdtls", "jsonls", "yamlls" },
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      local java_cfg = vim.fn.readfile(vim.fn.stdpath("config") .. "/lua/lspconfig/java-lsp.json")
      local parsed = vim.fn.json_decode(table.concat(java_cfg, "\n")) or {}
      local java_home = (parsed.java_home and parsed.java_home ~= "..") and parsed.java_home or (vim.fn.getenv("JAVA_HOME") or "/usr/lib/jvm/default-java")
      local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
      local config_dir = vim.fn.stdpath("data") .. "/mason/packages/jdtls/config"
      local lombok_jar = vim.fn.stdpath("data") .. "/lombok/lombok.jar"

      local function ensure_lombok()
        if vim.fn.filereadable(lombok_jar) == 1 then
          return lombok_jar
        end

        vim.fn.mkdir(vim.fn.fnamemodify(lombok_jar, ":h"), "p")
        vim.fn.system({
          "curl",
          "--fail",
          "--location",
          "--output",
          lombok_jar,
          "https://projectlombok.org/downloads/lombok.jar",
        })

        if vim.v.shell_error ~= 0 then
          vim.fn.delete(lombok_jar)
          vim.notify("Unable to download Lombok for JDTLS", vim.log.levels.WARN)
          return nil
        end

        return lombok_jar
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function(args)
          local root_dir = vim.fs.root(vim.api.nvim_buf_get_name(args.buf), { ".git", "pom.xml", "build.gradle", "mvnw" })
          if not root_dir then
            root_dir = vim.fn.getcwd()
          end

          local capabilities = require("cmp_nvim_lsp").default_capabilities()
          local lombok = ensure_lombok()
          local cmd = {
            jdtls_bin,
            "-configuration",
            config_dir,
            "-data",
            vim.fn.stdpath("cache") .. "/jdtls/workspace",
          }

          if lombok then
            table.insert(cmd, 2, "-javaagent:" .. lombok)
          end

          require("jdtls").start_or_attach({
            cmd = cmd,
            capabilities = capabilities,
            root_dir = root_dir,
            settings = {
              java = {
                configuration = {
                  runtimes = {
                    {
                      name = "JavaSE-17",
                      path = java_home,
                    },
                  },
                },
              },
            },
            init_options = {
              bundles = {},
            },
          })
        end,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("jsonls", {})
      vim.lsp.config("yamlls", {})
      vim.lsp.enable({ "jsonls", "yamlls" })
    end,
  },
}
