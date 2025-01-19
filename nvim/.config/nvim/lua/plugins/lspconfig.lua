return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "cssls", "emmet_language_server", "html", "jsonls", "lua_ls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local servers = { "cssls", "emmet_language_server", "html", "jsonls", "lua_ls", "ruby_lsp" }
			for _, server in ipairs(servers) do
				lspconfig[server].setup({})
			end

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "show definition" })
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "go to definition" })
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { noremap = true, silent = true, desc = "go to references" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "code action" })
			vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { noremap = true, silent = true, desc = "code formatter" })
			vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "rename" })
		end,
	},
}
