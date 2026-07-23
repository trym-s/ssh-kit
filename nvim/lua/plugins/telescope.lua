return {
  "nvim-telescope/telescope.nvim",
  version = "0.1.8", -- stable tag: supports nvim >= 0.9 (master now requires 0.11)
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
  },
  opts = {
    defaults = {
      prompt_prefix = "  ",
      selection_caret = "> ",
      path_display = { "truncate" },
      layout_config = {
        prompt_position = "top",
      },
      sorting_strategy = "ascending",
      border = true,
    },
  },
}

