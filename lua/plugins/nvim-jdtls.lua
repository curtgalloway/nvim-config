-- Loader only. All startup logic lives in ftplugin/java.lua
return { 
  'mfussenegger/nvim-jdtls', 
  ft = { 'java' },
  config = function()
    -- Disable automatic setup - we handle everything in ftplugin/java.lua
    -- This prevents nvim-jdtls from creating its own LSP configuration
  end
}

