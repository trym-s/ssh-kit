local c = require("core.palette")

return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>o", "<cmd>Oil<cr>", desc = "Open directory editor" },
    { "-",         "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  opts = {
    default_file_explorer = true,
    columns      = { "icon", "permissions", "size", "mtime" },
    view_options = { show_hidden = true, natural_order = true },
    win_options  = {
      signcolumn = "no",
      cursorline = true,
      winhl = "Normal:OilNormal,NormalNC:OilNormal,CursorLine:OilCursorLine",
    },
    keymaps = {
      ["<CR>"]  = "actions.select",  ["<C-v>"] = "actions.select_vsplit",
      ["<C-s>"] = "actions.select_split", ["<C-p>"] = "actions.preview",
      ["-"]     = "actions.parent",  ["_"]     = "actions.open_cwd",
      ["g."]    = "actions.toggle_hidden", ["q"] = "actions.close",
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)
    vim.api.nvim_set_hl(0, "OilNormal",     { fg = c.fg,     bg = "NONE" })
    vim.api.nvim_set_hl(0, "OilCursorLine", { bg = c.surface })
    vim.api.nvim_set_hl(0, "OilDir",        { fg = c.blue,   bold = true })
    vim.api.nvim_set_hl(0, "OilDirIcon",    { fg = c.accent })
    vim.api.nvim_set_hl(0, "OilFile",       { fg = c.fg })
    vim.api.nvim_set_hl(0, "OilLink",       { fg = c.cyan })
    vim.api.nvim_set_hl(0, "OilCreate",     { fg = c.green })
    vim.api.nvim_set_hl(0, "OilDelete",     { fg = c.accent_alt })
    vim.api.nvim_set_hl(0, "OilMove",       { fg = c.yellow })
  end,
}
