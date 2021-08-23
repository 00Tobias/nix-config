;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.

;; Tree-sitter
(package! tree-sitter)
(package! tree-sitter-langs)

;; Eva
(package! eva
  :recipe (:host github :repo "meedstrom/eva"
           :files (:defaults "assets"  "renv" "*.R" "*.gnuplot")))

;;; Kakoune
;; (package! visual-regexp)
;; (package! phi-search)
;; (package! undo-tree)
;; (package! kakoune)

;; (package! windower)
