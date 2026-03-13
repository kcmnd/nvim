return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = 'markdown',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('render-markdown').setup({})

    -- Toggle between raw markdown and rendered view
    vim.keymap.set('n', '<leader>tm', '<CMD>RenderMarkdown toggle<CR>', { desc = 'Toggle markdown render' })
  end,
}
