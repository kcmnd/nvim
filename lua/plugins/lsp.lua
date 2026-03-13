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

    -- Java (only if available)
    if vim.fn.executable("java") == 1 then
      vim.lsp.config.jdtls = { capabilities = capabilities }
    end

    -- Go (only if available)
    if vim.fn.executable("go") == 1 then
      vim.lsp.config.gopls = { capabilities = capabilities }
    end

    -- Enable LSP servers (conditionally include runtime-dependent ones)
    local servers = { 'pyright', 'lua_ls', 'ts_ls', 'html', 'cssls' }
    if vim.fn.executable("java") == 1 then table.insert(servers, 'jdtls') end
    if vim.fn.executable("go") == 1 then table.insert(servers, 'gopls') end
    vim.lsp.enable(servers)

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

    -- Toggle for diagnostic float on hover
    local diag_float_enabled = true
    local function toggle_diagnostic_float()
      if diag_float_enabled then
        vim.api.nvim_clear_autocmds({ group = "DiagnosticFloat" })
        diag_float_enabled = false
        print("Diagnostic float disabled")
      else
        vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
        vim.api.nvim_create_autocmd("CursorHold", {
          group = "DiagnosticFloat",
          callback = function()
            vim.diagnostic.open_float(nil, { focusable = false })
          end
        })
        diag_float_enabled = true
        print("Diagnostic float enabled")
      end
    end

    -- Enable by default
    vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      group = "DiagnosticFloat",
      callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
      end
    })

    -- Keymap to toggle
    vim.keymap.set('n', '<leader>td', toggle_diagnostic_float, { desc = 'Toggle diagnostic float on hover' })
  end
}
