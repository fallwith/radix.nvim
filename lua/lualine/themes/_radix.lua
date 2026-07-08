local M = {}

function M.get(style)
  local options = style and { style = style } or nil
  local c = require("radix").colors(options)

  return {
    normal = {
      a = { fg = c.palette.blue[1], bg = c.blue, gui = "bold" },
      b = { fg = c.fg, bg = c.palette.blue[4] },
      c = { fg = c.fg_dark, bg = c.bg_statusline },
    },
    insert = {
      a = { fg = c.palette.green[1], bg = c.green, gui = "bold" },
    },
    command = {
      a = { fg = c.palette.amber[1], bg = c.yellow, gui = "bold" },
    },
    visual = {
      a = { fg = c.palette.purple[1], bg = c.purple, gui = "bold" },
    },
    replace = {
      a = { fg = c.palette.red[1], bg = c.red, gui = "bold" },
    },
    terminal = {
      a = { fg = c.palette.teal[1], bg = c.teal, gui = "bold" },
    },
    inactive = {
      a = { fg = c.fg_gutter, bg = c.bg_statusline },
      b = { fg = c.fg_gutter, bg = c.bg_statusline },
      c = { fg = c.fg_gutter, bg = c.bg_statusline },
    },
  }
end

return M
