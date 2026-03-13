vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.wo.number = true
vim.wo.relativenumber = true

require("config.lazy")

require("kc.remap")

-- Disable heavy features for large files (>1MB)
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function(args)
    local size = vim.fn.getfsize(args.file)
    if size > 10 * 1024 * 1024 then
      vim.bo[args.buf].swapfile = false
      vim.bo[args.buf].undofile = false
      vim.b[args.buf].large_file = true
      vim.cmd("syntax off")
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    if vim.b[args.buf].large_file then
      vim.treesitter.stop(args.buf)
    end
  end,
})
