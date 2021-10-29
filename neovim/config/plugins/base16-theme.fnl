(module plugins.base16-theme
  {autoload {nvim aniseed.nvim
             colors colors ; Generated from colors.nix
             base16 base16-colorscheme}})

(base16.setup {:base00 colors.background
               :base01 colors.darkerGrey
               :base02 colors.darkGrey
               :base03 colors.grey
               :base04 colors.lightGrey
               :base05 colors.lighterGrey
               :base06 colors.lightestGrey
               :base07 colors.foreground
               :base08 colors.red
               :base09 colors.orange
               :base0A colors.yellow
               :base0B colors.green
               :base0C colors.teal
               :base0D colors.blue
               :base0E colors.magenta
               :base0F colors.deepRed})

(fn bg [group color]
  (vim.cmd (.. "hi " group " guibg=" color)))
(fn fg [group color]
  (vim.cmd (.. "hi " group " guifg=" color)))

;; Darken background of nvim-tree
(bg :NvimTreeNormal colors.black)

;; Hide splitter between nvim-tree
(bg :NvimTreeVertSplit colors.black)
(fg :NvimTreeVertSplit colors.black)
(bg :NvimTreeStatusLineNC colors.black)
(fg :NvimTreeStatusLineNC colors.black)

;; Hide path at the top of nvim-tree
(fg :NvimTreeRootFolder colors.black)

(fg :EndOfBuffer colors.background)

(fg :StatusLineNC (.. colors.darkerGrey " gui=underline"))
(bg :StatusLine colors.background)
(fg :VertSplit colors.lighterBlack)

;; Set a darker terminal background, similar to Doom Emacs' solaire-mode
;; TODO: augroup this
(vim.cmd (.. "hi " :TermBg " guibg=" colors.black))
(nvim.ex.autocmd :TermOpen "*" ":set winhighlight=Normal:TermBg")

;; Disables line numbers in :term
(nvim.ex.autocmd :TermOpen "*" "setlocal nonumber norelativenumber")
