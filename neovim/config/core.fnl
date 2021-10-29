(module core
  {autoload {nvim aniseed.nvim}})

(set nvim.o.termguicolors true)
(set nvim.o.background "dark")

(set nvim.o.mouse "a")
(set nvim.g.mapleader " ")
(set nvim.g.maplocalleader ",")

(set nvim.o.number true)
(set nvim.o.relativenumber true)
(set nvim.o.incsearch true)
(set nvim.o.hlsearch true)

(set nvim.o.scrolloff 4)
(set nvim.o.sidescrolloff 4)

(set nvim.o.autoindent true)
(set nvim.o.expandtab true)
(set nvim.o.shiftwidth 4)
(set nvim.o.softtabstop 4)

(vim.cmd "autocmd FileType nix setlocal shiftwidth=2 softtabstop=2 expandtab")
