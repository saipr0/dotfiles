local M = {}

local pick = require 'mini.pick'

local picker_cursor_shapes = {
  'n-v-c-sm:block',
  'i-ci-ve:ver25',
  'r-cr-o:block',
  't:block-blinkon500-blinkoff500-TermCursor',
}

local function item_to_string(item)
  if type(item) == 'table' then
    return item.text or item.path or vim.inspect(item)
  end
  return tostring(item)
end

local function split_query_words(query)
  local words = {}
  local current_word = {}

  for _, char in ipairs(query) do
    if char == ' ' then
      if #current_word > 0 then
        table.insert(words, current_word)
        current_word = {}
      end
    else
      table.insert(current_word, char)
    end
  end

  if #current_word > 0 then
    table.insert(words, current_word)
  end

  return words
end

local function has_query_syntax(raw_query)
  return raw_query:sub(1, 1) == "'" or raw_query:sub(1, 1) == '^' or raw_query:sub(1, 1) == '*' or raw_query:sub(-1) == '$'
end

local function is_path_like(str)
  return str:find('/', 1, true) ~= nil or str:find('\\', 1, true) ~= nil
end

local function score_path_match(str, query_words)
  local path = str:lower()
  local filename = vim.fn.fnamemodify(str, ':t'):lower()
  local score = 0

  for _, word in ipairs(query_words) do
    if filename == word then
      score = score + 400
    elseif filename:find(word, 1, true) == 1 then
      score = score + 250
    elseif filename:find(word, 1, true) then
      score = score + 180
    elseif path:find('/' .. word, 1, true) or path:find('\\' .. word, 1, true) then
      score = score + 120
    elseif path:find(word, 1, true) then
      score = score + 80
    end
  end

  return score - (vim.fn.strdisplaywidth(path) / 1000)
end

local function rerank_path_matches(stritems, inds, words, raw_query)
  if #inds <= 1 or has_query_syntax(raw_query) then
    return inds
  end

  local query_words = vim.tbl_map(function(chars)
    return table.concat(chars):lower()
  end, words)

  local scored = {}
  local has_path_items = false
  for order, ind in ipairs(inds) do
    local str = item_to_string(stritems[ind])
    if is_path_like(str) then
      has_path_items = true
    end

    table.insert(scored, {
      ind = ind,
      order = order,
      score = score_path_match(str, query_words),
    })
  end

  if not has_path_items then
    return inds
  end

  table.sort(scored, function(a, b)
    if a.score == b.score then
      return a.order < b.order
    end
    return a.score > b.score
  end)

  return vim.tbl_map(function(entry)
    return entry.ind
  end, scored)
end

local function match_unordered(stritems, inds, query)
  local words = split_query_words(query)
  local raw_query = table.concat(query)

  if #words <= 1 then
    local result = pick.default_match(stritems, inds, query, { sync = true })
    return rerank_path_matches(stritems, result, words, raw_query)
  end

  local result_inds = inds
  for _, word_chars in ipairs(words) do
    result_inds = pick.default_match(stritems, result_inds, word_chars, { sync = true })
    if #result_inds == 0 then return {} end
  end

  return rerank_path_matches(stritems, result_inds, words, raw_query)
end

local function setup_engine_tag_highlights()
  vim.api.nvim_set_hl(0, 'PickerPath', { fg = '#aab2bf' })
  vim.api.nvim_set_hl(0, 'EngineTag1', { fg = '#7aa2f7' })
  vim.api.nvim_set_hl(0, 'EngineTag2', { fg = '#8fbf7f' })
  vim.api.nvim_set_hl(0, 'EngineTag3', { fg = '#c9a96a' })
  vim.api.nvim_set_hl(0, 'EngineTag4', { fg = '#c6787d' })
  vim.api.nvim_set_hl(0, 'EngineTag5', { fg = '#a889c9' })
  vim.api.nvim_set_hl(0, 'EngineTag6', { fg = '#7fb8c8' })
  vim.api.nvim_set_hl(0, 'EngineTag7', { fg = '#c58b6b' })
  vim.api.nvim_set_hl(0, 'EngineTag8', { fg = '#c97991' })
  vim.api.nvim_set_hl(0, 'EngineTag9', { fg = '#79aaa2' })
  vim.api.nvim_set_hl(0, 'EngineTag10', { fg = '#8caed0' })
  vim.api.nvim_set_hl(0, 'EngineTag11', { fg = '#78b8aa' })
  vim.api.nvim_set_hl(0, 'EngineTag12', { fg = '#c8a66d' })
  vim.api.nvim_set_hl(0, 'EngineTag13', { fg = '#a993d0' })
  vim.api.nvim_set_hl(0, 'EngineTag14', { fg = '#c98388' })
  vim.api.nvim_set_hl(0, 'EngineTag15', { fg = '#6fbaaa' })
  vim.api.nvim_set_hl(0, 'EngineTag16', { fg = '#9b8ac8' })
  vim.api.nvim_set_hl(0, 'EngineTag17', { fg = '#90b56d' })
  vim.api.nvim_set_hl(0, 'EngineTag18', { fg = '#bd9763' })
  vim.api.nvim_set_hl(0, 'EngineTag19', { fg = '#7e99c8' })
  vim.api.nvim_set_hl(0, 'EngineTag20', { fg = '#c77786' })
