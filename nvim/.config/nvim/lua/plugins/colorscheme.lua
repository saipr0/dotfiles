return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    enabled = false,
    opts = {
      flavour = "mocha",
      transparent_background = true,
    },
    init = function()
      vim.cmd.colorscheme("catppuccin")
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
      vim.cmd([[ highlight MiniFilesNormal guibg=none ]])
      vim.cmd([[ highlight MiniFilesBorder guibg=none ]])
      vim.cmd([[ highlight MiniTablineFill guibg=none ]])
    end,
  },
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      vim.opt.background = "dark" -- or "dark"
      vim.g.zenbones_darken_comments = 45
      vim.cmd.colorscheme("zenwritten")
    end,
  },
  {
    "navarasu/onedark.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({
        transparent = true,
      })
      vim.cmd.colorscheme("onedark")
      -- Additional setup to remove background
      vim.cmd([[ highlight MiniFilesNormal guibg=none ]])
      vim.cmd([[ highlight MiniFilesBorder guibg=none ]])
      vim.cmd([[ highlight MiniTablineFill guibg=none ]])
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true,
        },
      })
      vim.cmd.colorscheme("nightfox")
      vim.cmd([[ highlight MiniFilesNormal guibg=none ]])
      vim.cmd([[ highlight MiniFilesBorder guibg=none ]])
      vim.cmd([[ highlight MiniTablineFill guibg=none ]])
    end,
  },
  {
    "rmehri01/onenord.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      require("onenord").setup({
        disable = {
          background = true,
          float_background = true,
          cursorline = true,
          eob_lines = true,
        },
      })
      vim.cmd.colorscheme("onenord")
    end,
  },
  {
    "HoNamDuong/hybrid.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("hybrid").setup({
        transparent = true,
      })
    end,
    init = function()
      vim.cmd("colorscheme hybrid")
    end,
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        transparent = true,
      })
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
}
