vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.o.clipboard = "unnamedplus"
vim.opt.undofile = true

-- vim.api.nvim_create_autocmd('TextYankPost', {
--     callback = function()
--         vim.highlight.on_yank()
--         local copy_to_unnamedplus = require('vim.ui.clipboard.osc52').copy('+')
--         copy_to_unnamedplus(vim.v.event.regcontents)
--         local copy_to_unnamed = require('vim.ui.clipboard.osc52').copy('*')
--         copy_to_unnamed(vim.v.event.regcontents)
--     end
-- })
