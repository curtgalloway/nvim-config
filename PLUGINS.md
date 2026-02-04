# Neovim Plugins Documentation

This document provides a comprehensive overview of all plugins installed in this Neovim configuration.

---

## Table of Contents
- [Code Navigation & Structure](#code-navigation--structure)
- [LSP & Language Support](#lsp--language-support)
- [Autocompletion & Snippets](#autocompletion--snippets)
- [Fuzzy Finding & Search](#fuzzy-finding--search)
- [Testing & Debugging](#testing--debugging)
- [Git Integration](#git-integration)
- [File Management](#file-management)
- [UI & Visual Enhancements](#ui--visual-enhancements)
- [Editing & Text Manipulation](#editing--text-manipulation)
- [Tmux Integration](#tmux-integration)
- [Database Management](#database-management)
- [REST Client](#rest-client)
- [Utilities](#utilities)

---

## Code Navigation & Structure

### aerial.nvim
**Repository:** `stevearc/aerial.nvim`  
**Purpose:** Code outline sidebar that displays document symbols (functions, classes, methods, etc.)  
**Key Features:**
- Tree-based code structure view
- Uses Treesitter and LSP for symbol extraction
- Navigate between symbols with `{` and `}`
- Toggle with `<leader>a`
- Customizable symbol icons and filtering

### barbecue.nvim
**Repository:** `utilyre/barbecue.nvim`  
**Purpose:** LSP-based breadcrumbs in the winbar  
**Dependencies:** nvim-navic, nvim-web-devicons  
**Key Features:**
- Shows current code context (class > method > etc.)
- Updates automatically as you navigate code

### flash.nvim
**Repository:** `folke/flash.nvim`  
**Purpose:** Enhanced motion/jump navigation with labeled targets  
**Key Features:**
- Quick jump to any visible location with `s`
- Treesitter-aware jumps with `S`
- Enhanced `f`, `F`, `t`, `T` motions
- Search integration with label overlays

### harpoon
**Repository:** `ThePrimeagen/harpoon`  
**Purpose:** Quick file marking and navigation system  
**Key Features:**
- Mark frequently used files per project
- Rapid switching between favorite files
- Project-specific file lists

---

## LSP & Language Support

### nvim-lspconfig
**Repository:** `neovim/nvim-lspconfig`  
**Purpose:** Collection of configurations for the Nvim LSP client  
**Dependencies:** Mason, mason-lspconfig, mason-tool-installer, neodev  
**Configured Servers:**
- Bash (bashls)
- CSS (cssls)
- HTML (html)
- Gradle (gradle_ls)
- Groovy (groovyls)
- Lua (lua_ls)
- JSON (jsonls)
- XML (lemminx)
- Markdown (marksman)
- JavaScript (quick_lint_js)
- YAML (yamlls)
- TypeScript/Angular (ts_ls/angularls - conditionally loaded based on project type)

**Key Features:**
- Automatic LSP server installation via Mason
- Inlay hints enabled globally
- Project-type detection for TypeScript projects
- Capabilities integration with nvim-cmp

### nvim-jdtls
**Repository:** `mfussenegger/nvim-jdtls`  
**Purpose:** Java LSP support using Eclipse JDT Language Server  
**Key Features:**
- Configured separately in `ftplugin/java.lua`
- Java-specific debugging and testing support
- Integration with nvim-dap for debugging

### mason.nvim
**Repository:** `williamboman/mason.nvim`  
**Purpose:** Package manager for LSP servers, DAP servers, linters, and formatters  
**Key Features:**
- Easy installation and management of language tools
- Automatic installation of configured servers

### neodev.nvim
**Repository:** `folke/neodev.nvim`  
**Purpose:** Neovim Lua API completion and documentation  
**Key Features:**
- Full Lua LSP support for Neovim config development
- Autocomplete for vim.api, vim.fn, etc.

---

## Autocompletion & Snippets

### nvim-cmp
**Repository:** `hrsh7th/nvim-cmp`  
**Purpose:** Autocompletion engine  
**Dependencies:**
- LuaSnip (snippet engine)
- cmp_luasnip (snippet source)
- cmp-nvim-lsp (LSP source)
- friendly-snippets (snippet collection)
- cmp-buffer (buffer text source)
- cmp-path (file path source)
- cmp-cmdline (command-line source)

**Key Mappings:**
- `<C-j>/<C-k>` - Navigate suggestions
- `<C-Space>` - Trigger completion
- `<CR>` - Confirm selection
- `<Tab>/<S-Tab>` - Navigate completions and snippet placeholders

### LuaSnip
**Repository:** `L3MON4D3/LuaSnip`  
**Purpose:** Snippet engine for Neovim  
**Key Features:**
- VSCode-style snippet support
- Loads friendly-snippets collection
- Expandable and jumpable placeholders

---

## Fuzzy Finding & Search

### telescope.nvim
**Repository:** `nvim-telescope/telescope.nvim`  
**Purpose:** Highly extendable fuzzy finder  
**Dependencies:** plenary.nvim, telescope-fzf-native.nvim  
**Key Features:**
- Find files, grep text, search buffers
- LSP references and definitions
- Git integration
- Extensible with many pickers

### nvim-spectre
**Repository:** `nvim-pack/nvim-spectre`  
**Purpose:** Advanced find and replace across files  
**Key Mappings:**
- `<leader>sr` - Open Spectre
- `<leader>sw` - Replace word under cursor
- `<leader>sp` - Replace in current file

**Key Features:**
- Visual find/replace interface
- Regex support
- Live preview of changes
- Integration with ripgrep

---

## Testing & Debugging

### neotest
**Repository:** `nvim-neotest/neotest`  
**Purpose:** Testing framework with interactive UI  
**Dependencies:** neotest-java (Java adapter)  
**Key Mappings:**
- `<leader>tn` - Run nearest test
- `<leader>tf` - Run file tests
- `<leader>td` - Debug nearest test
- `<leader>tS` - Toggle test summary
- `<leader>to` - Show test output

**Key Features:**
- Real-time test execution
- Visual test status indicators
- Debug integration
- Test output panel

### nvim-dap
**Repository:** `mfussenegger/nvim-dap`  
**Purpose:** Debug Adapter Protocol client  
**Key Features:**
- Debugging support for multiple languages
- Breakpoints, step through, variable inspection
- Configured for Java with multiple launch/attach configs

### nvim-dap-ui
**Repository:** `rcarriga/nvim-dap-ui`  
**Purpose:** UI for nvim-dap  
**Dependencies:** nvim-nio, nvim-dap-virtual-text, telescope-dap  
**Key Features:**
- Scopes, stacks, watches, and breakpoints panels
- REPL and console windows
- Automatic UI open/close on debug sessions

### nvim-dap-virtual-text
**Repository:** `theHamsta/nvim-dap-virtual-text`  
**Purpose:** Inline variable values during debugging  
**Key Features:**
- Shows variable values as virtual text
- Formatted as comments for clarity

---

## Git Integration

### gitsigns.nvim
**Repository:** `lewis6991/gitsigns.nvim`  
**Purpose:** Git change indicators in the sign column  
**Key Mappings:**
- `]h/[h` - Next/previous hunk
- `<leader>cs` - Stage hunk
- `<leader>cr` - Reset hunk
- `<leader>cP` - Preview hunk
- `<leader>cB` - Blame line (full)
- `ih` - Select hunk text object

**Key Features:**
- Visual indicators for added/changed/deleted lines
- Stage/unstage/reset hunks
- Inline blame information
- Hunk navigation

### git-blame.nvim
**Repository:** `f-person/git-blame.nvim`  
**Purpose:** Display git blame information inline  
**Key Features:**
- Shows commit author and date
- Disabled by default, can be toggled
- Concise date format

---

## File Management

### nvim-tree.lua
**Repository:** `nvim-tree/nvim-tree.lua`  
**Purpose:** File explorer tree  
**Dependencies:** nvim-web-devicons  
**Key Features:**
- Tree-based file navigation
- Create, delete, rename files/folders
- Git status integration
- Replaces netrw

### mini.bufremove
**Repository:** `echasnovski/mini.bufremove`  
**Purpose:** Delete buffers without closing windows  
**Key Mappings:**
- `<leader>bd` - Delete current buffer
- `<leader>bD` - Force delete buffer

**Key Features:**
- Preserves window layout when deleting buffers
- Smart buffer switching

---

## UI & Visual Enhancements

### kanagawa.nvim
**Repository:** `rebelot/kanagawa.nvim`  
**Purpose:** Colorscheme (dragon variant with custom palette)  
**Key Features:**
- Dark theme with warm tones
- Transparent background enabled
- Custom diff and border colors
- Highly customized color palette

### lualine.nvim
**Repository:** `nvim-lualine/lualine.nvim`  
**Purpose:** Statusline  
**Dependencies:** nvim-web-devicons, lsp-progress.nvim  
**Key Features:**
- Shows file path (parent/filename)
- File status indicators
- LSP loading progress
- Uses "codedark" theme

### indent-blankline.nvim
**Repository:** `lukas-reineke/indent-blankline.nvim`  
**Purpose:** Indentation guides  
**Key Features:**
- Visual vertical lines showing indentation levels
- Helps with code structure visibility

### nvim-notify
**Repository:** `rcarriga/nvim-notify`  
**Purpose:** Enhanced notification system with history  
**Key Mappings:**
- `<leader>fn` - View notification history (Telescope)
- `<leader>nd` - Dismiss all notifications

**Key Features:**
- Animated notification popups
- Notification history
- Custom icons for different levels
- Replaces vim.notify

### which-key.nvim
**Repository:** `folke/which-key.nvim`  
**Purpose:** Displays available keybindings in a popup  
**Key Features:**
- Shows possible key combinations after a delay
- Organized leader key groups
- Helps with keybinding discovery
- Supports marks, registers, spelling suggestions

### nvim-web-devicons
**Repository:** `nvim-tree/nvim-web-devicons`  
**Purpose:** File type icons  
**Key Features:**
- Provides icons for various file types
- Used by many other plugins

---

## Editing & Text Manipulation

### nvim-autopairs
**Repository:** `windwp/nvim-autopairs`  
**Purpose:** Auto-close brackets, parentheses, quotes  
**Key Features:**
- Treesitter integration
- Context-aware pairing
- Works in insert mode

### nvim-surround
**Repository:** `kylechui/nvim-surround`  
**Purpose:** Add, change, delete surrounding characters  
**Key Features:**
- Quickly wrap text in quotes, brackets, tags
- Change surrounding pairs
- Delete surrounding characters

### vim-commentary
**Repository:** `tpope/vim-commentary`  
**Purpose:** Toggle code comments  
**Key Features:**
- Comment/uncomment lines with `gc`
- Works with visual selections
- Language-aware commenting

### nvim-treesitter
**Repository:** `nvim-treesitter/nvim-treesitter`  
**Purpose:** Advanced syntax highlighting and code understanding  
**Dependencies:** nvim-treesitter-textobjects  
**Key Features:**
- Better syntax highlighting
- Incremental selection with `<C-Space>`
- Code-aware editing
- Supports multiple languages (Lua, Java, TypeScript, HTML, CSS, JSON, etc.)

---

## Tmux Integration

### vim-tmux-navigator
**Repository:** `christoomey/vim-tmux-navigator`  
**Purpose:** Seamless navigation between Vim and tmux panes  
**Key Features:**
- Use same keybinds to navigate Vim splits and tmux panes
- Only loads when tmux is detected
- Unified window navigation experience

---

## Database Management

### vim-dadbod
**Repository:** `tpope/vim-dadbod`  
**Purpose:** Database interface for Vim  
**Key Features:**
- Execute SQL queries
- Support for multiple database types
- Interactive database management

### vim-dadbod-ui
**Repository:** `kristijanhusak/vim-dadbod-ui`  
**Purpose:** UI for vim-dadbod  
**Commands:** `:DBUI`, `:DBUIToggle`  
**Key Features:**
- Tree-based database browser
- Connection management
- Query result viewing
- Nerd font icons enabled

### vim-dadbod-completion
**Repository:** `kristijanhusak/vim-dadbod-completion`  
**Purpose:** Database completion for dadbod  
**Key Features:**
- Autocomplete for SQL, MySQL, PLSQL
- Table and column suggestions

---

## REST Client

### vim-rest-console
**Repository:** `diepm/vim-rest-console`  
**Purpose:** REST API client within Neovim  
**Key Features:**
- Send HTTP requests from buffer
- JSON response formatting with jq
- Output to dedicated buffer
- No default keybindings (custom setup required)

---

## Utilities

### trouble.nvim
**Repository:** `folke/trouble.nvim`  
**Purpose:** Better diagnostics and quickfix list UI  
**Key Mappings:**
- `<leader>xx` - Toggle diagnostics
- `<leader>xX` - Buffer diagnostics
- `<leader>xs` - Symbols
- `<leader>xl` - LSP definitions/references
- `<leader>xQ` - Quickfix list

**Key Features:**
- Organized diagnostic view
- Quick navigation to errors
- Symbol browser
- Integration with LSP

### todo-comments.nvim
**Repository:** `folke/todo-comments.nvim`  
**Purpose:** Highlight and search TODO comments  
**Key Mappings:**
- `]d/[d` - Next/previous todo comment
- `<leader>ft` - Search todos with Telescope
- `<leader>xT` - Todo list in Trouble

**Keywords Supported:**
- FIX/FIXME/BUG
- TODO
- HACK
- WARN/WARNING
- PERF/OPTIM
- NOTE/INFO
- TEST

### quickfixdd
**Repository:** `TamaMcGlinn/quickfixdd`  
**Purpose:** Delete entries from quickfix list  
**Key Features:**
- Use `dd` to delete items from quickfix
- Makes quickfix list more manageable

### vim-maximizer
**Repository:** `szw/vim-maximizer`  
**Purpose:** Maximize and restore current window  
**Key Features:**
- Toggle window maximization
- Useful for focusing on single split

### hardtime.nvim
**Repository:** `m4xshen/hardtime.nvim`  
**Purpose:** Vim habit training  
**Key Features:**
- Discourages bad Vim habits (excessive j/k, arrow keys)
- Helps learn efficient movement patterns

### bigfile.nvim
**Repository:** `LunarVim/bigfile.nvim`  
**Purpose:** Performance optimization for large files  
**Key Features:**
- Disables heavy features for files > 2 MiB
- Prevents lag when opening large files

### plenary.nvim
**Repository:** `nvim-lua/plenary.nvim`  
**Purpose:** Lua utility library  
**Key Features:**
- Required dependency for many plugins
- Provides common Lua functions

### nui.nvim
**Repository:** `MunifTanjim/nui.nvim`  
**Purpose:** UI component library  
**Key Features:**
- Provides UI primitives for other plugins
- Used by hardtime and other UI-heavy plugins

### nvim-nio
**Repository:** `nvim-neotest/nvim-nio`  
**Purpose:** Async I/O library  
**Key Features:**
- Used by neotest and nvim-dap-ui
- Enables async operations

---

## Plugin Count Summary

**Total Plugins:** 61

### By Category:
- Code Navigation: 4
- LSP & Languages: 4
- Completion: 2
- Search/Find: 2
- Testing/Debug: 4
- Git: 2
- Files: 2
- UI/Visual: 7
- Editing: 4
- Tmux: 1
- Database: 3
- REST: 1
- Utilities: 8
- Dependencies (libraries): 17

---

*Last Updated: January 30, 2026*
