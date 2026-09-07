return {
  -- Send selections to a tmux pane (C-c C-c), same as ~/.vimrc
  {
    "jpalardy/vim-slime",
    keys = {
      { "<C-c><C-c>", mode = "n", "<Plug>SlimeParagraphSend", remap = true },
      { "<C-c><C-c>", mode = "x", "<Plug>SlimeRegionSend", remap = true },
    },
  },

  -- Transparent editing of gpg-encrypted files (kept from ~/.vimrc)
  { "jamessan/vim-gnupg", lazy = false },
}
