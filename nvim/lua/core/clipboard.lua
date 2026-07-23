-- Auto-select clipboard provider by environment.
-- SSH session: route yanks to the LOCAL (Windows) clipboard via OSC 52,
-- so `y` in a remote nvim reaches the Windows clipboard with nothing
-- installed on the server. Paste stays local (OSC 52 paste is unreliable).
-- Local WSL: leave the existing working provider in place.

local in_ssh = vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil

if in_ssh then
  local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
  if ok then
    vim.g.clipboard = {
      name = "OSC 52",
      copy = {
        ["+"] = osc52.copy("+"),
        ["*"] = osc52.copy("*"),
      },
      paste = {
        ["+"] = osc52.paste("+"),
        ["*"] = osc52.paste("*"),
      },
    }
  end
end