end

local function setup_picker_highlights()
  vim.api.nvim_set_hl(0, 'MiniPickNormal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'MiniPickBorder', { fg = '#5f6672', bg = 'none' })
  vim.api.nvim_set_hl(0, 'MiniPickBorderBusy', { fg = '#e0af68', bg = 'none' })
  vim.api.nvim_set_hl(0, 'MiniPickBorderText', { fg = '#aab2bf', bg = 'none', bold = true })
  vim.api.nvim_set_hl(0, 'MiniPickMatchCurrent', { bg = '#262b35', bold = true })
  vim.api.nvim_set_hl(0, 'MiniPickMatchMarked', { bg = '#313746', bold = true })
  vim.api.nvim_set_hl(0, 'MiniPickMatchRanges', { fg = '#89ddff', bold = true })
  vim.api.nvim_set_hl(0, 'MiniPickPrompt', { fg = '#d4d7dd', bg = 'none' })
  vim.api.nvim_set_hl(0, 'MiniPickPromptCaret', { fg = '#89ddff', bg = 'none', bold = true })
  vim.api.nvim_set_hl(0, 'MiniPickPromptPrefix', { fg = '#c3e88d', bg = 'none', bold = true })
end

local color_palette = {
  'EngineTag1', 'EngineTag2', 'EngineTag3', 'EngineTag4', 'EngineTag5',
  'EngineTag6', 'EngineTag7', 'EngineTag8', 'EngineTag9', 'EngineTag10',
  'EngineTag11', 'EngineTag12', 'EngineTag13', 'EngineTag14', 'EngineTag15',
  'EngineTag16', 'EngineTag17', 'EngineTag18', 'EngineTag19', 'EngineTag20',
}

local engine_colors = nil
local engine_colors_root = nil

local function hash_string(str)
  local hash = 0
  for i = 1, #str do
    hash = (hash * 31 + string.byte(str, i)) % 2147483647
  end
  return hash
end

local function build_engine_colors()
  local root = vim.fn.getcwd()
  if engine_colors and engine_colors_root == root then
    return engine_colors
  end

  engine_colors = {}
  engine_colors_root = root
  local handle = vim.uv.fs_scandir(root)
  if not handle then return engine_colors end

  while true do
    local name, typ = vim.uv.fs_scandir_next(handle)
    if not name then break end
    if typ == 'directory' and not name:match '^%.' then
      local hash = hash_string(name)
      engine_colors[name] = color_palette[(hash % #color_palette) + 1]
    end
  end

  return engine_colors
end

local function get_engine_name(dir)
  return dir:match '^([^/]+)' or ''
end

local function display_width(text)
  return vim.fn.strdisplaywidth(text)
end

local function truncate_right(text, max_width)
  if max_width <= 0 then return '' end
  if display_width(text) <= max_width then return text end

  local ellipsis = '...'
  if max_width <= display_width(ellipsis) then return ellipsis end

  local kept = {}
  local width = display_width(ellipsis)
  for i = 1, vim.fn.strchars(text) do
    local char = vim.fn.strcharpart(text, i - 1, 1)
    local char_width = display_width(char)
    if width + char_width > max_width then break end
    table.insert(kept, char)
    width = width + char_width
  end

  return table.concat(kept) .. ellipsis
end

local function truncate_left(text, max_width)
  if max_width <= 0 then return '' end
  if display_width(text) <= max_width then return text end

  local ellipsis = '...'
  if max_width <= display_width(ellipsis) then return ellipsis end

  local kept = {}
  local width = display_width(ellipsis)
  for i = vim.fn.strchars(text), 1, -1 do
    local char = vim.fn.strcharpart(text, i - 1, 1)
    local char_width = display_width(char)
    if width + char_width > max_width then break end
    table.insert(kept, 1, char)
    width = width + char_width
  end

  return ellipsis .. table.concat(kept)
end

local function compact_path(path, max_width)
  if path == '' then return '' end
  if display_width(path) <= max_width then return path end

  local shortened = vim.fn.pathshorten(path)
  if display_width(shortened) <= max_width then return shortened end

  return truncate_left(shortened, max_width)
end

local function show_filename_first(buf_id, items)
  local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
  local win_id = vim.api.nvim_get_current_win()
  local win_width = vim.api.nvim_win_get_width(win_id)
  local ns = vim.api.nvim_create_namespace 'mini_pick_filename_first'
  local lines = {}
  local highlights = {}
  local colors = build_engine_colors()
  local min_gap = 2

  for _, item in ipairs(items) do
    local str = item_to_string(item)
    local filename = vim.fn.fnamemodify(str, ':t')
    local dir = vim.fn.fnamemodify(str, ':h')
    if dir == '.' then dir = '' end

    local icon = ''
    local icon_hl = nil
    if has_devicons and vim.g.have_nerd_font then
      local ext = vim.fn.fnamemodify(filename, ':e')
      icon, icon_hl = devicons.get_icon(filename, ext, { default = true })
      icon = icon and (icon .. ' ') or ''
    end

    local engine = get_engine_name(dir)
    local tag = ''
    local rest_dir = dir
    if engine ~= '' and colors[engine] then
      tag = '[' .. engine .. ']'
      rest_dir = dir:sub(#engine + 2)
      if rest_dir == '' then rest_dir = '' end
    end

    local path_start = math.min(math.max(math.floor(win_width * 0.44), 30), win_width - 18)
    local max_right_width = math.max(win_width - path_start, 12)
    local path_width_budget = math.max(max_right_width - display_width(tag ~= '' and (tag .. '  ') or ''), 0)
    local compact_dir = compact_path(rest_dir, path_width_budget)
    local right = tag ~= '' and (tag .. (compact_dir ~= '' and ('  ' .. compact_dir) or '')) or compact_path(dir, max_right_width)

    local left = truncate_right(icon .. filename, math.max(path_start - min_gap, 8))

    local padding = path_start - display_width(left)
    if padding < min_gap then padding = min_gap end

    table.insert(lines, left .. string.rep(' ', padding) .. right)
    table.insert(highlights, {
      icon_len = #icon,
      icon_hl = icon_hl,
      left_len = #left,
      tag = tag,
      tag_start = #left + padding,
      engine = engine,
    })
  end

  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
  vim.api.nvim_buf_clear_namespace(buf_id, ns, 0, -1)

  for i, hl in ipairs(highlights) do
    local row = i - 1
    if hl.icon_hl then
      vim.api.nvim_buf_add_highlight(buf_id, ns, hl.icon_hl, row, 0, hl.icon_len)
    end
    vim.api.nvim_buf_add_highlight(buf_id, ns, 'PickerPath', row, hl.left_len, -1)
    if hl.tag ~= '' then
      vim.api.nvim_buf_add_highlight(buf_id, ns, colors[hl.engine] or 'Comment', row, hl.tag_start, hl.tag_start + #hl.tag)
    end
  end
end

local function show_files_fast(buf_id, items)
  local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
  local win_width = vim.api.nvim_win_get_width(vim.api.nvim_get_current_win())
  local ns = vim.api.nvim_create_namespace 'mini_pick_files_fast'
  local lines = {}
  local highlights = {}
  local path_start = math.min(math.max(math.floor(win_width * 0.5), 34), win_width - 18)

  for _, item in ipairs(items) do
    local str = item_to_string(item)
    local filename = vim.fn.fnamemodify(str, ':t')
    local dir = vim.fn.fnamemodify(str, ':h')
    if dir == '.' then dir = '' end

    local icon = ''
    local icon_hl = nil
    if has_devicons and vim.g.have_nerd_font then
      local ext = vim.fn.fnamemodify(filename, ':e')
      icon, icon_hl = devicons.get_icon(filename, ext, { default = true })
      icon = icon and (icon .. ' ') or ''
    end

    local left = truncate_right(icon .. filename, math.max(path_start - 2, 8))
    local right = compact_path(dir, math.max(win_width - path_start, 12))
    local padding = math.max(path_start - display_width(left), 2)

    table.insert(lines, left .. string.rep(' ', padding) .. right)
    table.insert(highlights, { icon_len = #icon, icon_hl = icon_hl, path_start = #left + padding })
  end

  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
  vim.api.nvim_buf_clear_namespace(buf_id, ns, 0, -1)

  for row, hl in ipairs(highlights) do
    if hl.icon_hl then
      vim.api.nvim_buf_add_highlight(buf_id, ns, hl.icon_hl, row - 1, 0, hl.icon_len)
    end
    vim.api.nvim_buf_add_highlight(buf_id, ns, 'PickerPath', row - 1, hl.path_start, -1)
  end
end

local function window_config()
  local columns = vim.o.columns
  local lines = vim.o.lines
  local width = math.min(math.max(math.floor(columns * 0.72), 64), 104)
  local height = math.min(math.max(math.floor(lines * 0.58), 14), 26)

  return {
    anchor = 'NW',
    border = 'single',
    col = math.floor((columns - width) / 2),
    height = height,
    row = math.max(math.floor((lines - height) / 2) - 1, 0),
    width = width,
  }
end

local function reset_cursor_shapes()
  vim.opt.guicursor = picker_cursor_shapes
  vim.cmd.redraw()
end

local function setup_cursor_restore()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniPickStop',
    desc = 'Restore cursor shapes after mini.pick closes',
    callback = function()
      for _, delay in ipairs { 0, 25, 100 } do
        vim.defer_fn(reset_cursor_shapes, delay)
      end
    end,
  })
end

local function paste_clipboard()
  local clip = vim.fn.getreg '+'
  if clip == '' then return end

  local query = MiniPick.get_picker_query() or {}
  for _, c in ipairs(vim.fn.split(clip, '\\zs')) do
    table.insert(query, c)
  end
  MiniPick.set_picker_query(query)
end

local file_ignore_args = {
  '--exclude', '.git',
  '--exclude', 'node_modules',
  '--exclude', 'vendor',
  '--exclude', 'tmp',
  '--exclude', 'log',
  '--exclude', 'coverage',
  '--exclude', 'dist',
  '--exclude', 'build',
  '--exclude', '.bundle',
  '--exclude', '.ruby-lsp',
  '--exclude', '.opencode/node_modules',
}

local function resolve_executable(name, fallback)
  local executable = vim.fn.exepath(name)
  if executable ~= nil and executable ~= '' then
    return executable
  end

  if fallback and vim.uv.fs_stat(fallback) then
    return fallback
  end

  return nil
end

local function pick_files(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.fn.getcwd()
  local fd = resolve_executable('fd', vim.fn.expand '~/.local/share/mise/installs/fd/latest/fd-v10.4.2-aarch64-apple-darwin/fd')
  if not fd then
    vim.notify('fd is not on PATH for this Neovim session', vim.log.levels.ERROR)
    return
  end

  local command = {
    fd,
    '--type', 'f',
    '--hidden',
    '--strip-cwd-prefix',
  }

  vim.list_extend(command, file_ignore_args)
  table.insert(command, '.')

  local result = vim.system(command, { cwd = cwd, text = true }):wait()
  if result.code ~= 0 then
    vim.notify(result.stderr ~= '' and result.stderr or 'fd failed', vim.log.levels.ERROR)
    return
  end

  local items = vim.split(result.stdout, '\n', { trimempty = true })
  pick.start { source = { cwd = cwd, name = 'Files', items = items, show = show_files_fast } }
end

local filetype_extensions = {
  bash = 'sh',
  css = 'css',
  eruby = 'erb',
  go = 'go',
  html = 'html',
  javascript = 'js',
  javascriptreact = 'jsx',
  json = 'json',
  lua = 'lua',
  markdown = 'md',
  python = 'py',
  ruby = 'rb',
  rust = 'rs',
  sh = 'sh',
  sql = 'sql',
  typescript = 'ts',
  typescriptreact = 'tsx',
  vim = 'vim',
  yaml = 'yml',
  zsh = 'zsh',
}

local common_filetypes = {
  'ruby',
  'lua',
  'json',
  'javascript',
  'typescript',
  'typescriptreact',
  'javascriptreact',
  'html',
  'css',
  'markdown',
  'yaml',
  'sh',
  'zsh',
  'python',
  'go',
  'rust',
  'sql',
}

local function filetype_icon(filetype)
  local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
  if not has_devicons or not vim.g.have_nerd_font then
    return '', nil
  end

  local ext = filetype_extensions[filetype] or filetype
  local icon, icon_hl = devicons.get_icon('scratch.' .. ext, ext, { default = true })
  return icon and (icon .. ' ') or '', icon_hl
end

local function filetype_item(filetype)
  local icon, icon_hl = filetype_icon(filetype)
  local ext = filetype_extensions[filetype]
  local detail = ext and ('.' .. ext) or ''

  return {
    filetype = filetype,
    icon = icon,
    icon_hl = icon_hl,
    detail = detail,
    text = icon .. filetype .. (detail ~= '' and ('  ' .. detail) or ''),
  }
end

local function filetype_items()
  local seen = {}
  local items = {}

  local function add(filetype)
    if filetype == '' or seen[filetype] then
      return
    end
    seen[filetype] = true
    table.insert(items, filetype_item(filetype))
  end

  for _, filetype in ipairs(common_filetypes) do
    add(filetype)
  end

  local all_filetypes = vim.fn.getcompletion('', 'filetype')
  table.sort(all_filetypes)
  for _, filetype in ipairs(all_filetypes) do
    add(filetype)
  end

  return items
end

local function show_filetypes(buf_id, items)
  local ns = vim.api.nvim_create_namespace 'mini_pick_filetypes'
  local lines = {}
  local highlights = {}

  for _, item in ipairs(items) do
    table.insert(lines, item.text)
    table.insert(highlights, {
      icon_len = #item.icon,
      icon_hl = item.icon_hl,
      filetype_start = #item.icon,
      filetype_end = #item.icon + #item.filetype,
      detail_start = item.detail ~= '' and (#item.icon + #item.filetype + 2) or nil,
    })
  end

  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
  vim.api.nvim_buf_clear_namespace(buf_id, ns, 0, -1)

  for i, hl in ipairs(highlights) do
    local row = i - 1
    if hl.icon_hl then
      vim.api.nvim_buf_add_highlight(buf_id, ns, hl.icon_hl, row, 0, hl.icon_len)
    end
    vim.api.nvim_buf_add_highlight(buf_id, ns, 'MiniPickPrompt', row, hl.filetype_start, hl.filetype_end)
    if hl.detail_start then
      vim.api.nvim_buf_add_highlight(buf_id, ns, 'PickerPath', row, hl.detail_start, -1)
    end
  end
end

local function format_buffer(bufnr)
  local ok, conform = pcall(require, 'conform')
  if ok then
    conform.format { async = true, bufnr = bufnr, lsp_format = 'fallback' }
    return
  end

  if #vim.lsp.get_clients { bufnr = bufnr } > 0 then
    vim.lsp.buf.format { async = true, bufnr = bufnr }
  end
end

function M.pick_filetype()
  local target_bufnr = vim.api.nvim_get_current_buf()

  pick.start {
    source = {
      name = 'Filetype',
      items = filetype_items(),
      show = show_filetypes,
      choose = function(item)
        if not item or not item.filetype then
          return
        end

        if vim.api.nvim_buf_is_valid(target_bufnr) then
          vim.bo[target_bufnr].filetype = item.filetype
          vim.schedule(function()
            format_buffer(target_bufnr)
          end)
        end
      end,
    },
  }
end

local function setup_keymaps()
  local extra = require 'mini.extra'

  vim.keymap.set('n', '<leader>sh', function() extra.pickers.hl_groups() end, { desc = '[S]earch [H]ighlight groups' })
  vim.keymap.set('n', '<leader>sc', function() extra.pickers.colorschemes() end, { desc = '[S]earch [C]olorscheme' })
  vim.keymap.set('n', '<leader>sk', function() extra.pickers.keymaps() end, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', function()
    pick_files()
  end, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sw', function()
    pick.builtin.grep { pattern = vim.fn.expand '<cword>' }
  end, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', function() pick.builtin.grep_live() end, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', function() extra.pickers.diagnostic { scope = 'current' } end, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', pick.builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', function() extra.pickers.oldfiles() end, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader><leader>', pick.builtin.buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function() extra.pickers.buf_lines { scope = 'current' } end, { desc = '[/] Fuzzily search in current buffer' })
  vim.keymap.set('n', '<leader>s/', function() extra.pickers.buf_lines { scope = 'all' } end, { desc = '[S]earch [/] in Open Files' })
  vim.keymap.set('n', '<leader>sn', function()
    pick_files { cwd = vim.fn.stdpath 'config' }
  end, { desc = '[S]earch [N]eovim files' })
  vim.keymap.set('n', '<leader>st', function() extra.pickers.treesitter() end, { desc = '[S]earch [T]reesitter nodes' })
  vim.keymap.set('n', '<leader>sm', function() extra.pickers.marks() end, { desc = '[S]earch [M]arks' })
  vim.keymap.set('n', '<leader>sj', function() extra.pickers.list { scope = 'jump' } end, { desc = '[S]earch [J]umps' })
  vim.keymap.set('n', '<leader>sq', function() extra.pickers.list { scope = 'quickfix' } end, { desc = '[S]earch [Q]uickfix' })
  vim.keymap.set('n', '<leader>sH', function() pick.builtin.help() end, { desc = '[S]earch [H]elp tags' })

  vim.keymap.set('n', '<leader>lr', function() extra.pickers.lsp { scope = 'references' } end, { desc = '[L]SP [R]eferences' })
  vim.keymap.set('n', '<leader>ld', function() extra.pickers.lsp { scope = 'definition' } end, { desc = '[L]SP [D]efinitions' })
  vim.keymap.set('n', '<leader>li', function() extra.pickers.lsp { scope = 'implementation' } end, { desc = '[L]SP [I]mplementations' })
  vim.keymap.set('n', '<leader>ls', function() extra.pickers.lsp { scope = 'document_symbol' } end, { desc = '[L]SP Document [S]ymbols' })
  vim.keymap.set('n', '<leader>lw', function() extra.pickers.lsp { scope = 'workspace_symbol' } end, { desc = '[L]SP [W]orkspace Symbols' })

  vim.keymap.set('n', '<leader>ft', M.pick_filetype, { desc = '[F]ile[T]ype picker' })

  vim.keymap.set('n', '<leader>ss', function()
    local items = {
      'Files', 'Grep live', 'Buffers', 'Help', 'Keymaps', 'Colorschemes',
      'Diagnostics', 'Marks', 'Oldfiles', 'Resume', 'LSP references',
      'LSP definitions', 'LSP symbols', 'LSP workspace symbols',
      'Git commits', 'Git branches', 'Registers', 'Commands',
      'Explorer', 'Treesitter', 'Quickfix', 'Jumps',
    }

    vim.ui.select(items, { prompt = 'Pick a picker:' }, function(choice)
      if not choice then return end
      local map = {
        ['Files'] = pick_files,
        ['Grep live'] = function() pick.builtin.grep_live() end,
        ['Buffers'] = pick.builtin.buffers,
        ['Help'] = pick.builtin.help,
        ['Keymaps'] = extra.pickers.keymaps,
        ['Colorschemes'] = extra.pickers.colorschemes,
        ['Diagnostics'] = extra.pickers.diagnostic,
        ['Marks'] = extra.pickers.marks,
        ['Oldfiles'] = extra.pickers.oldfiles,
        ['Resume'] = pick.builtin.resume,
        ['LSP references'] = function() extra.pickers.lsp { scope = 'references' } end,
        ['LSP definitions'] = function() extra.pickers.lsp { scope = 'definition' } end,
        ['LSP symbols'] = function() extra.pickers.lsp { scope = 'document_symbol' } end,
        ['LSP workspace symbols'] = function() extra.pickers.lsp { scope = 'workspace_symbol' } end,
        ['Git commits'] = extra.pickers.git_commits,
        ['Git branches'] = extra.pickers.git_branches,
        ['Registers'] = extra.pickers.registers,
        ['Commands'] = extra.pickers.commands,
        ['Explorer'] = extra.pickers.explorer,
        ['Treesitter'] = extra.pickers.treesitter,
        ['Quickfix'] = function() extra.pickers.list { scope = 'quickfix' } end,
        ['Jumps'] = function() extra.pickers.list { scope = 'jump' } end,
      }
      if map[choice] then map[choice]() end
    end)
  end, { desc = '[S]earch [S]elect picker' })
end

function M.setup()
  setup_engine_tag_highlights()
  setup_picker_highlights()
  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
      setup_engine_tag_highlights()
      setup_picker_highlights()
    end,
  })

  pick.setup {
    mappings = {
      choose_marked = '<C-q>',
      paste_clipboard = {
        char = '<C-y>',
        func = paste_clipboard,
      },
    },
    source = {
      match = match_unordered,
    },
    options = {
      use_cache = true,
    },
    window = {
      prompt_prefix = '  ',
      config = window_config,
    },
  }

  vim.ui.select = pick.ui_select
  require('mini.extra').setup()
  setup_cursor_restore()
  setup_keymaps()
end

return M
