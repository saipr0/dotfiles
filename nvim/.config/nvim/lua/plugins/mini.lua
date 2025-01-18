return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    require("mini.files").setup({
      windows = {
        preview = true,
        width_focus = 30,
        width_nofocus = 15,
        width_preview = 40,
      },

      options = {
        permanent_delete = false,
      },
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesActionRename",
      callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
      end,
    })

    require("mini.icons").setup()
    require("mini.sessions").setup()
    require("mini.starter").setup({
      footer = "",
      items = {
        require("mini.starter").sections.recent_files(5, false, false),
        {
          name = "config",
          action = function()
            vim.cmd("tcd ~/.config")
            vim.cmd("Neotree toggle left") -- Toggle neotree
          end,
          section = "Quick Access",
        },
        {
          name = "dotfiles",
          action = function()
            vim.cmd("tcd ~/dotfiles")
            vim.cmd("Neotree toggle left") -- Toggle neotree
          end,
          section = "Quick Access",
        },
        {
          name = "nvim",
          action = function()
            vim.cmd("tcd ~/.config/nvim")
            vim.cmd("Neotree toggle left") -- Toggle neotree
          end,
          section = "Quick Access",
        },
        {
          name = "new file", -- Changed to "new file"
          action = function()
            vim.cmd("enew")
          end,
          section = "Actions",
        },
        {
          name = "quit neovim", -- Changed to "quit neovim"
          action = function()
            vim.cmd("qall")
          end,
          section = "Actions",
        },
        {
          name = "lazy update", -- Changed name
          action = function()
            vim.cmd("Lazy update")
          end,
          section = "Plugins", -- Changed section name
        },
        {
          name = "mason", -- Changed name
          action = function()
            vim.cmd("Mason")
          end,
          section = "Plugins", -- Changed section name
        },
      },
    })
    require("mini.git").setup()
    require("mini.diff").setup()
    require("mini.statusline").setup()
    require("mini.comment").setup()
    require("mini.pairs").setup()
    -- vim.api.nvim_command("highlight MiniTablineCurrent guibg=NONE gui=NONE")
    -- vim.api.nvim_command("highlight MiniTablineVisible guibg=NONE")
    -- vim.api.nvim_command("highlight MiniTablineHidden guibg=NONE")
    require("mini.surround").setup()
   -- require("mini.bufremove").setup()
    -- require("mini.indentscope").setup()
    -- require("mini.clue").setup({
    -- 	triggers = {
    -- 		-- Leader triggers
    -- 		{ mode = "n", keys = "<Leader>" },
    -- 		{ mode = "x", keys = "<Leader>" },
    --
    -- 		-- Built-in completion
    -- 		{ mode = "i", keys = "<C-x>" },
    --
    -- 		-- `g` key
    -- 		{ mode = "n", keys = "g" },
    -- 		{ mode = "x", keys = "g" },
    --
    -- 		-- Marks
    -- 		{ mode = "n", keys = "'" },
    -- 		{ mode = "n", keys = "`" },
    -- 		{ mode = "x", keys = "'" },
    -- 		{ mode = "x", keys = "`" },
    --
    -- 		-- Registers
    -- 		{ mode = "n", keys = '"' },
    -- 		{ mode = "x", keys = '"' },
    -- 		{ mode = "i", keys = "<C-r>" },
    -- 		{ mode = "c", keys = "<C-r>" },
    --
    -- 		-- Window commands
    -- 		{ mode = "n", keys = "<C-w>" },
    --
    -- 		-- `z` key
    -- 		{ mode = "n", keys = "z" },
    -- 		{ mode = "x", keys = "z" },
    -- 	},
    --
    -- 	clues = {
    -- 		-- Enhance this by adding descriptions for <Leader> mapping groups
    -- 		require("mini.clue").gen_clues.builtin_completion(),
    -- 		require("mini.clue").gen_clues.g(),
    -- 		require("mini.clue").gen_clues.marks(),
    -- 		require("mini.clue").gen_clues.registers(),
    -- 		require("mini.clue").gen_clues.windows(),
    -- 		require("mini.clue").gen_clues.z(),
    -- 	},
    --
    -- 	window = {
    -- 		delay = 200,
    -- 	},
    -- })

    -- Keymaps
    vim.keymap.set(
      "n",
      "<leader>e",
      ":lua MiniFiles.open()<CR>",
      { noremap = true, silent = true, desc = "MiniFiles" }
    )
    vim.keymap.set(
      "n",
      "<Esc>",
      ":lua MiniFiles.close()<CR>",
      { noremap = true, silent = true, desc = "Close MiniFiles" }
    )
    vim.keymap.set(
      "n",
      "<leader>x",
      ":lua MiniBufremove.delete()<CR>",
      { noremap = true, silent = true, desc = "Close Buffer" }
    )
    vim.keymap.set("n", "<Tab>", ":bnext<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { noremap = true, silent = true })
  end,
}
