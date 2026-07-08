local palette = require("radix.palette")

local M = {}

function M.setup(options)
  local style = (options and options.style) or "dark"
  if style ~= "dark" and style ~= "light" then
    error(("invalid Radix style %q; expected 'dark' or 'light'"):format(style))
  end

  local p = palette[style]
  local is_dark = style == "dark"
  local styles = (options and options.styles) or {}
  local sidebar_style = styles.sidebars or "dark"
  local float_style = styles.floats or "dark"

  return {
    none = "NONE",
    style = style,
    palette = p,

    -- Surfaces and text use Radix's intended 1-12 scale progression.
    black = p.slate[1],
    bg = p.blue[1],
    bg_dark = p.slate[2],
    bg_highlight = p.blue[3],
    bg_popup = p.blue[2],
    bg_sidebar = sidebar_style == "transparent" and "NONE"
      or sidebar_style == "normal" and p.blue[1]
      or p.blue[2],
    bg_float = float_style == "transparent" and "NONE"
      or float_style == "normal" and p.blue[1]
      or p.blue[2],
    bg_statusline = p.blue[2],
    bg_visual = p.blue[4],
    bg_search = p.amber[9],
    fg_search = is_dark and p.amber[1] or p.amber[12],
    fg = p.slate[12],
    fg_dark = p.slate[11],
    fg_float = p.slate[12],
    fg_sidebar = p.slate[11],
    fg_gutter = p.slate[8],
    comment = p.slate[11],
    border = p.slate[6],
    border_highlight = p.blue[8],
    terminal_black = is_dark and p.slate[7] or p.slate[9],

    blue = p.blue[11],
    cyan = p.cyan[11],
    teal = p.teal[11],
    green = p.green[11],
    yellow = p.amber[11],
    orange = p.orange[11],
    red = p.red[11],
    magenta = p.pink[11],
    purple = p.purple[11],
    violet = p.violet[11],

    error = p.red[11],
    warning = p.amber[11],
    info = p.blue[11],
    hint = p.teal[11],
    todo = p.blue[11],

    git = {
      add = p.green[11],
      change = p.blue[11],
      delete = p.red[11],
      ignore = p.slate[8],
      staged_add = is_dark and p.green[7] or p.green[10],
      staged_change = is_dark and p.blue[7] or p.blue[10],
      staged_delete = is_dark and p.red[7] or p.red[10],
    },
    diff = {
      add = p.green[3],
      change = p.blue[3],
      delete = p.red[3],
      text = p.blue[5],
    },
    diagnostic_bg = {
      error = p.red[2],
      warning = p.amber[2],
      info = p.blue[2],
      hint = p.teal[2],
    },
    rainbow = {
      p.blue[11], p.amber[11], p.green[11], p.teal[11],
      p.pink[11], p.purple[11], p.orange[11], p.red[11],
    },
    terminal = is_dark and {
      p.slate[7], p.red[9], p.green[9], p.amber[9],
      p.blue[9], p.pink[9], p.cyan[9], p.slate[11],
      p.slate[8], p.red[11], p.green[11], p.amber[11],
      p.blue[11], p.pink[11], p.cyan[11], p.slate[12],
    } or {
      p.slate[12], p.red[11], p.green[11], p.amber[11],
      p.blue[11], p.pink[11], p.cyan[11], p.slate[11],
      p.slate[11], p.red[9], p.green[9], p.amber[9],
      p.blue[9], p.pink[9], p.cyan[9], p.slate[10],
    },
  }
end

return M
