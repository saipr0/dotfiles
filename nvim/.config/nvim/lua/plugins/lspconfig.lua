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
				ensure_installed = { },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		opts = {
			servers = {
				cssls = {},
				emmet_language_server = {},
				jsonls = {},
				lua_ls = {},
				ruby_lsp = {},
        ts_ls = {},
			},
		},

		config = function(_, opts)
			local lspconfig = require("lspconfig")
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			for server, _ in pairs(opts.servers) do
				lspconfig[server].setup({ capabilities = capabilities })
			end

			-- lspconfig.html.setup({
			--   filetypes = { "html", "eruby"}
			-- })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "show definition" })
			vim.keymap.set(
				"n",
				"<leader>gd",
				vim.lsp.buf.definition,
				{ noremap = true, silent = true, desc = "go to definition" }
			)
			vim.keymap.set(
				"n",
				"<leader>gr",
				vim.lsp.buf.references,
				{ noremap = true, silent = true, desc = "go to references" }
			)
			vim.keymap.set(
				"n",
				"<leader>ca",
				vim.lsp.buf.code_action,
				{ noremap = true, silent = true, desc = "code action" }
			)
			vim.keymap.set(
				"n",
				"<leader>gf",
				vim.lsp.buf.format,
				{ noremap = true, silent = true, desc = "code formatter" }
			)
			vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "rename" })
		end,
	},
}
