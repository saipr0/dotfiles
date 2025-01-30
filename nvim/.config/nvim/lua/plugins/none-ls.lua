return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
      timeout_ms = 5000,
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.rubocop,
				null_ls.builtins.formatting.erb_format,
				-- null_ls.builtins.diagnostics.rubocop,
				null_ls.builtins.completion.spell,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
        -- require("none-ls.diagnostics.eslint_d"),
			},
		})
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { noremap = true, silent = true, desc = "LSP Format" })
	end,
}
