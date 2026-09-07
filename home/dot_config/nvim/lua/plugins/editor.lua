return {
  -- Discover keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Surround (keeps ~/.vimrc vim-surround keys: ysiw", cs"', ds")
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  -- Commenting (gc / gcc, replaces nerdcommenter) + autopairs
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.comment").setup()
      require("mini.pairs").setup()
    end,
  },

  -- Motion (replaces easymotion): s to jump anywhere, S for treesitter scope
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote flash" },
    },
  },

  -- Heuristically set shiftwidth/expandtab per buffer (same as ~/.vimrc)
  { "tpope/vim-sleuth", event = { "BufReadPre", "BufNewFile" } },

  -- :Abolish, :Subvert, crs/crm/cru coercion (same as ~/.vimrc)
  { "tpope/vim-abolish", event = "VeryLazy" },
}
