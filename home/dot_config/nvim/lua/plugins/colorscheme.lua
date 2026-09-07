return {
  -- Same monokai as terminal vim (~/.vimrc) for visual consistency
  {
    "patstockwell/vim-monokai-tasty",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.vim_monokai_tasty_italic = 1
    end,
    config = function()
      vim.cmd.colorscheme("vim-monokai-tasty")
    end,
  },
}
