return {
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()
      -- Set up the highlights first
      vim.api.nvim_set_hl(0, "CmpNormal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpFloatBorder", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpItemMenu", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2D4F67" })
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = {
            border = "rounded",
            winhighlight = "Normal:CmpNormal,FloatBorder:CmpFloatBorder,CursorLine:PmenuSel,Search:None",
          },
          documentation = {
            border = "rounded",
            winhighlight = "Normal:CmpNormal,FloatBorder:CmpFloatBorder,CursorLine:PmenuSel,Search:None",
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
          },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
