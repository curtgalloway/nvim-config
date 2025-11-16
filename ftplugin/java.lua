local jdtls = require('jdtls')
local jdtls_setup = require('jdtls.setup')

-- Robust root detection
local root_dir = jdtls_setup.find_root({ 'pom.xml', 'mvnw', 'gradlew', 'build.gradle', 'build.gradle.kts', '.git' })
if not root_dir then
  vim.notify('[jdtls] No project root found. Skipping.', vim.log.levels.WARN)
  return
end

-- Get current buffer
local bufnr = vim.api.nvim_get_current_buf()

-- Check if jdtls is already attached to this specific buffer
local existing_clients = vim.lsp.get_clients({ bufnr = bufnr, name = 'jdtls' })
if #existing_clients > 0 then
  -- Already attached to this buffer, don't attach again
  return
end

-- Workspace & launcher
local project   = vim.fn.fnamemodify(root_dir, ':t')
local workspace = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project

local launcher = vim.fn.glob(
  vim.env.HOME .. '/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher_*.jar',
  1, 1
)[1]
if not launcher or launcher == '' then
  vim.notify('[jdtls] Launcher JAR not found', vim.log.levels.ERROR)
  return
end

-- Debug/test bundles (optional)
local bundles = {}
local dbg = vim.fn.glob(vim.env.HOME .. '/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar')
if dbg ~= '' then table.insert(bundles, dbg) end
vim.list_extend(bundles, vim.fn.glob(vim.env.HOME .. '/.local/share/nvim/mason/share/java-test/*.jar', 1, 1))

-- Java runtime configuration
local java_runtime_path = vim.env.JAVA_21_HOME or '/home/cgalloway/Downloads/amazon-corretto-21.0.1.12.1-linux-x64/'
local java_runtimes = {}
if vim.fn.isdirectory(java_runtime_path) == 1 then
  table.insert(java_runtimes, { name = 'JavaSE-21', path = java_runtime_path })
end

-- Capabilities
local caps = require('cmp_nvim_lsp').default_capabilities()

-- Start OR attach
local client_id = jdtls.start_or_attach({
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true', '-Dlog.level=ALL',
    '-javaagent:' .. vim.env.HOME .. '/.local/share/nvim/mason/share/jdtls/lombok.jar',
    '-Xmx4g', '--add-modules=ALL-SYSTEM',
    '--add-opens','java.base/java.util=ALL-UNNAMED',
    '--add-opens','java.base/java.lang=ALL-UNNAMED',
    '-jar', launcher,
    '-configuration', vim.env.HOME .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
    '-data', workspace,
  },
  root_dir = root_dir,
  capabilities = caps,
  init_options = { bundles = bundles },
  settings = {
    java = {
      eclipse = { downloadSources = true },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = java_runtimes,
      },
    },
  },
  on_attach = function(client, buffer)
    -- Setup DAP
    jdtls.setup_dap({ hotcodereplace = 'auto' })
    require('jdtls.dap').setup_dap_main_class_configs()

    -- Setup codelens
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'CursorHold', 'InsertLeave' }, {
      buffer = buffer,
      group = vim.api.nvim_create_augroup('jdtls_codelens_' .. buffer, { clear = true }),
      callback = function()
        pcall(vim.lsp.codelens.refresh)
      end,
    })

    -- Trigger initial codelens refresh
    vim.defer_fn(function()
      pcall(vim.lsp.codelens.refresh, { bufnr = buffer })
    end, 500)
  end,
})

-- nvim-jdtls sometimes doesn't attach the client automatically
-- Check after a short delay and manually attach if needed
if client_id then
  vim.defer_fn(function()
    local attached_clients = vim.lsp.get_clients({ bufnr = bufnr, name = 'jdtls' })
    if #attached_clients == 0 then
      -- Manually attach the client to the buffer
      vim.lsp.buf_attach_client(bufnr, client_id)
    end
  end, 500)
end
