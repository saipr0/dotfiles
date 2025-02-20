return {
  "saghen/blink.cmp",
  dependencies = "rafamadriz/friendly-snippets",
  version = "*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "default",
    },

    fuzzy = {
      use_frecency = true, -- Boosts frequently used items
      use_proximity = false,
    },
    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      trigger = {
        prefetch_on_insert = true,
        show_in_snippet = true,
      }
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
  opts_extend = { "sources.default" },
}
