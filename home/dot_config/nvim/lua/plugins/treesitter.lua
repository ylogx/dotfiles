return {
  -- Structural syntax highlighting (main branch: highlighting is native once
  -- parsers are installed; there is no ensure_installed — install on load)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local ts = require("nvim-treesitter")
      local wanted = {
        "bash", "dockerfile", "go", "gomod", "gosum", "html", "javascript",
        "json", "jsonc", "lua", "luadoc", "markdown", "markdown_inline",
        "python", "ruby", "rust", "toml", "tsx", "typescript", "vim",
        "vimdoc", "yaml",
      }
      local missing = vim.tbl_filter(function(lang)
        return not vim.list_contains(ts.get_installed(), lang)
      end, wanted)
      if #missing > 0 then
        ts.install(missing)
      end
    end,
  },
}
