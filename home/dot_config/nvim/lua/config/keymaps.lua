local map = vim.keymap.set

-- Clear search highlights
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Don't lose selection when indenting in visual mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Tabs (same muscle memory as ~/.vimrc)
map("n", "th", ":tabfirst<CR>")
map("n", "tj", ":tabnext<CR>")
map("n", "tk", ":tabprev<CR>")
map("n", "tl", ":tablast<CR>")
map("n", "tt", ":tabedit <Space>")
map("n", "tn", ":tabnext <Space>")
map("n", "tm", ":tabm <Space>")
map("n", "td", ":tabclose<CR>")

-- Relative-number toggle (was C-n in ~/.vimrc)
local function number_toggle()
  if vim.opt.relativenumber:get() then
    vim.opt.relativenumber = false
  else
    vim.opt.relativenumber = true
  end
end
map("n", "<C-n>", number_toggle, { desc = "Toggle relative numbers" })

-- Reformat entire file, keep cursor position (was F7 in ~/.vimrc)
map("n", "<F7>", "mzgg=G`z", { desc = "Reformat file" })

-- Allow saving as sudo if opened without (was w!! in ~/.vimrc)
map("c", "w!!", "w !sudo tee > /dev/null %", { desc = "Write as sudo" })

-- File tree / undo tree aliases live with their plugins (lazy key specs)
