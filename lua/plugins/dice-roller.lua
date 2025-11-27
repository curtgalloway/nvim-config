return {
  "dice-roller",
  dir = vim.fn.stdpath("config") .. "/lua/dice-roller",
  config = function()
    require("dice-roller").setup()
  end,
  keys = {
    { "<leader>dr", "<cmd>lua require('dice-roller').roll()<cr>", desc = "Roll dice" },
  },
}
