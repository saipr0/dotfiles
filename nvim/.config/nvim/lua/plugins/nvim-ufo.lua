return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async',
    'luukvbaal/statuscol.nvim',
  },
  config = function()
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    local statuscol_builtin = require 'statuscol.builtin'
    require('statuscol').setup {
      relculright = true,
      bt_ignore = { 'nofile', 'prompt', 'quickfix', 'terminal' },
      ft_ignore = {
        'help',
        'minifiles',
        'minipick',
        'mininotify-history',
        'neo-tree',
      },
      segments = {
        {
          sign = { namespace = { 'gitsigns' }, maxwidth = 1, colwidth = 1, auto = true },
          click = 'v:lua.ScSa',
        },
        {
          sign = { namespace = { 'diagnostic/signs' }, maxwidth = 1, auto = true },
          click = 'v:lua.ScSa',
        },
        {
          text = { statuscol_builtin.lnumfunc, ' ' },
          condition = { true, statuscol_builtin.not_empty },
          click = 'v:lua.ScLa',
        },
        { text = { statuscol_builtin.foldfunc }, click = 'v:lua.ScFa' },
      },
    }

    -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    vim.keymap.set('n', 'zK', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = 'Peek Fold' })

    local function fold_virt_text_handler(virt_text, lnum, end_lnum, width, truncate)
      local new_virt_text = {}
      local suffix = (' 󰁂 %d '):format(end_lnum - lnum)
      local suffix_width = vim.fn.strdisplaywidth(suffix)
      local target_width = width - suffix_width
      local current_width = 0

      for _, chunk in ipairs(virt_text) do
        local chunk_text = chunk[1]
        local chunk_width = vim.fn.strdisplaywidth(chunk_text)

        if target_width > current_width + chunk_width then
          table.insert(new_virt_text, chunk)
        else
          chunk_text = truncate(chunk_text, target_width - current_width)
          table.insert(new_virt_text, { chunk_text, chunk[2] })

          chunk_width = vim.fn.strdisplaywidth(chunk_text)
          if current_width + chunk_width < target_width then
            suffix = suffix .. string.rep(' ', target_width - current_width - chunk_width)
          end
          break
        end

        current_width = current_width + chunk_width
      end

      table.insert(new_virt_text, { suffix, 'MoreMsg' })
      return new_virt_text
    end

    require('ufo').setup {
      fold_virt_text_handler = fold_virt_text_handler,
      provider_selector = function(bufnr, filetype, buftype)
        return { 'lsp', 'indent' }
      end,
    }
  end,
}
