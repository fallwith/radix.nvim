local M = {}

local modules = {
  "radix.groups.core",
  "radix.groups.treesitter",
  "radix.groups.semantic_tokens",
  "radix.groups.plugins",
}

function M.get(colors, options)
  local highlights = {}
  for _, module in ipairs(modules) do
    highlights = vim.tbl_extend("force", highlights, require(module).get(colors, options))
  end
  return highlights
end

return M
