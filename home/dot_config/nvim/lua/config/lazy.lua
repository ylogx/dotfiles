-- Bootstrap lazy.nvim (self-clones on first launch; plugins install to
-- stdpath("data") = ~/.local/share/nvim, nothing lands in the dotfiles repo
-- except lazy-lock.json, which pins plugin versions)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local result = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim:\n" .. result)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "vim-monokai-tasty" } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "zipPlugin", "tohtml", "tutor",
      },
    },
  },
})
