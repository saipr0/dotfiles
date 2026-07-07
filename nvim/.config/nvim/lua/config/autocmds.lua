vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

local general_group = vim.api.nvim_create_augroup('general-autocmds', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Copy yanks to the terminal clipboard over OSC52',
  group = general_group,
  callback = function()
    local event = vim.v.event
    if not vim.tbl_contains({ '', '+', '*' }, event.regname) or event.operator ~= 'y' then
      return
    end

    pcall(vim.fn.OSCYankRegister, event.regname)
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Restore cursor to last edit position',
  group = general_group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      vim.schedule(function()
        vim.cmd 'normal! zz'
      end)
    end
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Resize splits with terminal window',
  group = general_group,
  command = 'wincmd =',
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Disable automatic comment continuation',
  group = general_group,
  callback = function()
    vim.opt_local.formatoptions:remove { 'c', 'r', 'o' }
  end,
})

local function format_current_buffer()
  local ok, conform = pcall(require, 'conform')
  if ok then
    conform.format { async = true, lsp_format = 'fallback' }
    return
  end

  if #vim.lsp.get_clients { bufnr = 0 } > 0 then
    vim.lsp.buf.format { async = true }
  end
end

vim.api.nvim_create_user_command('ScratchFiletype', function(opts)
  local filetype = vim.trim(opts.args)
  if filetype == '' then
    require('config.picker').pick_filetype()
    return
  end

  vim.bo.filetype = filetype
  vim.schedule(format_current_buffer)
end, {
  desc = 'Pick or set filetype for the current buffer',
  nargs = '?',
  complete = 'filetype',
})

local function copy_buffer_value(desc, value)
  if value == '' then
    vim.notify('No ' .. desc .. ' for current buffer', vim.log.levels.WARN)
    return
  end

  vim.fn.setreg('"', value)
  local ok = false
  if #vim.api.nvim_list_uis() > 0 then
    ok = pcall(vim.fn.setreg, '+', value)
  end
  local clipboard_note = ok and '' or ' (unnamed register only)'
  vim.notify('Copied ' .. desc .. clipboard_note .. ': ' .. value)
end

vim.api.nvim_create_user_command('Filename', function()
  copy_buffer_value('file name', vim.fn.expand '%:t')
end, { desc = 'Copy current buffer file name' })

vim.api.nvim_create_user_command('Filepath', function()
  copy_buffer_value('full path', vim.fn.expand '%:p')
end, { desc = 'Copy current buffer full path' })

vim.api.nvim_create_user_command('Relativepath', function()
  copy_buffer_value('relative path', vim.fn.expand '%')
end, { desc = 'Copy current buffer relative path' })

vim.api.nvim_create_user_command('Directory', function()
  copy_buffer_value('directory', vim.fn.expand '%:p:h')
end, { desc = 'Copy current buffer directory' })

-- Big file handling: disable expensive features for large/minified files
local bigfile_group = vim.api.nvim_create_augroup('bigfile', { clear = true })
local BIGFILE_BYTES = 1024 * 1024 * 1.5 -- 1.5 MB
local LONG_LINE_CHARS = 2000

local function is_bigfile(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return false
  end
  local ok, stats = pcall(vim.uv.fs_stat, name)
  if ok and stats and stats.size > BIGFILE_BYTES then
    return true, ('size %.1fMB'):format(stats.size / 1024 / 1024)
  end
  -- Cheap long-line probe: check first 16 lines
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 16, false)
  for _, line in ipairs(lines) do
    if #line > LONG_LINE_CHARS then
      return true, ('long line %d chars'):format(#line)
    end
  end
  return false
end

vim.api.nvim_create_autocmd('BufReadPre', {
  group = bigfile_group,
  callback = function(args)
    local big, why = is_bigfile(args.buf)
    if not big then
      return
    end
    vim.b[args.buf].bigfile = true
    vim.b[args.buf].bigfile_reason = why
    vim.bo[args.buf].swapfile = false
    vim.bo[args.buf].undofile = false
    vim.bo[args.buf].undolevels = -1
    vim.opt_local.foldmethod = 'manual'
    vim.opt_local.foldexpr = '0'
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = bigfile_group,
  callback = function(args)
    if not vim.b[args.buf].bigfile then
      return
    end
    -- Disable syntax & ui cost
    vim.cmd 'syntax clear'
    vim.bo[args.buf].syntax = ''
    vim.opt_local.cursorline = false
    vim.opt_local.relativenumber = false
    vim.opt_local.list = false
    vim.opt_local.spell = false
    vim.opt_local.wrap = false
    -- Detach any LSP clients that attached to this buf
    vim.schedule(function()
      for _, client in pairs(vim.lsp.get_clients { bufnr = args.buf }) do
        vim.lsp.buf_detach_client(args.buf, client.id)
      end
    end)
    vim.notify(('bigfile mode (%s) — treesitter/LSP/syntax disabled'):format(vim.b[args.buf].bigfile_reason or '?'), vim.log.levels.WARN)
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = bigfile_group,
  callback = function(args)
    if vim.b[args.buf].bigfile then
      vim.lsp.buf_detach_client(args.buf, args.data.client_id)
    end
  end,
})

vim.api.nvim_create_user_command('BigFileToggle', function()
  local buf = vim.api.nvim_get_current_buf()
  vim.b[buf].bigfile = not vim.b[buf].bigfile
  print('bigfile = ' .. tostring(vim.b[buf].bigfile))
end, { desc = 'Toggle bigfile flag for current buffer' })
