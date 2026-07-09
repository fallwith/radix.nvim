local M = {}

function M.get(style)
  local options = style and { style = style } or nil
  local c = require("radix").colors(options)
  local mode = {
    normal = c.blue,
    insert = c.green,
    command = c.yellow,
    visual = c.purple,
    replace = c.red,
    terminal = c.teal,
  }

  return {
    normal = {
      a = { fg = c.bg, bg = mode.normal, gui = "bold" },
      b = { fg = c.fg, bg = c.palette.slate[2] },
      c = { fg = c.fg_dark, bg = c.bg_statusline },
    },
    insert = {
      a = { fg = c.bg, bg = mode.insert, gui = "bold" },
    },
    command = {
      a = { fg = c.bg, bg = mode.command, gui = "bold" },
    },
    visual = {
      a = { fg = c.bg, bg = mode.visual, gui = "bold" },
    },
    replace = {
      a = { fg = c.bg, bg = mode.replace, gui = "bold" },
    },
    terminal = {
      a = { fg = c.bg, bg = mode.terminal, gui = "bold" },
    },
    inactive = {
      a = { fg = c.fg_gutter, bg = c.bg_statusline },
      b = { fg = c.fg_gutter, bg = c.bg_statusline },
      c = { fg = c.fg_gutter, bg = c.bg_statusline },
    },
  }
end

return M
