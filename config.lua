-- doom_config - Doom Nvim user configurations file
--
-- This file contains the user-defined configurations for Doom nvim.
-- Just override stuff in the `doom` global table (it's injected into scope
-- automatically).

-- ADDING A PACKAGE
--
-- doom.use_package("EdenEast/nightfox.nvim", "sainnhe/sonokai")
-- doom.use_package({
--   "ur4ltz/surround.nvim",
--   config = function()
--     require("surround").setup({mappings_style = "sandwich"})
--   end
-- })

-- ADDING A KEYBIND
--
-- doom.use_keybind({
--   -- The `name` field will add the keybind to whichkey
--   {"<leader>s", name = '+search', {
--     -- Bind to a vim command
--     {"g", "Telescope grep_string<CR>", name = "Grep project"},
--     -- Or to a lua function
--     {"p", function()
--       print("Not implemented yet")
--     end, name = ""}
--   }}
-- })

-- ADDING A COMMAND
--
-- doom.use_cmd({
--   {"CustomCommand1", function() print("Trigger my custom command 1") end},
--   {"CustomCommand2", function() print("Trigger my custom command 2") end}
-- })

-- ADDING AN AUTOCOMMAND
--
-- doom.use_autocmd({
--   { "FileType", "javascript", function() print('This is a javascript file') end }
-- })

-- doom.freeze_dependencies = false
-- doom.indent = 2

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

if vim.g.neovide then
  -- vim.g.neovide_scale_factor = 0.85
  vim.o.guifont = "Hack,Noto_Color_Emoji,Source Code Pro:h13:#e-subpixelantialias:#h-none"
  vim.g.neovide_remember_window_size = true
end

vim.opt.colorcolumn = "120"

doom.langs.cc.settings.language_server_name = "clangd"

doom.features.linter.settings.format_on_save = true

doom.features.lsp.settings.signature.floating_window = true

-- deprecation warnings

vim.treesitter.query.get_query = vim.treesitter.query.get
vim.treesitter.query.get_node_text = vim.treesitter.get_node_text

-- jupyter notebooks

doom.use_package({
  "meatballs/notebook.nvim",
  config = function()
    require("notebook").setup({
      -- Whether to insert a blank line at the top of the notebook
      insert_blank_line = true,

      -- Whether to display the index number of a cell
      show_index = true,

      -- Whether to display the type of a cell
      show_cell_type = true,

      -- Style for the virtual text at the top of a cell
      virtual_text_style = { fg = "lightblue", italic = true },
    })
  end,
})

-- chatgpt

vim.env.OPENAI_API_KEY = "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"

-- doom.use_package({
--   "jackMort/ChatGPT.nvim",
--   config = function()
--       require("chatgpt").setup({
--         keymaps = {
--           submit = "<M-Enter>"
--         }
--       })
--   end,
--   dependencies = {
--       "MunifTanjim/nui.nvim",
--       "nvim-lua/plenary.nvim",
--       "nvim-telescope/telescope.nvim"
--   }
-- })

-- vim: sw=2 sts=2 ts=2 expandtab
