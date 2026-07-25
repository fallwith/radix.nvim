# radix.nvim

A dark and light Neovim colorscheme with Tokyo Night's colorful, low-distraction approach and palettes made entirely from [Radix Colors](https://www.radix-ui.com/colors).

Every shipped hex value is copied directly from an alpha-free light or dark scale in `@radix-ui/colors` 3.0.0. The theme does not blend, brighten, interpolate, or invent colors. Slate provides restrained editor chrome, Blue marks active UI, and Radix's step-11 accent colors provide syntax colors.

## Features

- Core editor, Vim syntax, Treesitter, and LSP semantic-token highlights
- Native diagnostic, diff, search, terminal, and popup colors
- Highlight support for common completion, picker, Git, explorer, UI, DAP, test, motion, and Markdown plugins
- A matching lualine theme
- Automatic light and dark switching with Neovim's `background` option
- Explicit `radix-dark` and `radix-light` variants
- Configurable main, sidebar, and floating-window backgrounds plus Tokyo Night-style callbacks

## Installation

With lazy.nvim (replace `your-name` with the repository owner):

```lua
{
  "your-name/radix.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("radix").setup({})
    vim.cmd.colorscheme("radix")
  end,
}
```

Or add this directory to `runtimepath` and run:

```vim
colorscheme radix-dark
" or
colorscheme radix-light
```

`colorscheme radix` follows Neovim's `background` option by default. Neovim reloads the
colorscheme automatically when terminal background detection changes that option. Use
`radix-dark`, `radix-light`, or an explicit `style` to pin a variant.

## Configuration

Call `setup()` before loading the colorscheme:

```lua
require("radix").setup({
  style = "auto", -- "auto", "dark", or "light"
  transparent = false,
  terminal_colors = true,
  dim_inactive = false,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    -- "dark", "normal", or "transparent"
    sidebars = "dark",
    floats = "dark",
  },
  on_colors = function(colors)
    -- Semantic colors can be remapped to another literal Radix token.
    colors.hint = colors.palette.violet[11]
  end,
  on_highlights = function(highlights, colors)
    highlights.CursorLineNr = { fg = colors.yellow, bold = true }
  end,
})
```

Both sets of scales are exposed as `require("radix.palette").dark` and `require("radix.palette").light`. The palette for the active variant is available as `colors.palette`. Each scale is a 12-element Lua array matching Radix steps 1 through 12.

`transparent = true` clears the main editor background. Set `styles.sidebars` and/or `styles.floats` to `"transparent"` when those surfaces should also show through. Popup menus and the statusline intentionally retain a solid background for readability.

### Lualine

```lua
require("lualine").setup({ options = { theme = "radix" } })
```

The `radix` lualine theme follows the currently loaded variant. Explicit `radix-dark` and `radix-light` lualine themes are also available.
Its active mode segment uses a solid mode color: blue for normal, green for insert, purple for visual, red for replace, amber for command, and teal for terminal.

## Radix scale choices

| Role | Radix token in each variant |
| --- | --- |
| Main background | `slate3` |
| Subtle/popup/cursor-line background | `slate2` |
| Hovered surfaces | `slate4` |
| Active selection | `blue3` |
| Main text | `slate12` |
| Muted text/comments | `slate8`–`slate11` |
| Syntax accents | Step 11 of Blue, Cyan, Teal, Green, Amber, Orange, Red, Pink, Purple, and Violet |
| Diff/diagnostic surfaces | Steps 2–3 of the corresponding semantic scale |

The UI is intentionally neutral-first: Slate is used for surfaces, borders,
completion kinds, and general chrome; Blue is the sole interactive accent.
Other hues are reserved for syntax or meaningful states such as diagnostics,
Git changes, tests, searches, and jump targets.

## Development

Run the headless Neovim checks with:

```sh
make test
```

The test suite also rejects any default highlight color that is not present in the checked-in Radix palette.

## Attribution

The highlight organization and configuration ergonomics are inspired by [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim), licensed under Apache-2.0. Color values are from [radix-ui/colors](https://github.com/radix-ui/colors), licensed under MIT. See `NOTICE` and `LICENSES/`.
