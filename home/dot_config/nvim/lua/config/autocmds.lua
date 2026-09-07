-- Create backup/swap/undo dirs (mirrors the mkdir loop in ~/.vimrc)
local state_dirs = { "~/.vimbackup", "~/.vimswap", "~/.vimundo" }
for _, dir in ipairs(state_dirs) do
  local expanded = vim.fn.expand(dir)
  if vim.fn.isdirectory(expanded) == 0 then
    vim.fn.mkdir(expanded, "p")
  end
end

local group = vim.api.nvim_create_augroup("user_config", { clear = true })

-- Reload files changed outside nvim (replaces djoshea/vim-autoread)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = group,
  command = "checktime",
})

-- Strip trailing whitespace on save (same filetypes as ~/.vimrc)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = { "*.c", "*.cpp", "*.java", "*.php", "*.js", "*.py", "*.twig", "*.vim", "*.xml", "*.yml", "*.yaml" },
  callback = function(args)
    vim.cmd("keeppatterns %s/\\s\\+$//e")
  end,
})

-- LSP keymaps + diagnostics display
vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    local map = vim.keymap.set
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gD", vim.lsp.buf.declaration, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "gi", vim.lsp.buf.implementation, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = event.buf, desc = "Rename symbol" })
    map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf, desc = "Code action" })
    map("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end,
      { buffer = event.buf, desc = "Format buffer" })
    map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
    map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded" },
})
