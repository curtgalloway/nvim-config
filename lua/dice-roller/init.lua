local M = {}

-- Store state
local state = {
  input_buf = nil,
  input_win = nil,
  result_buf = nil,
  result_win = nil,
  last_result = nil,
  history = {},
}

-- Create a centered floating window
local function create_float(title, width, height, row_offset)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  local ui = vim.api.nvim_list_uis()[1]
  local win_width = width
  local win_height = height
  local col = math.floor((ui.width - win_width) / 2)
  local row = math.floor((ui.height - win_height) / 2) + row_offset

  local opts = {
    relative = 'editor',
    width = win_width,
    height = win_height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
    title = title,
    title_pos = 'center',
  }

  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_win_set_option(win, 'winhl', 'Normal:Normal,FloatBorder:FloatBorder')

  return buf, win
end

-- Execute roll command
local function execute_roll(formula)
  local handle = io.popen('roll ' .. vim.fn.shellescape(formula) .. ' 2>&1')
  if not handle then
    return nil, "Failed to execute roll command"
  end

  local result = handle:read("*a")
  local success = handle:close()

  if not success or result == "" then
    return nil, "Roll command failed"
  end

  -- Trim whitespace
  result = result:gsub("^%s*(.-)%s*$", "%1")

  return result, nil
end

-- Update result window
local function update_result(formula, result, error_msg)
  if not state.result_buf or not vim.api.nvim_buf_is_valid(state.result_buf) then
    return
  end

  local lines = {}

  if error_msg then
    lines = {
      "Error: " .. error_msg,
      "",
      "Formula: " .. formula,
    }
  else
    table.insert(state.history, 1, { formula = formula, result = result })
    if #state.history > 10 then
      table.remove(state.history)
    end
    state.last_result = result

    lines = {
      "Formula: " .. formula,
      "Result:  " .. result,
      "",
      "Press 'i' to insert result at cursor",
      "Press 'y' to yank result",
      "Press 'q' or <Esc> to close",
      "",
      "Recent rolls:",
    }

    for i, entry in ipairs(state.history) do
      if i <= 5 then
        table.insert(lines, string.format("  %s = %s", entry.formula, entry.result))
      end
    end
  end

  vim.api.nvim_buf_set_option(state.result_buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(state.result_buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(state.result_buf, 'modifiable', false)
end

-- Handle dice roll
local function do_roll()
  local formula = vim.api.nvim_buf_get_lines(state.input_buf, 0, 1, false)[1]

  if not formula or formula == "" then
    update_result("", "", "Please enter a dice formula (e.g., 2d6+3)")
    return
  end

  local result, err = execute_roll(formula)

  if err then
    update_result(formula, "", err)
  else
    update_result(formula, result, nil)
  end
end

-- Insert result at cursor in original buffer
local function insert_result()
  if not state.last_result then
    return
  end

  -- Close windows
  M.close()

  -- Insert at cursor position
  local pos = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local new_line = line:sub(1, pos[2]) .. state.last_result .. line:sub(pos[2] + 1)
  vim.api.nvim_set_current_line(new_line)

  -- Move cursor after inserted text
  vim.api.nvim_win_set_cursor(0, {pos[1], pos[2] + #state.last_result})
end

-- Yank result to clipboard
local function yank_result()
  if not state.last_result then
    return
  end

  vim.fn.setreg('+', state.last_result)
  vim.notify("Yanked: " .. state.last_result, vim.log.levels.INFO)
end

-- Close all windows
function M.close()
  if state.input_win and vim.api.nvim_win_is_valid(state.input_win) then
    vim.api.nvim_win_close(state.input_win, true)
  end
  if state.result_win and vim.api.nvim_win_is_valid(state.result_win) then
    vim.api.nvim_win_close(state.result_win, true)
  end

  state.input_buf = nil
  state.input_win = nil
  state.result_buf = nil
  state.result_win = nil
end

-- Set up keymaps for the floating windows
local function setup_keymaps()
  local opts = { buffer = state.input_buf, silent = true }

  -- Roll the dice
  vim.keymap.set('n', '<CR>', do_roll, opts)
  vim.keymap.set('i', '<CR>', function()
    vim.cmd('stopinsert')
    do_roll()
  end, opts)

  -- Close
  vim.keymap.set('n', 'q', M.close, opts)
  vim.keymap.set('n', '<Esc>', M.close, opts)

  -- Result window keymaps
  local result_opts = { buffer = state.result_buf, silent = true }
  vim.keymap.set('n', 'i', insert_result, result_opts)
  vim.keymap.set('n', 'y', yank_result, result_opts)
  vim.keymap.set('n', 'q', M.close, result_opts)
  vim.keymap.set('n', '<Esc>', M.close, result_opts)
end

-- Main roll function
function M.roll()
  -- Create input window
  state.input_buf, state.input_win = create_float(" Roll Dice ", 50, 1, -4)

  -- Create result window
  state.result_buf, state.result_win = create_float(" Result ", 50, 12, 0)

  -- Make result buffer read-only
  vim.api.nvim_buf_set_option(state.result_buf, 'modifiable', false)

  -- Set up keymaps
  setup_keymaps()

  -- Focus input window and enter insert mode
  vim.api.nvim_set_current_win(state.input_win)
  vim.cmd('startinsert')

  -- Show initial instructions
  update_result("", "", "Enter dice formula (e.g., 2d6+3, 1d20, 3d8-2)")
end

function M.setup()
  -- Plugin setup if needed
end

return M
