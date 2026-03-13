return {
  'nvim-telescope/telescope.nvim', branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').setup({
      defaults = {
        preview = {
          treesitter = false, -- ft_to_lang was removed in newer neovim/treesitter
        },
        -- Skip neo-tree and other non-file windows when opening selections
        get_selection_window = function()
          local wins = vim.api.nvim_list_wins()
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft ~= 'neo-tree' and ft ~= 'TelescopePrompt' then
              return win
            end
          end
          return 0
        end,
      },
    })

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Telescope git status' })
  end,
}
