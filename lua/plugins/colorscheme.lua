return {
  "kcmnd/miasma.nvim-transparent",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.miasma_transparent = 1 -- Enable transparency
    vim.cmd("colorscheme miasma")
  end,
}
