-- Code outline sidebar
return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  keys = {
    { "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial (outline)" },
    { "{", "<cmd>AerialPrev<CR>", desc = "Previous symbol (Aerial)" },
    { "}", "<cmd>AerialNext<CR>", desc = "Next symbol (Aerial)" },
  },
  opts = {
    -- Priority list of preferred backends for aerial.
    backends = { "treesitter", "lsp", "markdown", "man" },

    layout = {
      max_width = { 40, 0.2 },
      width = nil,
      min_width = 20,
      win_opts = {},
      default_direction = "prefer_right",
      placement = "window",
      resize_to_content = true,
      preserve_equality = false,
    },

    attach_mode = "window",

    -- Determines line highlighting mode when aerial is attached
    highlight_mode = "split_width",

    -- Highlight the closest symbol if the cursor is not exactly on one.
    highlight_closest = true,

    -- Highlight the symbol in the source buffer when cursor is in the aerial win
    highlight_on_hover = false,

    -- When jumping to a symbol, highlight the line for this many ms
    highlight_on_jump = 300,

    -- Define symbol icons
    icons = {
      Array = " ",
      Boolean = "󰨙 ",
      Class = " ",
      Constant = "󰏿 ",
      Constructor = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Function = "󰊕 ",
      Interface = " ",
      Key = " ",
      Method = "󰊕 ",
      Module = " ",
      Namespace = "󰦮 ",
      Null = " ",
      Number = "󰎠 ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      String = " ",
      Struct = "󰆼 ",
      TypeParameter = " ",
      Variable = "󰀫 ",
    },

    -- Determines how the aerial window decides which symbols to display.
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Module",
      "Method",
      "Struct",
    },

    -- Use symbol tree for folding. Set to true or false to enable/disable
    manage_folds = false,

    -- Set to false to remove the default keybindings for the aerial buffer
    keymaps = {
      ["?"] = "actions.show_help",
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.jump",
      ["<2-LeftMouse>"] = "actions.jump",
      ["<C-v>"] = "actions.jump_vsplit",
      ["<C-s>"] = "actions.jump_split",
      ["p"] = "actions.scroll",
      ["<C-j>"] = "actions.down_and_scroll",
      ["<C-k>"] = "actions.up_and_scroll",
      ["{"] = "actions.prev",
      ["}"] = "actions.next",
      ["[["] = "actions.prev_up",
      ["]]"] = "actions.next_up",
      ["q"] = "actions.close",
      ["o"] = "actions.tree_toggle",
      ["za"] = "actions.tree_toggle",
      ["O"] = "actions.tree_toggle_recursive",
      ["zA"] = "actions.tree_toggle_recursive",
      ["l"] = "actions.tree_open",
      ["zo"] = "actions.tree_open",
      ["L"] = "actions.tree_open_recursive",
      ["zO"] = "actions.tree_open_recursive",
      ["h"] = "actions.tree_close",
      ["zc"] = "actions.tree_close",
      ["H"] = "actions.tree_close_recursive",
      ["zC"] = "actions.tree_close_recursive",
      ["zr"] = "actions.tree_increase_fold_level",
      ["zR"] = "actions.tree_open_all",
      ["zm"] = "actions.tree_decrease_fold_level",
      ["zM"] = "actions.tree_close_all",
      ["zx"] = "actions.tree_sync_folds",
      ["zX"] = "actions.tree_sync_folds",
    },

    lsp = {
      diagnostics_trigger_update = true,
      update_when_errors = true,
      update_delay = 300,
    },

    treesitter = {
      update_delay = 300,
    },

    markdown = {
      update_delay = 300,
    },

    -- Call this function when aerial attaches to a buffer.
    on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
      vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
    end,

    -- Automatically open aerial when entering supported buffers
    open_automatic = false,

    -- Run this command after jumping to a symbol
    post_jump_cmd = "normal! zz",

    -- When true, aerial will automatically close after jumping to a symbol
    close_on_select = false,

    -- The autocmds that trigger symbols update (not used for LSP backend)
    update_events = "TextChanged,InsertLeave",

    -- Show box drawing characters for the tree hierarchy
    show_guides = true,

    -- Customize the characters used when show_guides = true
    guides = {
      mid_item = "├─",
      last_item = "└─",
      nested_top = "│ ",
      whitespace = "  ",
    },

    -- Set this function to override the highlight groups for certain symbols
    get_highlight = function(symbol, is_icon, is_collapsed)
      -- return "MyHighlight" .. symbol.kind
    end,

    -- Options for opening aerial in a floating win
    float = {
      border = "rounded",
      relative = "cursor",
      max_height = 0.9,
      height = nil,
      min_height = { 8, 0.1 },
      override = function(conf, source_winid)
        return conf
      end,
    },

    -- Options for the floating nav windows
    nav = {
      border = "rounded",
      max_height = 0.9,
      min_height = { 10, 0.1 },
      max_width = 0.5,
      min_width = { 0.2, 20 },
      win_opts = {
        cursorline = true,
        winblend = 10,
      },
      autojump = false,
      preview = false,
      keymaps = {
        ["<CR>"] = "actions.jump",
        ["<2-LeftMouse>"] = "actions.jump",
        ["<C-v>"] = "actions.jump_vsplit",
        ["<C-s>"] = "actions.jump_split",
        ["h"] = "actions.left",
        ["l"] = "actions.right",
        ["<C-c>"] = "actions.close",
      },
    },
  },
}
