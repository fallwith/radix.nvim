local function fail(message)
  error(message, 0)
end

local palettes = require("radix.palette")
local allowed = {}

for variant, palette in pairs(palettes) do
  local palette_size = 0
  for scale, values in pairs(palette) do
    if #values ~= 12 then
      fail(("Radix %s scale %s has %d values, expected 12"):format(variant, scale, #values))
    end
    for _, color in ipairs(values) do
      if not color:match("^#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]$") then
        fail("Invalid palette color: " .. color)
      end
      allowed[color] = true
      palette_size = palette_size + 1
    end
  end
  if palette_size ~= 132 then
    fail(("%s palette has %d values, expected 132"):format(variant, palette_size))
  end
end

local function assert_direct_colors(value, path, visited)
  if type(value) == "string" and value:sub(1, 1) == "#" and not allowed[value] then
    fail(("%s uses non-Radix color %s"):format(path, value))
  end
  if type(value) ~= "table" or visited[value] then
    return
  end
  visited[value] = true
  for key, child in pairs(value) do
    assert_direct_colors(child, path .. "." .. tostring(key), visited)
  end
end

local function test_variant(variant)
  local options = require("radix.config").extend({ style = variant })
  local colors = require("radix.colors").setup(options)
  local highlights = require("radix.highlights").get(colors, options)

  assert_direct_colors(colors, variant .. ".colors", {})
  assert_direct_colors(highlights, variant .. ".highlights", {})
  if colors.bg ~= colors.palette.slate[3]
    or colors.bg_dark ~= colors.palette.slate[2]
    or colors.bg_popup ~= colors.palette.slate[2]
    or colors.bg_sidebar ~= colors.palette.slate[2]
    or colors.bg_float ~= colors.palette.slate[2]
    or colors.bg_statusline ~= colors.palette.slate[2]
    or colors.bg_highlight ~= colors.palette.slate[4]
  then
    fail(variant .. " UI surfaces are not using the neutral Slate scale")
  end
  if highlights.LspReferenceText.bg ~= colors.bg_highlight
    or highlights.LspReferenceRead.bg ~= colors.bg_highlight
    or highlights.CursorLine.bg ~= colors.bg_dark
    or highlights.IblIndent.fg ~= colors.palette.slate[5]
    or highlights.ScrollbarHandle.bg ~= colors.palette.slate[6]
    or highlights.SnacksPicker.bg ~= colors.bg_highlight
    or highlights.SnacksPickerInput.bg ~= colors.bg_highlight
    or highlights.SnacksPickerBorder.bg ~= colors.bg_highlight
    or highlights.SnacksTitle.bg ~= colors.bg_highlight
    or highlights.SnacksPickerTitle ~= "SnacksTitle"
  then
    fail(variant .. " direct Slate highlights do not contrast with the main background")
  end
  if highlights.Function.fg ~= colors.palette.blue[11]
    or highlights.String.fg ~= colors.palette.green[11]
    or highlights.Keyword.fg ~= colors.palette.purple[11]
  then
    fail(variant .. " syntax colors were unexpectedly neutralized")
  end

  vim.cmd.colorscheme("radix-" .. variant)
  if vim.g.colors_name ~= "radix-" .. variant then
    fail(variant .. " colorscheme did not set g:colors_name")
  end
  if vim.o.background ~= variant or vim.g.radix_style ~= variant then
    fail(variant .. " colorscheme did not set the active background style")
  end

  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  if normal.fg ~= tonumber(colors.fg:sub(2), 16) or normal.bg ~= tonumber(colors.bg:sub(2), 16) then
    fail(variant .. " Normal does not use the expected Radix colors")
  end
  if vim.g.terminal_color_0 ~= colors.terminal[1]
    or vim.g.terminal_color_15 ~= colors.terminal[16]
  then
    fail(variant .. " terminal palette was not applied")
  end

  package.loaded["lualine.themes.radix"] = nil
  local lualine = require("lualine.themes.radix")
  if lualine.normal.a.bg ~= colors.blue
    or lualine.normal.a.fg ~= colors.bg
    or lualine.insert.a.bg ~= colors.green
    or lualine.visual.a.bg ~= colors.purple
    or lualine.replace.a.bg ~= colors.red
    or lualine.command.a.bg ~= colors.yellow
    or lualine.terminal.a.bg ~= colors.teal
  then
    fail("lualine did not follow the active " .. variant .. " style")
  end
end

test_variant("dark")
test_variant("light")

vim.g.colors_name = nil
vim.o.background = "dark"
require("radix").setup({})
vim.cmd.colorscheme("radix")

if vim.g.colors_name ~= "radix" or vim.g.radix_style ~= "dark" then
  fail("automatic style did not use the initial background")
end

vim.o.background = "light"
local automatic_normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
if vim.g.colors_name ~= "radix"
  or vim.g.radix_style ~= "light"
  or automatic_normal.bg ~= tonumber(palettes.light.slate[3]:sub(2), 16)
then
  fail("automatic style did not follow a background change")
end

local callback_ran = false
require("radix").setup({
  style = "light",
  transparent = true,
  styles = {
    comments = { italic = false },
    sidebars = "transparent",
    floats = "transparent",
  },
  on_highlights = function(groups, colors)
    callback_ran = true
    groups.RadixTest = { fg = colors.palette.violet[11] }
  end,
})
require("radix").load()

if not callback_ran then
  fail("on_highlights callback did not run")
end
if vim.g.colors_name ~= "radix" or vim.o.background ~= "light" then
  fail("configured radix entry point did not load the light style")
end
local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
if normal.bg ~= nil then
  fail("transparent mode still sets the Normal background")
end
local normal_float = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
if normal_float.bg ~= nil then
  fail("transparent float style still sets the NormalFloat background")
end
local comment = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
if comment.italic then
  fail("comment style override was not applied")
end
local custom = vim.api.nvim_get_hl(0, { name = "RadixTest", link = false })
if custom.fg ~= tonumber(palettes.light.violet[11]:sub(2), 16) then
  fail("on_highlights override was not applied")
end

local ok, message = pcall(require("radix.colors").setup, { style = "invalid" })
if ok or not message:match("invalid Radix style") then
  fail("invalid styles should produce a useful error")
end

print("radix.nvim tests passed")
