vim.api.nvim_set_keymap('n', ';', ':', { noremap = true, silent = false })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>ct', function()
    vim.b.cmp_enabled = not vim.b.cmp_enabled
    require('cmp').setup.buffer { enabled = vim.b.cmp_enabled }
    print("Completion " .. (vim.b.cmp_enabled and "enabled" or "disabled"))
end, { desc = "Toggle CMP for current buffer" })

