# Agent Guidelines for Neovim Configuration

## Build/Test Commands
- **No build system**: This is a Neovim configuration using Lazy.nvim package manager
- **Test single functionality**: Open nvim and test specific keybinds/plugins manually
- **Java testing**: Use `<leader>tc` (test class) or `<leader>tm` (test method) for Java files
- **Config reload**: `:source %` or restart nvim to test configuration changes

## Code Style & Conventions
- **Language**: Lua only
- **Indentation**: 2 spaces, no tabs (`opt.tabstop = 2`, `opt.shiftwidth = 2`)
- **Imports**: Use `require()` statements, group plugin configs in `lua/plugins/` directory
- **File structure**: Core config in `lua/core/`, plugins in `lua/plugins/`, filetype-specific in `ftplugin/`
- **Naming**: kebab-case for plugin files (e.g., `nvim-lspconfig.lua`), snake_case for variables
- **Comments**: Use `--` for single line, minimal commenting unless complex logic
- **Keymaps**: Use `vim.keymap.set()`, leader key is space, group related maps logically
- **Plugin config**: Return table format with lazy.nvim spec, include dependencies and config functions
- **Options**: Use `vim.opt` for global options, `vim.bo` for buffer-local options
- **Error handling**: Let nvim handle errors naturally, avoid unnecessary pcall wrapping
- **LSP setup**: Use mason.nvim for LSP installation, configure via lspconfig, jdtls handled separately in ftplugin