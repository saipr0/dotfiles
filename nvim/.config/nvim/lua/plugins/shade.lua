return {
  {
    'sunjon/Shade.nvim',
    event = 'VeryLazy',
    opts = {
      overlay_opacity = 70,
      opacity_step = 5,
      keys = {
        brightness_up = '<C-Up>',
        brightness_down = '<C-Down>',
        toggle = '<leader>us',
      },
    },
    config = function(_, opts)
      local shade = require 'shade'

      shade.setup(opts)
      vim.g.shade_active = true

      local original_toggle = shade.toggle
      shade.toggle = function(...)
        local result = original_toggle(...)
        vim.g.shade_active = not vim.g.shade_active
        return result
      end

      local original_on_win_closed = shade.on_win_closed
      shade.on_win_closed = function(event, winid)
        winid = tonumber(winid)
        if not winid then
          return
        end

        local ok, err = pcall(original_on_win_closed, event, winid)
        if ok then
          return
        end

        if type(err) == 'string' and err:match 'Invalid window id' then
          return
        end

        error(err)
      end
    end,
  },
}
