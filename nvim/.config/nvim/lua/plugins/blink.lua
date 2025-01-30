return {
  "saghen/blink.cmp",
  dependencies = "rafamadriz/friendly-snippets",
  version = "*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-Enter>"] = { "select_and_accept" },
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
