return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    { "folke/neodev.nvim" },
  },
  config = function()
    require("mason").setup()
    require("neodev").setup({})

    -- Enable inlay hints globally if supported
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp_attach_inlay_hints", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
      end,
    })

    -- Capabilities (use nvim-cmp if present)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    pcall(function()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    end)

    -- Helper: safely load a server's default_config from lspconfig
    local function lspconfig_default(server_name)
      -- This require returns a module with .default_config
      local ok, mod = pcall(require, "lspconfig.server_configurations." .. server_name)
      if ok and type(mod) == "table" and mod.default_config then
        return vim.deepcopy(mod.default_config)
      end
      -- Fallback empty config if unknown
      return {}
    end

    -- Define a server on the new API and autostart it by filetype
    local function define_server(server_name, overrides)
      local base = lspconfig_default(server_name)
      local cfg = vim.tbl_deep_extend("force", base, overrides or {})
      -- ensure capabilities are applied unless explicitly overridden
      cfg.capabilities = cfg.capabilities or capabilities

      vim.lsp.config[server_name] = cfg

      local fts = cfg.filetypes or {}
      if #fts > 0 then
        vim.api.nvim_create_autocmd("FileType", {
          group = vim.api.nvim_create_augroup("lsp_autostart_" .. server_name, { clear = true }),
          pattern = fts,
          callback = function(args)
            -- avoid duplicating a client on the same buffer
            local active = vim.lsp.get_clients({ bufnr = args.buf, name = server_name })
            if #active == 0 then
              vim.lsp.start(vim.lsp.config[server_name])
            end
          end,
        })
      end
    end

    -- Helper: detect project type
    local function detect_project_type(bufnr)
      local root = vim.fs.root(bufnr or 0, {'.git', 'package.json'})
      if not root then return nil end
      
      local package_json = root .. '/package.json'
      if vim.fn.filereadable(package_json) == 1 then
        local content = vim.fn.readfile(package_json)
        local json_str = table.concat(content, '\n')
        if json_str:match('"@angular/') then
          return 'angular'
        elseif json_str:match('"react"') then
          return 'react'
        end
      end
      return nil
    end

    -- Install LSP servers via Mason
    require("mason-lspconfig").setup({
      ensure_installed = {
        "bashls","cssls","html","gradle_ls","groovyls","lua_ls",
        "jsonls","lemminx","marksman","quick_lint_js","yamlls",
        "angularls","ts_ls",
        -- jdtls excluded – configured separately via ftplugin
      },
      automatic_installation = true,
      handlers = {
        -- default: define every installed server with our capabilities
        function(server_name)
          define_server(server_name, {})
        end,

        -- lua_ls with your tweaks
        ["lua_ls"] = function()
          define_server("lua_ls", {
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false },
              },
            },
          })
        end,

        -- Skip auto-setup for angularls and ts_ls - we handle them conditionally
        ["angularls"] = function() end,
        ["ts_ls"] = function() end,
      },
    })

    -- Install tools that we don't configure here (e.g., jdtls)
    require("mason-tool-installer").setup({
      ensure_installed = { "jdtls" },
      auto_update = false,
      run_on_start = false,
    })

    -- Explicitly disable lspconfig's auto-setup for jdtls
    -- We handle jdtls entirely in ftplugin/java.lua
    -- Set it to a minimal config with no filetypes so it never auto-starts
    vim.lsp.config.jdtls = {
      cmd = { 'jdtls' }, -- dummy, won't be used
      filetypes = {}, -- empty = never auto-start
      root_markers = {},
    }

    -- Conditional TypeScript LSP based on project type
    define_server("angularls", {})
    define_server("ts_ls", {})
    
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("lsp_typescript_conditional", { clear = true }),
      pattern = { "typescript", "typescriptreact" },
      callback = function(args)
        local project_type = detect_project_type(args.buf)
        local server_name = project_type == 'angular' and 'angularls' or 'ts_ls'
        
        local active = vim.lsp.get_clients({ bufnr = args.buf, name = server_name })
        if #active == 0 then
          vim.lsp.start(vim.lsp.config[server_name])
        end
      end,
    })
  end,
}

