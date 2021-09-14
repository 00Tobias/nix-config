local opt = vim.opt

-- Map leader to space
vim.g.mapleader = " "

opt.termguicolors = true
opt.background = "dark"

opt.relativenumber = true

opt.mouse = "a"
opt.incsearch = true
opt.hlsearch = true

opt.scrolloff = 4
opt.sidescrolloff = 4

opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4

vim.cmd("autocmd FileType nix setlocal shiftwidth=2 softtabstop=2 expandtab")
