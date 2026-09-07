return {
  -- Git signs in the gutter (replaces vim-gitgutter; ]c [c ,hn ,hp kept)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
      local map = vim.keymap.set
      map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true, desc = "Next hunk" })
      map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true, desc = "Prev hunk" })
      map("n", "<leader>hn", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next hunk" })
      map("n", "<leader>hp", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Prev hunk" })
      map("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
      map("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
      map("n", "<leader>hb", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame line" })
    end,
  },

  -- Git wrapper (:Git, :G) — same as ~/.vimrc
  { "tpope/vim-fugitive", cmd = { "Git", "G", "Gvdiffsplit", "Gread", "Gwrite" } },
}
