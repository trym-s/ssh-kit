return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      heading = {
        enabled = true,
        sign = false,
        width = "full",
        icons = { ". ", ".. ", "... ", ".... ", "..... ", "...... " },
      },
      checkbox = {
        enabled = true,
      },
      bullet = {
        enabled = true,
      },
      code = {
        enabled = true,
        width = "block",
        right_pad = 1,
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = ""
          vim.opt_local.linebreak = true
          vim.opt_local.wrap = true
        end,
      })
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        AARRGGBB = true,
        names = false,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = false,
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = false,
      keywords = {
        TODO = { icon = "T", color = "info" },
        DONE = { icon = "D", color = "hint" },
        NOTE = { icon = "N", color = "hint" },
        IDEA = { icon = "I", color = "hint" },
        DECISION = { icon = "D", color = "warning" },
        IMPORTANT = { icon = "!", color = "warning" },
        QUESTION = { icon = "?", color = "test" },
        BLOCKED = { icon = "B", color = "error" },
      },
      highlight = {
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = false,
      },
      search = {
        pattern = [[\b(KEYWORDS)\s*:]],
      },
    },
  },
}
