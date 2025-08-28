return {
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  dependencies = {
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    { 'folke/neodev.nvim' },
  },
  config = function()
    require('mason').setup()

    local lspconfig = require('lspconfig')
    local caps = require('cmp_nvim_lsp').default_capabilities()

    -- Configure all servers via mason-lspconfig handlers  
    require('mason-lspconfig').setup({
      ensure_installed = {
        'bashls','cssls','html','gradle_ls','groovyls','lua_ls',
        'jsonls','lemminx','marksman','quick_lint_js','yamlls',
        -- jdtls excluded - managed separately via ftplugin
      },
      handlers = {
        -- Default handler for all servers
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = caps,
          })
        end,
        -- No jdtls handler needed since it's not in ensure_installed
      },
    })

    -- Manually install jdtls via mason but don't configure it
    require('mason-tool-installer').setup({
      ensure_installed = {
        'jdtls', -- Install but don't configure
      },
    })

    -- Optional lua tweaks
    lspconfig.lua_ls.setup({
      capabilities = caps,
      settings = { Lua = { diagnostics = { globals = { 'vim' } } } },
    })
  end
}
