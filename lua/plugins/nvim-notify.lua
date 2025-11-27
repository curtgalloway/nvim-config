-- Better notifications with history
return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  opts = {
    timeout = 3000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { zindex = 100 })
    end,
    background_colour = "#000000",
    fps = 30,
    icons = {
      DEBUG = "",
      ERROR = "",
      INFO = "",
      TRACE = "✎",
      WARN = ""
    },
    level = 2,
    minimum_width = 50,
    render = "wrapped-compact",
    stages = "fade_in_slide_out",
    time_formats = {
      notification = "%T",
      notification_history = "%FT%T"
    },
    top_down = true
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)

    -- Set as default notify handler
    vim.notify = notify

    -- Keybinding to view notification history with Telescope
    vim.keymap.set("n", "<leader>fn", "<cmd>Telescope notify<cr>", { desc = "Notification History" })

    -- Keybinding to dismiss all notifications
    vim.keymap.set("n", "<leader>nd", function()
      notify.dismiss({ silent = true, pending = true })
    end, { desc = "Dismiss all notifications" })
  end,
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
}
