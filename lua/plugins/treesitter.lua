return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",  -- Explicitly use main branch
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")

    -- Install parsers you want
    local parsers = {
      "c",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "python",
      "javascript",
      "typescript",
      "html",
      "css",
      "bash",
      "json",
      "markdown",
    }

    -- Install parsers (async, won't block startup)
    ts.install(parsers)

    -- Enable highlighting via autocmd (new API)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function()
        -- Only start if parser is available
        local lang = vim.treesitter.language.get_lang(vim.bo.filetype) or vim.bo.filetype
        if pcall(vim.treesitter.language.inspect, lang) then
          vim.treesitter.start()
        end
      end,
    })

    -- Enable indentation (experimental)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- Optional: Enable folding
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo.foldmethod = 'expr'
    vim.opt.foldlevel = 99  -- Don't fold by default
  end,
}
