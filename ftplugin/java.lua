local jdtls = require('jdtls')
local jdtls_setup = require('jdtls.setup')

-- Robust root detection
local root_dir = jdtls_setup.find_root({ 'pom.xml', 'mvnw', 'gradlew', 'build.gradle', 'build.gradle.kts', '.git' })
if not root_dir then
  vim.notify('[jdtls] No project root found. Skipping.', vim.log.levels.WARN)
  return
end

-- Ensure only the good server remains (kill any plain "jdtls")
local function ensure_single_jdtls()
  for _, c in ipairs(vim.lsp.get_clients()) do
    if c.name == 'jdtls' then
      local cmd0 = (c.config and c.config.cmd and c.config.cmd[1]) or ''
      if cmd0 == 'jdtls' then
        c.stop(true) -- kill rogue plain binary
      end
    end
  end
end
ensure_single_jdtls()

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
jdtls.start_or_attach({
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
  on_attach = function()
    jdtls.setup_dap({ hotcodereplace = 'auto' })
    require('jdtls.dap').setup_dap_main_class_configs()
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'CursorHold', 'InsertLeave' }, {
      buffer = 0,
      group = vim.api.nvim_create_augroup('jdtls_codelens', { clear = true }),
      callback = function() pcall(vim.lsp.codelens.refresh) end,
    })
  end,
})
