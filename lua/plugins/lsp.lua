return {
  'neovim/nvim-lspconfig',
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    local lspconfig = require('lspconfig')

    -- Python
    lspconfig.pyright.setup({
      capabilities = capabilities
    })

    -- Lua
    lspconfig.lua_ls.setup({
      capabilities = capabilities
    })

    -- JS
    lspconfig.ts_ls.setup({
      capabilities = capabilities
    })

    -- HTML
    lspconfig.html.setup({
      capabilities = capabilities
    })

    -- CSS
    lspconfig.cssls.setup({
      capabilities = capabilities
    })

    -- Java
    lspconfig.jdtls.setup({
      capabilities = capabilities
    })

    -- Go
    lspconfig.gopls.setup({
      capabilities = capabilities
    })

    vim.diagnostic.config({
      virtual_text = false, -- disables inline diagnostics
      signs = true,
      underline = true,
      float = {
        show_header = true,
        source = "always",
        border = "rounded",
        focusable = false,
      },
    })

    vim.o.updatetime = 250
    vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })]]
  end
}
