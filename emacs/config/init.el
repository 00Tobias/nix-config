;;; init.el -*- lexical-binding: t; -*-

(doom! :input
       :completion
       (company +childframe)
       ;; (ivy +fuzzy +prescient +icons)
       (vertico +icons)

       :ui
       doom
       doom-dashboard
       doom-quit
       hl-todo
       indent-guides
       minimap
       modeline
       nav-flash
       ophints
       (popup +defaults)
       tabs
       (treemacs +lsp)
       vc-gutter
       window-select
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       multiple-cursors
       (parinfer +rust)
       snippets

       :emacs
       (dired +icons)
       electric
       (ibuffer +icons)
       (undo +tree)
       vc

       :term
       eshell
       vterm

       :checkers
       (syntax +childframe)
       spell
       grammar

       :tools
       (debugger +lsp)
       editorconfig
       (eval +overlay)
       (lookup +dictionary +offline)
       (lsp +peek)
       magit
       make
       pass
       rgb

       :os

       :lang
       (cc +lsp)
       common-lisp
       emacs-lisp
       json
       (lua +lsp +fennel)
       (markdown +grip)
       nix
       (org +pretty)
       (python +lsp)
       (rust +lsp)
       (sh +lsp)
       (zig +lsp)

       :email

       :app
       calendar
       emms
       twitter

       :config
       literate
       (default +bindings +smartparens))
