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
      "cpp",
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
      "toml",
      "yaml",
      "markdown",
    }

    -- Only install parsers that aren't already available
    local missing = vim.tbl_filter(function(lang)
      return not pcall(vim.treesitter.language.inspect, lang)
    end, parsers)
    if #missing > 0 then
      ts.install(missing)
    end

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
