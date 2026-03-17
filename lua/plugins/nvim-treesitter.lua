return {
  -- https://github.com/nvim-treesitter/nvim-treesitter
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- IMPORTANT: keep legacy API
  build = ":TSUpdate",

  -- Load before things like Telescope use it
  event = { "BufReadPost", "BufNewFile" },

  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },

  opts = {
    highlight = {
      enable = true,
    },

    indent = {
      enable = true,
    },

    auto_install = true,

    ensure_installed = {
      "lua",
      "java",
      "comment",
      "typescript",
      "tsx",
      "html",
      "css",
      "json",
      "markdown",
      "bash",
      "yaml",
      "xml",
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  },

  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
