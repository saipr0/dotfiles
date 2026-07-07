return { -- Collection of various small independent plugins/modulesmini
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
    -- Disable mini.diff entirely to avoid keymap conflicts
    -- require('mini.diff').setup()

    -- ── mini.icons — icon provider (replaces nvim-web-devicons) ──
    local icons = require 'mini.icons'
    icons.setup()
    icons.mock_nvim_web_devicons() -- make everything that uses nvim-web-devicons use mini.icons

    -- ── mini.notify — clean notification popups ──
    require('mini.notify').setup {
      window = {
        config = {
          border = 'rounded',
        },
        winblend = 0,
      },
    }
    vim.notify = MiniNotify.make_notify()

    -- Filter out noisy LSP messages
    local _notify = vim.notify
    vim.notify = function(msg, ...)
      if type(msg) == 'string' and msg:match 'cannot load such file' then return end
      return _notify(msg, ...)
    end

    -- ── mini.hipatterns — highlight patterns inline ──
    local hipatterns = require 'mini.hipatterns'
    hipatterns.setup {
      highlighters = {
        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
        todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    }

    -- ── mini.cursorword — highlight word under cursor ──
    require('mini.cursorword').setup()

    -- ── mini.jump — better f/t with highlights ──
    -- Disable ; and , keymaps so we can use ; for cmdline
    require('mini.jump').setup {
      mappings = {
        repeat_jump = '', -- Disable ; (we use it for :)
      },
    }

    require('mini.pairs').setup {
      modes = { insert = true, command = false, terminal = false }, -- Disable command mode to avoid bracket conflicts
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { 'string' },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    }

    -- File explorer
    require('mini.files').setup {
      mappings = {
        go_in = 'l',
        go_in_plus = '<CR>',
        go_out = 'H',
        go_out_plus = 'h',
        reset = '<BS>',
        reveal_cwd = '.',
        show_help = 'g?',
        synchronize = 's',
        trim_left = '<',
        trim_right = '>',
      },

      windows = {
        preview = true,
        width_focus = 30,
        width_nofocus = 10,
        width_preview = 100,
      },

      options = {
        permanent_delete = false,
        use_as_default_explorer = true,
      },
    }

    -- Fix background color
    vim.api.nvim_set_hl(0, 'MiniFilesNormal', {
      bg = vim.api.nvim_get_hl(0, { name = 'Normal', link = false }).bg or 'NONE',
    })
    vim.api.nvim_set_hl(0, 'MiniFilesBorder', {
      bg = vim.api.nvim_get_hl(0, { name = 'Normal', link = false }).bg or 'NONE',
    })

    vim.keymap.set('n', '<leader>e', function()
      local buf_name = vim.api.nvim_buf_get_name(0)
      local dir_name = vim.fn.fnamemodify(buf_name, ':p:h')

      if vim.fn.filereadable(buf_name) == 1 then
        require('mini.files').open(buf_name, true)
      elseif vim.fn.isdirectory(dir_name) == 1 then
        require('mini.files').open(dir_name, true)
      else
        require('mini.files').open(vim.uv.cwd(), true)
      end
    end, { noremap = true, silent = true, desc = 'MiniFiles (smart open)' })

    vim.keymap.set('n', '<leader>E', function()
      require('mini.files').open(vim.uv.cwd(), true)
    end, { noremap = true, silent = true, desc = 'MiniFiles (cwd)' })

    vim.keymap.set('n', '<Esc>', ':lua MiniFiles.close()<CR>', { noremap = true, silent = true, desc = 'Close MiniFiles' })

    local statusline = require 'mini.statusline'
    local function get_modified_indicator()
      if vim.bo.modified then
        return vim.g.have_nerd_font and ' ●' or ' [+]'
      end
      return ''
    end

    local function get_file_icon()
      local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
      if has_devicons and vim.g.have_nerd_font then
        local name = vim.fn.expand '%:t'
        local ext = vim.fn.expand '%:e'
        local icon = devicons.get_icon(name, ext, { default = true })
        return icon and (icon .. ' ') or ''
      end
      return ''
    end

    local function get_filename()
      return vim.fn.expand '%:t'
    end

    statusline.setup {
      use_icons = vim.g.have_nerd_font,
      set_vim_settings = true,
      content = {
        active = function()
          local git = MiniStatusline.section_git { trunc_width = 40 }
          local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
          local location = MiniStatusline.section_location { trunc_width = 75 }
          local filename = get_file_icon() .. get_filename() .. get_modified_indicator()

          return MiniStatusline.combine_groups {
            { hl = 'StatusLineFile', strings = { ' ' .. filename .. ' ' } },
            '%=', -- End left alignment
            { hl = 'StatusLineInfo', strings = { git, diagnostics } },
            { hl = 'StatusLine', strings = { ' ' .. location .. ' ' } },
          }
        end,
        inactive = function()
          local location = MiniStatusline.section_location { trunc_width = 75 }
          local filename = get_file_icon() .. get_filename() .. get_modified_indicator()

          return MiniStatusline.combine_groups {
            { hl = 'StatusLineFileNC', strings = { ' ' .. filename .. ' ' } },
            '%=',
            { hl = 'StatusLineInfoNC', strings = { ' ' .. location .. ' ' } },
          }
        end,
      },
    }

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%l:%L'
    end

    -- Indent scope visualization
    require('mini.indentscope').setup {
      draw = {
        delay = 0,
        animation = require('mini.indentscope').gen_animation.none(),
      },
    }

    -- Tabline that shows buffers as tabs
    -- require('mini.tabline').setup {
    --   -- Whether to show file icons (requires 'nvim-web-devicons')
    --   show_icons = vim.g.have_nerd_font,
    --   -- Function which formats the tab label
    --   -- Arguments: `buf_id`, `label`
    --   format = nil,
    --   -- Whether to set Vim's settings for tabline (make 'tabline' and
    --   -- 'showtabline' to be handled by this module). Set to `false` if you want
    --   -- to control this manually.
    --   set_vim_settings = true,
    --   -- Where to show tabpage section in case of multiple vim tabpages.
    --   -- One of 'left', 'right', 'none'.
    --   tabpage_section = 'right',
    -- }

    -- Buffer removal that handles edge cases properly
    require('mini.bufremove').setup()
    -- mini.pick fuzzy finder and picker keymaps
    require('config.picker').setup()
  end,
}
