return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()

    local ensure_installed = { "pyright", "lua_ls", "ts_ls", "html", "cssls" }
    if vim.fn.executable("go") == 1 then
      table.insert(ensure_installed, "gopls")
    end
    if vim.fn.executable("java") == 1 then
      table.insert(ensure_installed, "jdtls")
    end

    require("mason-lspconfig").setup({
      ensure_installed = ensure_installed,
      automatic_installation = true,
    })
  end
}
