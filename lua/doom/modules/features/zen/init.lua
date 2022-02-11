local zen = {}

zen.settings = {
  ui = {
    bottom = {
      laststatus = 0,
      ruler = false,
      showmode = false,
      showcmd = false,
      cmdheight = 1,
    },
    top = {
      showtabline = 0,
    },
    left = {
      number = false,
      relativenumber = false,
      signcolumn = "no",
    },
  },
  modes = {
    ataraxis = {
      left_padding = 30,
      right_padding = 30,
      top_padding = 0,
      bottom_padding = 0,
      ideal_writing_area_width = { 0 },
      just_do_it_for_me = true,
      keep_default_fold_fillchars = true,
      custome_bg = "",
      bg_configuration = true,
    },
    focus = {
      margin_of_error = 5,
      focus_method = "experimental",
    },
  },
  integrations = {
    galaxyline = true,
    tmux = true,
    gitsigns = true,
    nvim_bufferline = true,
  },
  misc = {
    on_off_commands = false,
    ui_elements_commands = false,
    cursor_by_mode = false,
  },
}

zen.packages = {
  ["TrueZen.nvim"] = {
    "Pocco81/TrueZen.nvim",
    commit = "508b977d71650da5c9243698614a9a1416f116d4",
    module = "true-zen",
    event = "BufWinEnter",
  },
}
 

zen.configure_functions = {}
zen.configure_functions["TrueZen.nvim"] = function()
  require("true-zen").setup(doom.modules.zen.settings)
end

zen.binds = {
  { "<F5>", ":TZAtaraxis<CR>", name = "Enter Nirvana" },
}

return zen
