return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    local parsers = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'query',
      'ruby',
      'slim',
      'tmux',
      'vim',
      'vimdoc',
      'javascript',
      'typescript',
      'tsx',
      'embedded_template',
      'json',
      'regex',
    }

    require('nvim-treesitter').install(parsers)

    local available_parsers = require('nvim-treesitter').get_available()

    local function treesitter_try_attach(buf, language)
      if not vim.treesitter.language.add(language) then
        return
      end

      vim.treesitter.start(buf, language)

      if language == 'ruby' then
        return
      end

      local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
      if has_indent_query then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local buf, filetype = args.buf, args.match
        if vim.b[buf].bigfile then
          return
        end
        local language = vim.treesitter.language.get_lang(filetype)
        if not language then
          return
        end

        local installed_parsers = require('nvim-treesitter').get_installed 'parsers'
        if vim.tbl_contains(installed_parsers, language) then
          treesitter_try_attach(buf, language)
        elseif vim.tbl_contains(available_parsers, language) then
          require('nvim-treesitter').install(language):await(function()
            treesitter_try_attach(buf, language)
          end)
        else
          treesitter_try_attach(buf, language)
        end
      end,
    })
  end,
}
