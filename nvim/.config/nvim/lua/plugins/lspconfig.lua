return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {"cssls", "emmet_language_server", "html", "jsonls", "lua_ls"},
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local servers = { "cssls", "emmet_language_server", "html", "jsonls", "lua_ls", "ruby_lsp"}
      for _, server in ipairs(servers) do
        lspconfig[server].setup({})
      end

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { noremap = true, silent = true, desc = "Go To Definition" })
      vim.keymap.set('n', '<leader>gr', vim.lsp.buf.rename, { noremap = true, silent = true, desc = "LSP Rename"})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = 'Code Action' })
    end
  }
}
