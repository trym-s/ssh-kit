local parsers = {
  "bash",
  "python",
  "go",
  "html",
  "css",
  "javascript",
  -- required by render-markdown.nvim (notes.lua)
  "markdown",
  "markdown_inline",
}

local filetypes = {
  "bash",
  "sh",
  "python",
  "go",
  "html",
  "css",
  "javascript",
  "markdown",
}

return {
  "nvim-treesitter/nvim-treesitter",
  -- `main` requires Neovim 0.12; this system is on 0.11.
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = parsers,
      highlight = { enable = true },
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function()
        if vim.b.treesitter_enabled ~= false then
          local ok = pcall(vim.treesitter.start)
          if ok then
            vim.b.treesitter_enabled = true
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end
      end,
    })
  end,
}
