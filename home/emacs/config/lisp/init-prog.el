;; Automatically start flymake
(add-hook 'emacs-lisp-mode-hook 'flymake-mode)

;; Automatically start Eglot on supported modes
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'nix-mode-hook 'eglot-ensure)
(add-hook 'racket-mode-hook 'eglot-ensure)
(add-hook 'rust-mode-hook 'eglot-ensure)
(add-hook 'rustic-mode-hook 'eglot-ensure)
(add-hook 'zig-mode-hook 'eglot-ensure)

;; Rustic should use Eglot
;; (setq rustic-lsp-client 'eglot)

;; Enable yasnippet for snippets
(yas-global-mode 1)

;; Enable paredit in lispy modes
(add-hook 'clojure-mode-hook 'enable-paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'hy-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'racket-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook 'enable-paredit-mode)

;; Match pairs using electric-pairs-mode in non-lisp langs
(add-hook 'c-mode-hook 'electric-pair-mode)
(add-hook 'c++-mode-hook 'electric-pair-mode)
(add-hook 'elixir-mode-hook 'electric-pair-mode)
(add-hook 'nix-mode-hook 'electric-pair-mode)
(add-hook 'python-mode-hook 'electric-pair-mode)
(add-hook 'rust-mode-hook 'electric-pair-mode)
(add-hook 'rustic-mode-hook 'electric-pair-mode)
(add-hook 'shell-mode-hook 'electric-pair-mode)
(add-hook 'zig-mode-hook 'electric-pair-mode)

;; Use Apheleia for automatically formatting buffers in prog-mode
(require 'apheleia)
(add-hook 'prog-mode-hook 'apheleia-mode)

;; Add zprint for formatting Clojure code to Apheleia
(push '(zprint . ("zprint"))
      apheleia-formatters)
(push '(clojure-mode . (zprint))
      apheleia-mode-alist)

;; Add nixpkgs-fmt to Apheleia
(push '(nixpkgs-fmt . ("nixpkgs-fmt"))
      apheleia-formatters)
(push '(nix-mode . (nixpkgs-fmt))
      apheleia-mode-alist)

;; Add raco fmt to Apheleia
(push '(racofmt . ("raco" "fmt"))
      apheleia-formatters)
(push '(racket-mode . (racofmt))
      apheleia-mode-alist)

;; Add zig fmt to Apheleia
(push '(zigfmt . ("zig" "fmt"))
      apheleia-formatters)
(push '(zig-mode . (zigfmt))
      apheleia-mode-alist)

;; Autostart Geiser REPL if none is running
(setq geiser-mode-start-repl-p t)

;; Don't query for killing the REPL process on exit
(setq geiser-repl-query-on-exit-p t)

;; Enable rainbow-delimiters
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Enable Aggressive indentation
(global-aggressive-indent-mode 1)

;; Highlight trailing whitespace
(add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))

;; Use spaces for indentation.
(setq-default indent-tabs-mode nil)

;; Set width of indent
(setq-default tab-width 4)
(setq standard-indent 4)

(provide 'init-prog)
