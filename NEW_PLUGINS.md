# New QoL Plugins - Quick Reference

All plugins have been installed and configured. Restart Neovim to load them.

## High Priority Plugins

### 1. which-key.nvim
**What it does:** Shows available keybindings as you type
**How to use:** Just start typing a leader sequence (e.g., `<leader>f`) and wait 500ms - a popup will show all available commands
**Groups configured:** Find, LSP, Debug, Breakpoints, Harpoon, Splits, Explorer, Tabs/Tests, Quickfix, Write/Save, Git

### 2. gitsigns.nvim
**What it does:** Git change indicators in sign column + hunk actions
**Key bindings:**
- `]h` / `[h` - Next/previous git hunk
- `<leader>cs` - Stage hunk
- `<leader>cr` - Reset hunk
- `<leader>cS` - Stage entire buffer
- `<leader>cP` - Preview hunk
- `<leader>cB` - Blame line (full)
- `<leader>cd` - Diff this
- `ih` (text object) - Select hunk (visual/operator)

### 3. trouble.nvim
**What it does:** Beautiful UI for diagnostics, quickfix, and LSP results
**Key bindings:**
- `<leader>xx` - Toggle diagnostics
- `<leader>xX` - Toggle buffer diagnostics
- `<leader>xs` - Symbols
- `<leader>xl` - LSP definitions/references
- `<leader>xL` - Location list
- `<leader>xQ` - Quickfix list

### 4. flash.nvim
**What it does:** Jump to any visible location with 2-3 keystrokes
**Key bindings:**
- `s` - Flash jump (normal/visual/operator mode)
- `S` - Flash Treesitter jump
- `r` - Remote flash (operator mode)
- `R` - Treesitter search (operator/visual)
- `<C-s>` - Toggle flash search (command mode)

## Medium Priority Plugins

### 5. nvim-notify
**What it does:** Better notifications with history
**Key bindings:**
- `<leader>fn` - View notification history (Telescope)
- `<leader>nd` - Dismiss all notifications
**Auto-enabled:** All Neovim notifications now use this

### 6. neotest
**What it does:** Testing UI with visual indicators in gutter
**Key bindings:**
- `<leader>tn` - Run nearest test
- `<leader>tf` - Run file tests
- `<leader>td` - Debug nearest test
- `<leader>ts` - Stop test
- `<leader>to` - Show test output
- `<leader>tO` - Toggle output panel
- `<leader>tS` - Toggle test summary
- `]t` / `[t` - Next/previous failed test

**Note:** Works alongside your existing `<leader>tc` and `<leader>tm` JDTLS test commands

### 7. aerial.nvim
**What it does:** Code outline sidebar showing classes, methods, functions
**Key bindings:**
- `<leader>a` - Toggle aerial outline
- `{` / `}` - Previous/next symbol (when in aerial window)

### 8. nvim-spectre
**What it does:** Advanced project-wide find and replace with preview
**Key bindings:**
- `<leader>sr` - Open Spectre (replace in files)
- `<leader>sw` - Replace current word
- `<leader>sp` - Replace in current file

**In Spectre window:**
- `dd` - Toggle line
- `<CR>` - Open file
- `<leader>R` - Replace all
- `<leader>rc` - Replace current line
- `<leader>o` - Show options

### 9. todo-comments.nvim
**What it does:** Highlights TODO, FIXME, NOTE, etc. in comments
**Key bindings:**
- `]d` / `[d` - Next/previous todo comment
- `<leader>ft` - Find all todos (Telescope)
- `<leader>xT` - View todos in Trouble

**Keywords recognized:** TODO, FIXME, BUG, HACK, WARN, PERF, NOTE, TEST

### 10. mini.bufremove
**What it does:** Delete buffers without closing windows
**Key bindings:**
- `<leader>bd` - Delete buffer (preserves window)
- `<leader>bD` - Delete buffer (force)

## Next Steps

1. **Restart Neovim** - Lazy.nvim will install all plugins automatically
2. **Try which-key** - Type `<leader>` and wait to see your keybindings
3. **Test flash.nvim** - Press `s` in normal mode and type a few characters
4. **Check gitsigns** - Open a file in a git repo and look for signs in the gutter
5. **Use Trouble** - Press `<leader>xx` to see diagnostics in a nice UI

## Integration Notes

- **which-key** displays your existing keybinding groups beautifully
- **gitsigns** complements your existing git-blame plugin
- **trouble** enhances your quickfix workflow
- **neotest** works alongside your JDTLS test commands
- **nvim-notify** captures all notifications (including JDTLS messages)
- **todo-comments** integrates with Telescope and Trouble

All plugins are configured to match your existing:
- Dark Kanagawa theme
- Rounded borders preference
- Keyboard-only workflow
- Mnemonic keybinding system
