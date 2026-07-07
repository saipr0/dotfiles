vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

local function prepend_path_if_exists(path)
  if vim.uv.fs_stat(path) then
    vim.env.PATH = path .. ':' .. vim.env.PATH
  end
end

prepend_path_if_exists(vim.fn.expand '~/.local/share/mise/shims')
prepend_path_if_exists(vim.fn.expand '~/.local/share/mise/installs/fd/latest/fd-v10.4.2-aarch64-apple-darwin')

-- Basic
vim.o.number = true
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
if not vim.env.SSH_CONNECTION then
  vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
  end)
end
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.confirm = true

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Visual
vim.opt.fillchars = {
  eob = ' ',
  horiz = '─',
  horizup = '┴',
  horizdown = '┬',
}
vim.o.breakindent = true
vim.opt.signcolumn = 'yes'
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.opt.cmdheight = 0
vim.opt.shortmess:append 'F'
vim.opt.guicursor = {
  'n-v-c-sm:block',
  'i-ci-ve:ver25',
  'r-cr-o:block',
  't:block-blinkon500-blinkoff500-TermCursor',
}

local cursor_shapes = {
  'n-v-c-sm:block',
  'i-ci-ve:ver25',
  'r-cr-o:block',
  't:block-blinkon500-blinkoff500-TermCursor',
}

local cursor_shape_group = vim.api.nvim_create_augroup('cursor-shape-refresh', { clear = true })

local function set_terminal_cursor_shape(shape)
  local sequence = ('\027[%s q'):format(shape)
  pcall(vim.fn.chansend, vim.v.stderr, sequence)
  pcall(function()
    io.stdout:write(sequence)
    io.stdout:flush()
  end)
end

vim.api.nvim_create_autocmd('InsertEnter', {
  group = cursor_shape_group,
  desc = 'Force insert cursor shape',
  callback = function()
    vim.opt.guicursor = cursor_shapes
    for _, delay in ipairs { 0, 10, 50, 100 } do
      vim.defer_fn(function()
        if vim.api.nvim_get_mode().mode:sub(1, 1) == 'i' then
          set_terminal_cursor_shape(6)
        end
      end, delay)
    end
  end,
})

vim.api.nvim_create_autocmd({ 'CursorMovedI', 'TextChangedI' }, {
  group = cursor_shape_group,
  desc = 'Keep insert cursor shape',
  callback = function()
    set_terminal_cursor_shape(6)
  end,
})

vim.api.nvim_create_autocmd({ 'InsertLeave', 'ModeChanged' }, {
  group = cursor_shape_group,
  desc = 'Force normal cursor shape',
  callback = function()
    if vim.api.nvim_get_mode().mode == 'n' then
      vim.opt.guicursor = cursor_shapes
      set_terminal_cursor_shape(2)
    end
  end,
})

-- Windows
if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  if vim.fn.executable 'pwsh' == 1 then
    vim.o.shell = 'pwsh.exe'
  else
    vim.o.shell = 'cmd.exe'
  end
end

-- Keep the LSP log from growing unless we're actively debugging.
vim.lsp.set_log_level 'warn'
