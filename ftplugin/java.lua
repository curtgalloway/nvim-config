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

-- Java runtime configuration (cross-platform)
local java_runtime_path = vim.env.JAVA_21_HOME or vim.env.JAVA_HOME
local java_runtimes = {}
if java_runtime_path and vim.fn.isdirectory(java_runtime_path) == 1 then
  table.insert(java_runtimes, { name = 'JavaSE-21', path = java_runtime_path })
end

-- Capabilities
local caps = require('cmp_nvim_lsp').default_capabilities()

-- Detect platform for jdtls configuration
local config_dir = 'config_linux'
if vim.fn.has('mac') == 1 then
  config_dir = 'config_mac'
elseif vim.fn.has('win32') == 1 then
  config_dir = 'config_win'
end

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
    '-configuration', vim.env.HOME .. '/.local/share/nvim/mason/packages/jdtls/' .. config_dir,
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

    -- Java-specific keybindings
    vim.keymap.set('n', '<leader>di', "<Cmd>lua require'jdtls'.organize_imports()<CR>",
      { buffer = buffer, desc = 'Organize Imports' })
    vim.keymap.set('n', '<leader>dt', "<Cmd>lua require'jdtls'.test_class()<CR>",
      { buffer = buffer, desc = 'Test Class' })
    vim.keymap.set('n', '<leader>dn', "<Cmd>lua require'jdtls'.test_nearest_method()<CR>",
      { buffer = buffer, desc = 'Test Nearest Method' })
    vim.keymap.set('n', '<leader>de', "<Cmd>lua require'jdtls'.extract_variable()<CR>",
      { buffer = buffer, desc = 'Extract Variable' })
    vim.keymap.set('v', '<leader>de', "<Esc><Cmd>lua require'jdtls'.extract_variable(true)<CR>",
      { buffer = buffer, desc = 'Extract Variable' })
    vim.keymap.set('v', '<leader>dm', "<Esc><Cmd>lua require'jdtls'.extract_method(true)<CR>",
      { buffer = buffer, desc = 'Extract Method' })
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
