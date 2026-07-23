local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

local command_aliases = {
  W = "w",
  Q = "q",
  Wq = "wq",
  WQ = "wq",
  wQ = "wq",
  Wqa = "wqa",
  WQa = "wqa",
  WQA = "wqa",
  Qa = "qa",
  QA = "qa",
}

for alias, command in pairs(command_aliases) do
  if alias:match("^[A-Z]") then
    vim.api.nvim_create_user_command(alias, command, {})
  end
end

for alias, command in pairs(command_aliases) do
  vim.cmd(
    ("cnoreabbrev <expr> %s getcmdtype() ==# ':' && getcmdline() ==# '%s' ? '%s' : '%s'"):format(
      alias,
      alias,
      command,
      alias
    )
  )
end

keymap("n", "<leader>w", "<cmd>write<cr>", opts)
keymap("n", "<leader>q", "<cmd>quit<cr>", opts)
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", opts)

keymap("n", "<leader>wv", "<C-w>v", opts)
keymap("n", "<leader>wx", "<cmd>close<cr>", opts)
keymap("n", "<leader>w<Left>", "<C-w>h", opts)
keymap("n", "<leader>w<Down>", "<C-w>j", opts)
keymap("n", "<leader>w<Up>", "<C-w>k", opts)
keymap("n", "<leader>w<Right>", "<C-w>l", opts)
keymap("n", "<leader>sv", "<C-w>v", opts)
keymap("n", "<leader>sh", "<C-w>s", opts)
keymap("n", "<leader>se", "<C-w>=", opts)
keymap("n", "<leader>sx", "<cmd>close<cr>", opts)

keymap("n", "dd", '"_dd', opts)
keymap("n", "xx", "dd", opts)

keymap("n", "<leader>ts", function()
  if vim.b.treesitter_enabled == false then
    local ok = pcall(vim.treesitter.start)
    if ok then
      vim.b.treesitter_enabled = true
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.notify("Treesitter enabled")
    end
  else
    pcall(vim.treesitter.stop)
    vim.b.treesitter_enabled = false
    vim.bo.indentexpr = ""
    vim.notify("Treesitter disabled")
  end
end, opts)
