local c = require("core.palette")

local theme = {
  normal = {
    a = { fg = c.white,  bg = c.accent,     gui = "bold" },
    b = { fg = c.fg,     bg = c.surface },
    c = { fg = c.subtle, bg = "NONE" },
    x = { fg = c.subtle, bg = "NONE" },
    y = { fg = c.fg,     bg = c.surface },
    z = { fg = c.white,  bg = c.accent,     gui = "bold" },
  },
  insert  = { a = { fg = c.bg, bg = c.green,      gui = "bold" }, z = { fg = c.bg, bg = c.green,      gui = "bold" } },
  visual  = { a = { fg = c.bg, bg = c.yellow,     gui = "bold" }, z = { fg = c.bg, bg = c.yellow,     gui = "bold" } },
  replace = { a = { fg = c.white, bg = c.accent_alt, gui = "bold" }, z = { fg = c.white, bg = c.accent_alt, gui = "bold" } },
  command = { a = { fg = c.bg, bg = c.blue,       gui = "bold" }, z = { fg = c.bg, bg = c.blue,       gui = "bold" } },
  inactive = {
    a = { fg = c.muted, bg = "NONE" }, b = { fg = c.muted, bg = "NONE" },
    c = { fg = c.muted, bg = "NONE" }, x = { fg = c.muted, bg = "NONE" },
    y = { fg = c.muted, bg = "NONE" }, z = { fg = c.muted, bg = "NONE" },
  },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = theme,
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = { statusline = { "neo-tree", "NvimTree", "lazy", "mason" } },
      },
      sections = {
        lualine_a = { { "mode", fmt = function(mode) return mode:sub(1, 1) end } },
        lualine_b = {
          { "branch", icon = "git" },
          { "diff", symbols = { added = "+", modified = "~", removed = "-" }, colored = true },
        },
        lualine_c = {
          { "filename", file_status = true, newfile_status = true, path = 1,
            symbols = { modified = " *", readonly = " ro", unnamed = "[No Name]", newfile = " new" } },
        },
        lualine_x = {
          { "diagnostics", sources = { "nvim_diagnostic" },
            symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" } },
          "encoding", "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {}, lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {}, lualine_z = {},
      },
    },
  },
}
