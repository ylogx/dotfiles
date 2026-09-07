return {
  -- Seamless pane navigation between nvim splits and tmux panes (C-h/j/k/l)
  -- tmux side is already bound in ~/.tmux.conf
  {
    "christoomey/vim-tmux-navigator",
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>", "<C-\\>" },
  },
}
