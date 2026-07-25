local M = {}

M.defaults = {
  style = "auto",
  transparent = false,
  terminal_colors = true,
  dim_inactive = false,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    sidebars = "dark",
    floats = "dark",
  },
  on_colors = function(_) end,
  on_highlights = function(_, _) end,
}

M.options = vim.deepcopy(M.defaults)

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), options or {})
end

function M.extend(options)
  return vim.tbl_deep_extend("force", vim.deepcopy(M.options), options or {})
end

return M
