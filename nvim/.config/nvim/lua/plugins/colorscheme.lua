return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    enabled = true,
    opts = {
      flavour = "mocha",
      transparent_background = true,
    },
    init = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "slugbyte/lackluster.nvim",
    lazy = false,
    priority = 1000,
    enabled = false,
    init = function()
      require("lackluster").setup({
        tweak_background = {
          normal = "none",
        },
      })
      -- vim.cmd.colorscheme("lackluster")
      vim.cmd.colorscheme("lackluster-hack") -- my favorite
      -- vim.cmd.colorscheme("lackluster-mint")
    end,
  },
  {
    "sainnhe/sonokai",
    lazy = false,
    enabled = false,
    priority = 1000,
    config = function()
      vim.g.sonokai_style = "default"
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_disable_italic_comment = 1
      vim.cmd.colorscheme("sonokai")
      vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
      vim.cmd([[hi NormalNC guibg=NONE ctermbg=NONE]])
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    enabled = false,
    config = function()
      require("kanagawa").setup({
        transparent = true,
        theme = "wave", -- Choose from: "wave", "dragon", "lotus"
        commentStyle = { italic = true },
        keywordStyle = { italic = true, bold = true },
        variablebuiltinStyle = { italic = true },
      })
      vim.cmd.colorscheme("kanagawa")
      vim.cmd([[ highlight TelescopeBorder guibg=none ]])
      vim.cmd([[ highlight TelescopeTitle guibg=none ]])
      vim.cmd([[
          hi LineNr guibg=NONE ctermbg=NONE
          hi CursorLineNr guibg=NONE ctermbg=NONE
      ]])
    end,
  },
}
