local opt = vim.opt

-- Leader must be set before plugins load. Kept as ',' to match ~/.vimrc muscle memory.
vim.g.mapleader = ","
vim.g.maplocalleader = ","

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
-- shiftwidth/expandtab auto-detected per project by vim-sleuth
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

opt.splitright = true
opt.splitbelow = true
opt.termguicolors = true

opt.undofile = true
opt.undodir = vim.fn.expand("~/.vimundo")

opt.scrolloff = 8
opt.sidescrolloff = 8
opt.updatetime = 250
opt.timeoutlen = 400
opt.history = 10000
opt.virtualedit = "onemore"

-- Ported from ~/.vimrc: wide textwidth with a marker column
opt.textwidth = 119
opt.colorcolumn = "+1"
vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 233, default = true })

opt.wrap = false
opt.showbreak = "↪ "
opt.list = true
opt.listchars = "tab:▸ ,extends:❯,precedes:❮,trail:·,nbsp:×"

-- Backups/swap/undo outside the repo (dirs created in autocmds.lua)
opt.backup = true
opt.writebackup = true
opt.backupdir = vim.fn.expand("~/.vimbackup")
opt.directory = vim.fn.expand("~/.vimswap")
opt.backupskip = { "/tmp/*", "/private/tmp/*" }

-- vim-slime: send selections to a tmux pane (C-c C-c), like ~/.vimrc
vim.g.slime_target = "tmux"
