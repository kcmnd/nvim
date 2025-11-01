return {
  'neovim/nvim-lspconfig',
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Python
    vim.lsp.config.pyright = {
      capabilities = capabilities
    }

    -- Lua
    vim.lsp.config.lua_ls = {
      capabilities = capabilities
    }

    -- JS/TS
    vim.lsp.config.ts_ls = {
      capabilities = capabilities
    }

    -- HTML
    vim.lsp.config.html = {
      capabilities = capabilities
    }

    -- CSS
    vim.lsp.config.cssls = {
      capabilities = capabilities
    }

    -- Java
    vim.lsp.config.jdtls = {
      capabilities = capabilities
    }

    -- Go
    vim.lsp.config.gopls = {
      capabilities = capabilities
    }

    -- Enable LSP servers
    vim.lsp.enable({'pyright', 'lua_ls', 'ts_ls', 'html', 'cssls', 'jdtls', 'gopls'})

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
