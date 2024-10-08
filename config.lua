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

-- Enabling exrc
vim.o.exrc = true
vim.o.secure = true

-- Reloading externally changed files
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- Neovide config
if vim.g.neovide then
  -- vim.g.neovide_scale_factor = 0.85
  vim.o.guifont = "Hack,Noto_Color_Emoji,Source Code Pro:h13:#e-subpixelantialias:#h-none"
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_hide_mouse_when_typing = true
end

vim.opt.colorcolumn = "120"

if vim.loop.os_uname().sysname == "Windows_NT" then
  doom.features.terminal.settings.shell = '"C:/Program Files/Git/bin/bash.exe" -i -l'
end

doom.langs.cc.settings.language_server_name = "clangd"
doom.core.treesitter.settings.show_compiler_warning_message = false

doom.features.linter.settings.format_on_save = true

doom.features.lsp.settings.signature.floating_window = true

-- deprecation warnings

vim.treesitter.query.get_query = vim.treesitter.query.get
vim.treesitter.query.get_node_text = vim.treesitter.get_node_text

doom.features.annotations.settings.languages.rust =
{ template = { annotation_convention = "rust_alternative" } }

-- DAP

doom.use_package({
  "nvim-neotest/nvim-nio",
})

doom.modules.features.dap.configs["nvim-dap"] = function()
  local dap = require("dap")
  if vim.fn.executable("lldb-vscode") == 1 then
    dap.adapters.lldb = {
      type = "executable",
      command = vim.fn.exepath("lldb-vscode"),
      name = "lldb",
    }
  end
  if
      os.getenv("VIRTUAL_ENV") and vim.fn.executable(os.getenv("VIRTUAL_ENV") .. "/bin/python") == 1
  then
    dap.adapters.python = {
      type = "executable",
      command = os.getenv("VIRTUAL_ENV") .. "/bin/python",
      args = { "-m", "debugpy.adapter" },
    }
  elseif vim.fn.executable("python3") == 1 then
    dap.adapters.python = {
      type = "executable",
      command = vim.fn.exepath("python3"),
      args = { "-m", "debugpy.adapter" },
    }
  elseif vim.fn.executable("python") == 1 then
    dap.adapters.python = {
      type = "executable",
      command = vim.fn.exepath("python"),
      args = { "-m", "debugpy.adapter" },
    }
  end

  local project_launch_path = vim.fn.getcwd() .. "/.dap/launch.json"
  local lsp_clients = vim.lsp.get_active_clients()
  if lsp_clients ~= nil then
    for _, item in ipairs(lsp_clients) do
      local candidate = item.root_dir .. "/.dat/launch.json"
      if vim.fn.filereadable(candidate) then
        project_launch_path = candidate
        break
      end
    end
  end

  require("dap.ext.vscode").load_launchjs(project_launch_path, { cppdbg = { "c", "cpp" } })
end

vim.keymap.set("n", "<F5>", function()
  require("dap").continue()
end)
vim.keymap.set("n", "<F10>", function()
  require("dap").step_over()
end)
vim.keymap.set("n", "<F11>", function()
  require("dap").step_into()
end)
vim.keymap.set("n", "<F12>", function()
  require("dap").step_out()
end)

doom.use_keybind({
  -- The `name` field will add the keybind to whichkey
  {
    "<leader>s",
    name = "+search",
    {
      -- Bind to a vim command
      { "g", "Telescope grep_string<CR>", name = "Grep project" },
    },
  },
})

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

-- doom.use_package({
--   "rcarriga/nvim-notify",
--   config = function()
--     require("notify").setup({
--       stages = "fade",
--     })
--     vim.notify = require("notify")
--   end,
-- })

doom.modules.features.lsp_progress.packages["fidget.nvim"].tag = "v1.4.5"
doom.modules.features.lsp_progress.settings = {
  notification = {
    override_vim_notify = true,
  },
  integration = {
    ["nvim-tree"] = {
      enable = false,
    },
    ["xcodebuild-nvim"] = {
      enable = false,
    },
  },
}

-- Codeium
-- see: https://github.com/Exafunction/codeium.vim

table.insert(doom.modules.features.lsp.settings.completion.sources, { name = "codeium" })

-- -- NVIM package works with cmp (no comment generation)
-- doom.use_package({
--   "Exafunction/codeium.nvim",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "hrsh7th/nvim-cmp",
--   },
--   config = function()
--     require("codeium").setup({})
--   end,
-- })

doom.use_package({
  "Exafunction/codeium.vim",
  config = function()
    -- Change '<C-g>' here to any keycode you like.
    vim.keymap.set("i", "<C-Enter>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true, silent = true })
    vim.keymap.set("i", "<c-;>", function()
      return vim.fn["codeium#CycleCompletions"](1)
    end, { expr = true, silent = true })
    vim.keymap.set("i", "<c-,>", function()
      return vim.fn["codeium#CycleCompletions"](-1)
    end, { expr = true, silent = true })
    vim.keymap.set("i", "<c-x>", function()
      return vim.fn["codeium#Clear"]()
    end, { expr = true, silent = true })
    vim.keymap.set("n", "<M-c>", function()
      return vim.fn["codeium#Chat"]()
    end, { expr = true, silent = true })
  end,
})

local ignored_projects = {}

local ignored_buffers = {
  "/dev/shm/pass",
}

doom.use_autocmd({
  "BufEnter",
  "*",
  function(ev)
    -- Ignore buffers with no name
    if string.len(ev.match) == 0 then
      return
    end
    -- Ignore buffers in ignored_buffers
    for _, value in pairs(ignored_buffers) do
      if string.find(ev.match, value) then
        if vim.g.codeium_enabled then
          vim.g.codeium_enabled = false
          vim.notify("Disabled for this buffer", "warn", { title = "Codeium", timeout = 1000 })
        end
        return
      end
    end
    for _, value in pairs(ignored_projects) do
      if string.find(ev.match, value) then
        if vim.g.codeium_enabled then
          vim.g.codeium_enabled = false
          vim.notify(
            "Disabled for project " .. value,
            "warn",
            { title = "Codeium", timeout = 1000 }
          )
        end
        return
      end
    end

    if not vim.g.codeium_enabled then
      vim.g.codeium_enabled = true
      vim.notify("Enabled", "info", { title = "Codeium", timeout = 1000 })
    end
  end,
})

-- chatgpt

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
