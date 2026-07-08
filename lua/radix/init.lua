local M = {}

function M.setup(options)
  require("radix.config").setup(options)
end

function M.colors(options)
  local config = require("radix.config").extend(options)
  if (not options or options.style == nil) and vim.g.radix_style then
    config.style = vim.g.radix_style
  end
  local colors = require("radix.colors").setup(config)
  config.on_colors(colors)
  return colors
end

function M.load(options)
  local config = require("radix.config").extend(options)
  local colors = require("radix.colors").setup(config)
  config.on_colors(colors)

  local highlights = require("radix.highlights").get(colors, config)
  config.on_highlights(highlights, colors)

  if vim.g.colors_name then
    vim.cmd("highlight clear")
  end
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.o.background = colors.style
  vim.g.colors_name = config.name or "radix"
  vim.g.radix_style = colors.style

  for group, highlight in pairs(highlights) do
    if type(highlight) == "string" then
      highlight = { link = highlight }
    end
    vim.api.nvim_set_hl(0, group, highlight)
  end

  if config.terminal_colors then
    for index, color in ipairs(colors.terminal) do
      vim.g["terminal_color_" .. (index - 1)] = color
    end
  end
end

return M
