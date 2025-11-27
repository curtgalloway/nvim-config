-- Git change indicators and actions
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = '│' },
      change       = { text = '│' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = false, -- You already have git-blame plugin
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 1000,
      ignore_whitespace = false,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
      border = 'rounded',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation (keep your existing cn/cp, add alternatives)
      map('n', ']h', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, {expr=true, desc = 'Next git hunk'})

      map('n', '[h', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {expr=true, desc = 'Previous git hunk'})

      -- Actions (integrate with your <leader>c prefix)
      map('n', '<leader>cs', gs.stage_hunk, { desc = 'Stage hunk' })
      map('n', '<leader>cr', gs.reset_hunk, { desc = 'Reset hunk' })
      map('v', '<leader>cs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Stage hunk (visual)' })
      map('v', '<leader>cr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Reset hunk (visual)' })
      map('n', '<leader>cS', gs.stage_buffer, { desc = 'Stage buffer' })
      map('n', '<leader>cu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
      map('n', '<leader>cR', gs.reset_buffer, { desc = 'Reset buffer' })
      map('n', '<leader>cP', gs.preview_hunk, { desc = 'Preview hunk' })
      map('n', '<leader>cB', function() gs.blame_line{full=true} end, { desc = 'Blame line (full)' })
      map('n', '<leader>cd', gs.diffthis, { desc = 'Diff this' })
      map('n', '<leader>cD', function() gs.diffthis('~') end, { desc = 'Diff this ~' })

      -- Text object
      map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
    end
  },
}
