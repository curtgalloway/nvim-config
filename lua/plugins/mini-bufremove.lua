-- Better buffer deletion without closing windows
return {
  "echasnovski/mini.bufremove",
  version = "*",
  keys = {
    { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete buffer" },
    { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete buffer (force)" },
  },
  opts = {
    -- Whether to set Vim's settings for buffers (allow hidden buffers)
    set_vim_settings = true,
    -- Whether to disable showing non-error feedback
    silent = false,
  },
}
