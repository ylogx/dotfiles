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
        "json", "lua", "luadoc", "markdown", "markdown_inline",
        "python", "ruby", "rust", "toml", "tsx", "typescript", "vim",
        "vimdoc", "yaml",
      }
      local missing = vim.tbl_filter(function(lang)
        return not vim.list_contains(ts.get_installed(), lang)
      end, wanted)
      if #missing == 0 then
        return
      end
      -- Parser compilation needs a current tree-sitter CLI (apt ships 0.20,
      -- too old); without it, fall back to regex highlighting gracefully
      if not vim.fn.executable("tree-sitter") then
        vim.notify_once(
          "nvim-treesitter: 'tree-sitter' CLI not found, skipping parser install",
          vim.log.levels.WARN
        )
        return
      end
      ts.install(missing)
    end,
  },
}
