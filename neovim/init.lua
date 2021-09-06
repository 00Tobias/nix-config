local opt = vim.opt

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Map leader to space
vim.g.mapleader = " "

opt.termguicolors = true
opt.background = "dark"

opt.number = true
opt.relativenumber = true
vim.cmd([[
    augroup numbertoggle
        autocmd!
        autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
        autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
    augroup END
]])

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
