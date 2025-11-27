-- Keybinding popup helper
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 500, -- delay before showing the popup (ms)
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    win = {
      border = "rounded",
      padding = { 1, 2 },
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Register your leader key groups for better organization
    wk.add({
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>g", group = "LSP/Go to" },
      { "<leader>d", group = "Debug (DAP)" },
      { "<leader>b", group = "Breakpoints" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>s", group = "Splits" },
      { "<leader>e", group = "Explorer" },
      { "<leader>t", group = "Tabs/Tests" },
      { "<leader>q", group = "Quickfix" },
      { "<leader>w", group = "Write/Save" },
      { "<leader>c", group = "Git/Merge Conflicts" },
    })
  end,
}
