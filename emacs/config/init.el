;;; init.el -*- lexical-binding: t; -*-

(doom! :input
       :completion
       (company +childframe)
       (vertico +icons)

       :ui
       doom
       hl-todo
       indent-guides
       modeline
       ophints
       (popup +defaults)
       (treemacs +lsp)
       vc-gutter
       window-select

       :editor
       (evil +everywhere)
       file-templates
       (format +onsave)
       multiple-cursors
       ;; objed
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
       (spell +aspell)
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
       nix
       (org +brain +dragndrop +pandoc +pretty +roam2)
       (python +lsp)
       (rust +lsp)
       (sh +lsp)
       (zig +lsp)

       :email
       (mu4e +org)

       :app
       calendar
       emms

       :config
       literate
       (default +bindings +smartparens))
