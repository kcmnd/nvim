return {
  "kcmnd/miasma.nvim-transparent",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.miasma_transparent = 1 -- Enable transparency
    vim.cmd("colorscheme miasma")
  end,
}

-- return {
--   "theJian/nvim-moonwalk",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.o.background = "light"           -- Ensure light mode
--     vim.cmd("colorscheme moonwalk")      -- Apply the Moonwalk theme
--
--     -- Make core UI elements transparent
--     vim.cmd [[
--       highlight Normal guibg=NONE ctermbg=NONE
--       highlight NormalNC guibg=NONE ctermbg=NONE
--       highlight EndOfBuffer guibg=NONE ctermbg=NONE
--       highlight VertSplit guibg=NONE ctermbg=NONE
--       highlight StatusLine guibg=NONE ctermbg=NONE
--       highlight StatusLineNC guibg=NONE ctermbg=NONE
--       highlight SignColumn guibg=NONE ctermbg=NONE
--       highlight LineNr guibg=NONE ctermbg=NONE
--       highlight FoldColumn guibg=NONE ctermbg=NONE
--       highlight CursorLine guibg=NONE ctermbg=NONE
--     ]]
--   end,
-- }
