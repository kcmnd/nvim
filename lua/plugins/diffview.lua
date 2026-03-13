return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('diffview').setup()

    -- Open diff of all current changes vs HEAD
    vim.keymap.set('n', '<leader>gd', '<CMD>DiffviewOpen<CR>', { desc = 'Git diff view' })
    -- Full git log with per-commit diffs
    vim.keymap.set('n', '<leader>gl', '<CMD>DiffviewFileHistory<CR>', { desc = 'Git file history (repo)' })
    -- Git log for just the current file
    vim.keymap.set('n', '<leader>gf', '<CMD>DiffviewFileHistory %<CR>', { desc = 'Git file history (current file)' })
    -- Close diffview
    vim.keymap.set('n', '<leader>gx', '<CMD>DiffviewClose<CR>', { desc = 'Close diff view' })
  end,
}
