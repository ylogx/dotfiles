return {
  -- Statusline (replaces vim-airline; theme follows catppuccin)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  -- Rainbow parentheses (maintained replacement for luochen1990/rainbow)
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("rainbow-delimiters.setup").setup({})
    end,
  },

  -- Undo tree (<F5> / ,u — same keys as ~/.vimrc's Mundo)
  {
    "mbbill/undotree",
    keys = {
      { "<F5>", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
    },
    init = function()
      vim.g.undotree_ShortIndicators = 1
    end,
  },
}
