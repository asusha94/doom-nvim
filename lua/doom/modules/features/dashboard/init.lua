local dashboard = {}

dashboard.settings = {
  entries = {
    {
      icon = "  ",
      desc = "Recently Opened Files          ",
      keymap = "SPC f r",
      key = "r",
      action = "Telescope oldfiles",
    },
    {
      icon = "  ",
      desc = "Jump to Bookmark               ",
      keymap = "SPC s m",
      key = "b",
      action = "Telescope marks",
    },
    {
      icon = "  ",
      desc = "Open Configuration             ",
      keymap = "SPC D c",
      key = "c",
      action = "e " .. require("doom.core.config").source,
    },
    {
      icon = "  ",
      desc = "Open Modules                   ",
      keymap = "SPC D m",
      key = "m",
      action = "e " .. require("doom.core.modules").source,
    },
    {
      icon = "  ",
      desc = "Open Documentation             ",
      keymap = "SPC D d",
      key = "d",
      action = "lua require('doom.core.functions').open_docs()",
    },
  },
  header = {
    "                                                                              ",
    "=================     ===============     ===============   ========  ========",
    "\\\\ . . . . . . .\\\\   //. . . . . . .\\\\   //. . . . . . .\\\\  \\\\. . .\\\\// . . //",
    "||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\\/ . . .||",
    "|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||",
    "||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||",
    "|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\\ . . . . ||",
    "||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\\_ . .|. .||",
    "|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\\ `-_/| . ||",
    "||_-' ||  .|/    || ||    \\|.  || `-_|| ||_-' ||  .|/    || ||   | \\  / |-_.||",
    "||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \\  / |  `||",
    "||    `'         || ||         `'    || ||    `'         || ||   | \\  / |   ||",
    "||            .===' `===.         .==='.`===.         .===' /==. |  \\/  |   ||",
    "||         .=='   \\_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \\/  |   ||",
    "||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \\/  |   ||",
    "||   .=='    _-'          `-__\\._-'         `-_./__-'         `' |. /|  |   ||",
    "||.=='    _-'                                                     `' |  /==.||",
    "=='    _-'                        N E O V I M                         \\/   `==",
    "\\   _-'                                                                `-_   /",
    " `''                                                                      ``'  ",
  },
  footer = { "", "Doom Nvim loaded" },
  colors = {
    header = "#586268",
    center = "#51afef",
    keymap = "#a9a1e1",
    footer = "#586268",
  },
}

dashboard.packages = {
  ["dashboard-nvim"] = {
    "nvimdev/dashboard-nvim",
    cmd = "Dashboard",
    lazy = true,
  },
}

dashboard.configs = {}
dashboard.configs["dashboard-nvim"] = function()
  local utils = require("doom.utils")
  local db = require("dashboard")
  local is_module_enabled = utils.is_module_enabled

  if is_module_enabled("features", "auto_session") then
    vim.g.dashboard_session_directory = doom.features.auto_session.settings.dir
  end
  if is_module_enabled("features", "telescope") then
    vim.g.dashboard_default_executive = "telescope"
  end
  if is_module_enabled("features", "auto_session") then
    table.insert(doom.features.dashboard.settings.entries, {
      icon = "  ",
      desc = "Load Last Session              ",
      keymap = "SPC q r",
      key = "l",
      action = "lua require('persistence').load({ last = true })",
    })
  end

  local config = {}

  config.center = doom.features.dashboard.settings.entries

  if type(doom.features.dashboard.settings.footer) ~= "function" then
    config.footer = doom.features.dashboard.settings.footer
  end

  if type(doom.features.dashboard.settings.header) ~= "function" then
    config.header = doom.features.dashboard.settings.header
  end

  db.setup({
    theme = "doom",
    config = config,
    hide = {
      tabline = false,
      statusline = false,
    },
  })

  -- Header color
  vim.cmd("hi! dashboardHeader   guifg=" .. doom.features.dashboard.settings.colors.header)
  vim.cmd("hi! dashboardCenter   guifg=" .. doom.features.dashboard.settings.colors.center)
  vim.cmd("hi! DashboardCenterIcon   guifg=" .. doom.features.dashboard.settings.colors.center)
  vim.cmd("hi! dashboardShortcut guifg=" .. doom.features.dashboard.settings.colors.keymap)
  vim.cmd("hi! dashboardFooter   guifg=" .. doom.features.dashboard.settings.colors.footer)
end

dashboard.binds = {
  "<leader>",
  name = "+prefix",
  {
    {
      "o",
      name = "+open/close",
      {
        { "D", "<cmd>Dashboard<CR>", name = "Dashboard" },
      },
    },
  },
}

dashboard.autocmds = {
  {
    "FileType",
    "dashboard",
    function()
      require("doom.services.keymaps").applyKeymaps({ "q", "<cmd>q<CR>", buffer = true })
    end,
  },
  {
    "VimEnter",
    "*",
    function()
      local utils = require("doom.utils")
      local is_module_enabled = utils.is_module_enabled
      -- Here we check for
      -- 1. Number of files passed to Neovim as arguments during its launch
      -- 2. Bytes count from the start of the buffer to the end (it should be non-existent, -1)
      -- 3. Existence of the buffer
      if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 and vim.fn.bufexists(0) == 0 then
        if is_module_enabled("features", "dashboard") then
          vim.cmd("Dashboard")
        end
      end
    end,
    once = true,
  },
}

return dashboard
