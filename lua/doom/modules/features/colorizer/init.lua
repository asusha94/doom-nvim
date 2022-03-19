local colorizer = {}

colorizer.settings = {
  "*",
  css = { rgb_fn = true },
  html = { names = false },
}

colorizer.uses = {
  ["nvim-colorizer.lua"] = {
    "norcalli/nvim-colorizer.lua",
    commit = "36c610a9717cc9ec426a07c8e6bf3b3abcb139d6",
    event = "ColorScheme",
  },
}

colorizer.configs = {}
colorizer.configs["nvim-colorizer.lua"] = function()
  require("colorizer").setup(doom.modules.colorizer.settings)
end

return colorizer
