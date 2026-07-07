return {
  'kawre/leetcode.nvim',
  build = ':TSUpdate html',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-treesitter/nvim-treesitter',
    {
      '3rd/image.nvim',
      opts = {
        backend = 'kitty',
        processor = 'magick_cli',
        integrations = {
          markdown = {
            enabled = true,
            download_remote_images = true,
          },
        },
        -- Enable auto-clearing when switching windows
        -- window_overlap_clear_enabled = true,
        -- editor_only_render_when_focused = true,
      },
    },
  },
  opts = {
    -- Use your preferred language (default is cpp)
    lang = 'ruby',

    -- Enable image support
    image_support = true,

    -- Hooks to disable LSP when entering leetcode
    hooks = {
      enter = {
        function()
          local shade_ok, shade = pcall(require, 'shade')
          if shade_ok and shade and shade.toggle and vim.g.shade_active then
            shade.toggle()
            vim.g.leetcode_shade_was_disabled = true
          end

          local leetcode_home = vim.fs.normalize(vim.fn.stdpath 'data' .. '/leetcode/')

          local function is_leetcode_buffer(bufnr)
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname == '' then
              return false
            end

            local normalized = vim.fs.normalize(bufname)
            return normalized:find(leetcode_home, 1, true) == 1 or normalized:match 'leetcode'
          end

          -- Create autocommand to stop LSP on buffer enter
          vim.api.nvim_create_autocmd({ 'BufEnter', 'LspAttach' }, {
            group = vim.api.nvim_create_augroup('LeetCodeDisableLSP', { clear = true }),
            callback = function(args)
              if is_leetcode_buffer(args.buf) then
                vim.schedule(function()
                  for _, client in pairs(vim.lsp.get_clients { bufnr = args.buf }) do
                    if client.name == 'ruby_lsp' then
                      vim.lsp.stop_client(client.id, true)
                    end
                  end
                end)
              end
            end,
          })
        end,
      },
      leave = {
        function()
          if vim.g.leetcode_shade_was_disabled then
            local shade_ok, shade = pcall(require, 'shade')
            if shade_ok and shade and shade.toggle then
              shade.toggle()
            end
            vim.g.leetcode_shade_was_disabled = false
          end
        end,
      },
    },
  },
}
